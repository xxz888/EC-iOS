//
//  MCUserInfoViewController.m
//  MCOEM
//
//  Created by wza on 2020/4/16.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCUserInfoViewController.h"
#import "MCBindALIViewController.h"
@interface MCUserInfoViewController () <QMUITableViewDataSource, QMUITableViewDelegate>

@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, copy) NSString *aliPhone;

@end

@implementation MCUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarTitle:@"个人信息" tintColor:UIColor.whiteColor];
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.mj_header = nil;
    self.mc_tableview.separatorInset = UIEdgeInsetsZero;
    self.aliPhone = @"未绑定";
    [self reloadData];
//    [self refreshVC];
    
    
}
-(void)refreshVC{
    
    self.dataArray = @[
        @{@"title":@"昵称",
          @"subTitle":SharedUserInfo.nickname ?:@"请填写昵称"},
    @{@"title":@"姓名",
      @"subTitle":SharedUserInfo.realname?:@""},
    @{@"title":@"手机号",
      @"subTitle":SharedUserInfo.phone?:@""},
    @{@"title":@"ID编号",
      @"subTitle":SharedUserInfo.userid?:@""},
    @{@"title":@"注册日期",
      @"subTitle":SharedUserInfo.cTime?:@""},
    @{@"title":@"实名状态",
      @"subTitle":SharedUserInfo.realnameStatusName?:@""},
    /*@{@"title":@"提现手续费",
      @"subTitle":[NSString stringWithFormat:@"%@元/笔",SharedUserInfo.withdrawFee]}*/
    ];
    [self.mc_tableview reloadData];
}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self requestAliPhone];
//}
- (void)requestAliPhone {
    NSString *userId = SharedUserInfo.userid;
    NSDictionary *defaultCardDic = @{@"userId":userId, @"type":@"3", @"nature":@"0", @"isDefault":@"1"};
    __weak __typeof(self)weakSelf = self;
    [MCSessionManager.shareManager mc_POST:@"/user/app/bank/query/byuseridandtype/andnature" parameters:defaultCardDic ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *result = resp.result;
        NSDictionary *dict = result.firstObject;
        NSString *cardNo = [NSString stringWithFormat:@"%@", dict[@"cardNo"]];
        
        NSString *first = [cardNo substringWithRange:NSMakeRange(0, 3)];
        NSString *last = [cardNo substringFromIndex:cardNo.length-4];
        
        weakSelf.aliPhone = [NSString stringWithFormat:@"%@ **** %@", first, last];
        [weakSelf.mc_tableview reloadData];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == self.dataArray.count - 1) {
//        return 10;
//    } else {
//        return 1;
//    }
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == self.dataArray.count - 1) {
//        UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//        head.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        return head;
//    }
//    return nil;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = UIColorGrayDarken;
        cell.detailTextLabel.textColor = UIColorGrayDarken;
    }
    
    NSString *tit = [self.dataArray[indexPath.section] objectForKey:@"title"];
    NSString *subTit = [self.dataArray[indexPath.section] objectForKey:@"subTitle"];
    cell.textLabel.text = tit;
//    if (indexPath.section == self.dataArray.count - 1) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        NSDictionary *detailStr = self.dataArray[indexPath.section];
//        if ([detailStr[@"subTitle"] isEqualToString:@"未绑定"]) {
//            cell.detailTextLabel.textColor = [UIColor qmui_colorWithHexString:@"#F22D2D"];
//        }
//        cell.detailTextLabel.text = self.aliPhone;
//    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = subTit;
//    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
            QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleAlert];
        UITextField * tf = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        tf.borderStyle = UITextBorderStyleRoundedRect;
        tf.placeholder = @"请输入要修改的昵称";
        tf.text = SharedUserInfo.nickname;
        tf.font = [UIFont systemFontOfSize:15];
        [alert addCustomView:tf];
        __weak typeof(self) weakSelf = self;

            [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
            [alert addAction:[QMUIAlertAction actionWithTitle:@"确认" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
                if (tf.text.length == 0) {
                    [MCToast showMessage:@"请输入要修改的用户名"];
                    return;
                }
                
                [MCSessionManager.shareManager mc_POST:@"/user/app/update/users/nick/name" parameters:@{@"nickName":tf.text} ok:^(MCNetResponse * _Nonnull resp) {
                    //删除成功发送一个通知让 KDWebContainer 重新设置
                    [MCToast showMessage:@"修改成功"];
                    [weakSelf reloadData];
                }];
            }]];
            [alert showWithAnimated:YES];
    }
//    if (indexPath.section == self.dataArray.count - 1) {
//        [MCVerifyStore verifyRealName:^(MCUserInfo * _Nonnull userinfo) {
//            [self.navigationController pushViewController:[MCBindALIViewController new] animated:YES];
//        }];
//
//    }
}
- (void)reloadData {
    // 头部数据
    __weak typeof(self) weakSelf = self;
    [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
        SharedUserInfo = userInfo;
        [weakSelf refreshVC];
    }];
}
@end
