//
//  MCForgetPWDViewController.m
//  MCOEM
//
//  Created by SS001 on 2020/3/31.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCForgetPWDViewController.h"
#import "MCChangePwdViewController.h"

@interface MCForgetPWDViewController ()
@property (nonatomic, strong) UIView *contentView;
@end

@implementation MCForgetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setNavigationBarTitle:@"忘记登录密码" tintColor:nil];
    [self setupView];
}

- (void)setupView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(240);
        make.top.mas_equalTo(NavigationContentTop);
    }];
    NSArray *titleArray = @[@"手机号", @"新密码", @"确认密码"];
    NSArray *placeholderArr = @[@"请输入您的手机号码", @"请输入您新的登录密码", @"请再次输入您新的登录密码"];
    NSArray *maxCount = @[@"11", @"16", @"16"];
    for (int i = 0; i < titleArray.count; i++) {
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(i * 80);
            make.height.mas_equalTo(1);
        }];
        
        UILabel *titleView = [[UILabel alloc] init];
        titleView.text = titleArray[i];
        titleView.textAlignment = NSTextAlignmentRight;
        titleView.font = LYFont(16);
        [contentView addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(120);
            make.top.mas_equalTo(30 + i * 80);
        }];
        
        QMUITextField *textField = [[QMUITextField alloc] init];
        textField.placeholder = placeholderArr[i];
        textField.font = LYFont(16);
        textField.tag = 100 + i;
        textField.maximumTextLength = [maxCount[i] intValue];
        [contentView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleView.mas_right).mas_equalTo(8);
            make.centerY.equalTo(titleView);
            make.right.mas_equalTo(-27 * MCSCALE);
        }];
        textField.secureTextEntry = i>0;
    }
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.layer.cornerRadius = 8;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickNextBtn) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setBackgroundColor:UIColor.mainColor];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(27 * MCSCALE);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(40);
        make.top.equalTo(contentView.mas_bottom).mas_equalTo(30);
    }];
}

- (void)clickNextBtn
{
    NSString *phone = ((QMUITextField *)[self.contentView viewWithTag:100]).text;
    NSString *newPwd = ((QMUITextField *)[self.contentView viewWithTag:101]).text;
    NSString *surePwd = ((QMUITextField *)[self.contentView viewWithTag:102]).text;
    if (phone.length != 11) {
        [MCToast showMessage:@"请输入有效手机号"];
        return;
    }
    if (newPwd.length < 6 || surePwd.length < 6) {
        [MCToast showMessage:@"请输入有效密码(特殊字符无效)"];
        return;
    }
    if (![newPwd isEqualToString:surePwd]) {
        [MCToast showMessage:@"确认密码不一致!"];
        return;
    }
    NSDictionary *sendDic = @{@"phone":phone, @"brand_id":MCModelStore.shared.brandConfiguration.brand_id};
        
    MCChangePwdViewController *msvc = MCChangePwdViewController.new;
    msvc.index = 0;
    msvc.nowDataString = newPwd;
    msvc.phone = phone;
    [self.navigationController pushViewController:msvc animated:YES];
}
@end
