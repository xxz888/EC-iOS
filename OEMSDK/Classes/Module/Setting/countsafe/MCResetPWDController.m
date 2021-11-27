//
//  MCResetPWDController.m
//  MCOEM
//
//  Created by wza on 2020/4/21.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCResetPWDController.h"
#import "MCSMSController.h"
#import "KDFillButton.h"

@interface MCResetPWDController () <QMUITableViewDataSource, QMUITableViewDelegate>

@property(nonatomic, assign) MCResetPWDType type;

@property(nonatomic, strong) NSArray *dataSource;

@property(nonatomic, strong) QMUITextField *fieldNew;
@property(nonatomic, strong) QMUITextField *fieldSure;

@property(nonatomic, strong) UIView *footView;

@property (nonatomic, strong) MCUserInfo *userInfo;
@end

@implementation MCResetPWDController

- (instancetype)initWithType:(MCResetPWDType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        
        KDFillButton *logoutBtn = [[KDFillButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 50)];
        logoutBtn.layer.cornerRadius = logoutBtn.height / 2;
        
        logoutBtn.center = _footView.center;
        [logoutBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_footView addSubview:logoutBtn];
        [logoutBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footView;
}
- (QMUITextField *)fieldNew {
    if (!_fieldNew) {
        _fieldNew = [[QMUITextField alloc] init];
        if (self.type == MCResetPWDTypeTrade) {
            _fieldNew.placeholder = @"请输入您新的交易密码";
            _fieldNew.keyboardType = UIKeyboardTypeNumberPad;
        } else {
            _fieldNew.placeholder = @"请输入您新的登录密码";
            _fieldNew.keyboardType = UIKeyboardTypeDefault;
        }
        _fieldNew.font = UIFontMake(14);
        _fieldNew.secureTextEntry = YES;
        _fieldNew.adjustsFontSizeToFitWidth = YES;
    }
    return _fieldNew;
}
- (QMUITextField *)fieldSure {
    if (!_fieldSure) {
        _fieldSure = [[QMUITextField alloc] init];
        if (self.type == MCResetPWDTypeTrade) {
            _fieldSure.placeholder = @"请再次输入您的交易密码";
            _fieldSure.keyboardType = UIKeyboardTypeNumberPad;
        } else {
            _fieldSure.placeholder = @"请再次输入您的登录密码";
            _fieldSure.keyboardType = UIKeyboardTypeDefault;
        }
        _fieldSure.secureTextEntry = YES;
        _fieldSure.font = UIFontMake(14);
        _fieldSure.adjustsFontSizeToFitWidth = YES;
    }
    return _fieldSure;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.separatorInset = UIEdgeInsetsZero;
    self.mc_tableview.mj_header = nil;
    self.mc_tableview.tableFooterView = self.footView;
    NSString *typeName = (self.type == MCResetPWDTypeTrade)?@"设置交易密码":@"重置登录密码";
    [self setNavigationBarTitle:typeName tintColor:nil];
    self.dataSource = @[
    @{@"title":@"新密码",
      @"textField":self.fieldNew
    },
    @{@"title":@"确认密码",
      @"textField":self.fieldSure
    }];
    [self.mc_tableview reloadData];
    
    [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
        self.userInfo = userInfo;
    }];
}

- (void)next:(QMUIButton *)sender {
    if (!self.fieldNew.text || !self.fieldSure.text) {
        [MCToast showMessage:@"请输入新密码和确认密码"];
        return;
    }
    if (![self.fieldSure.text isEqualToString:self.fieldNew.text]) {
        [MCToast showMessage:@"新密码和确认密码不一致"];
        return;
    }
    if (self.type == MCResetPWDTypeLogin) {
        if (self.fieldNew.text.length < 6 || self.fieldNew.text.length > 18) {
            [MCToast showMessage:@"登录密码长度为6-18位！"];
            return;
        }
    } else {
        if (self.fieldNew.text.length != 6) {
            [MCToast showMessage:@"交易密码长度为6位！"];
            return;
        }
    }
    
    //发短信
    NSDictionary *param = @{@"phone":self.userInfo.phone,
                            @"brand_id":BCFI.brand_id};
    
    [MCSessionManager.shareManager mc_GET:@"/notice/app/sms/send" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        [MCToast showMessage:@"验证码已发送，若未收到请稍等或检查手机网络后重试"];
        MCSMSController *vc = [[MCSMSController alloc] initWithType:self.type password:self.fieldNew.text];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    QMUILabel *label = [[QMUILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 30)];
    label.qmui_centerY = cell.qmui_centerY;
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = UIColorBlack;
    label.font = UIFontMake(15);
    [cell addSubview:label];
    label.text = [self.dataSource[indexPath.row] objectForKey:@"title"];
    if (indexPath.row == 0) {
        self.fieldNew.frame = CGRectMake(label.qmui_right+15, 0, SCREEN_WIDTH-label.qmui_right-30, 30);
        self.fieldNew.qmui_centerY = cell.qmui_centerY;
        [cell.contentView addSubview:self.fieldNew];
    } else {
        self.fieldSure.frame = CGRectMake(label.qmui_right+15, 0, SCREEN_WIDTH-label.qmui_right-30, 30);
        self.fieldSure.qmui_centerY = cell.qmui_centerY;
        [cell.contentView addSubview:self.fieldSure];
    }
    
    
    return cell;
}



@end
