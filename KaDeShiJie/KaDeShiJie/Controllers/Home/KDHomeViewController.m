//
//  KDHomeViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/5.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDHomeViewController.h"
#import "KDHomeHeaderView.h"
#import "MCHomeServiceViewController.h"
#import "MQServiceToViewInterface.h"
#import <MeiQiaSDK/MQDefinition.h>
#import "KDGuidePageManager.h"

@interface KDHomeViewController ()
@property(nonatomic, strong) QMUIModalPresentationViewController *withdrawTypeModal;
@property (nonatomic, strong) KDHomeHeaderView *headerView;
@property (nonatomic, strong) UILabel *redMessageLbl;//未读消息小红点


@property(nonatomic, assign) BOOL updateViewIsShow;

@end

@implementation KDHomeViewController

- (KDHomeHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[KDHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabBarHeight)];
    }
    return _headerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateNavigationBarAppearance];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBannerImage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMQMessages:) name:MQ_RECEIVED_NEW_MESSAGES_NOTIFICATION object:nil];

    
    [self.navigationController.tabBarController.tabBar setHidden:NO];

    //请求未读消息
    [self requestGetUnreadMessages];

    //开始弹出各种弹框
    [self openEveryAlert1];
   
    
}
//开始弹出各种弹框  1、版本升级 2、实名认证 3、银行卡认证 4、消息公告
-(void)openEveryAlert1{
    //弹窗优先级 1、版本升级 2、实名认证 3、银行卡认证 4、消息公告
    if (!MCModelStore.shared.updateViewIsShow) {
        kWeakSelf(self);
        MCModelStore.shared.updateViewIsShow = YES;
        [MCModelStore.shared reloadBrandInfo:^(MCBrandInfo * _Nonnull brandInfo) {
            NSString *remoteVersion = brandInfo.iosVersion;
            NSString *localVersion = SharedAppInfo.version;
            NSComparisonResult result = [remoteVersion compare:localVersion options:NSNumericSearch];
            if (result == NSOrderedDescending) {
                MCUpdateAlertView *updateView = [[[NSBundle OEMSDKBundle] loadNibNamed:@"MCUpdateAlertView" owner:nil options:nil] firstObject];
                NSString * str = [brandInfo.iosContent stringByReplacingOccurrencesOfString:@"，" withString:@"\n"];
                [updateView showWithVersion:remoteVersion content:str downloadUrl:brandInfo.iosDownload isForce:YES];
            }else{
                //如果不需要版本升级，就要开始查询是否需要实名认证
                [weakself openEveryAlert2];
            }
        }];
    }else{
        //如果不需要版本升级，就要开始查询是否需要实名认证
        [self openEveryAlert2];
    }
}
//2、实名认证 3、银行卡认证
-(void)openEveryAlert2{
    //实名成功的认证
    kWeakSelf(self);
    BOOL isFIRSTSHIMING = [[NSUserDefaults standardUserDefaults] boolForKey:@"FIRSTSHIMING"];
    BOOL isFIRSTWEISHIMING = [[NSUserDefaults standardUserDefaults] boolForKey:@"FIRSTWEISHIMING"];

    [MCModelStore.shared reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
        // 已实名，未认证，退出再进，划掉app再进，都要弹框
        if ([userInfo.realnameStatus integerValue] == 1 && [userInfo.verificationStatus integerValue] == 0 && isFIRSTSHIMING) {
            // @"恭喜您已实名完成,接下来将指引您完成信用卡认证,认证完成可获得奖励";
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FIRSTSHIMING"];
            [weakself addRenZhengTongZhi];
        }
        // 未实名要未实名弹框
        if ([userInfo.realnameStatus integerValue] != 0 && isFIRSTWEISHIMING) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FIRSTWEISHIMING"];
            [[KDGuidePageManager shareManager] requestShiMing:^{}];
        }
        //如果实名和认证都有了就直接查询消息
        if ([userInfo.realnameStatus integerValue] == 1 && [userInfo.verificationStatus integerValue] == 1) {
            [weakself showAlertView];
        }
    }];
}
//实名认证完成的通知
-(void)addRenZhengTongZhi{
    kWeakSelf(self);
    NSString *msg = @"恭喜您注册实名成功，请认证信用卡，首刷认证后可获得10元奖励";
    QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:QMUIAlertControllerStyleAlert];
    [alert addAction:[QMUIAlertAction actionWithTitle:@"下次认证" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ISNEEDZHIYIN"];
        [weakself showAlertView];
    }]];
    [alert addAction:[QMUIAlertAction actionWithTitle:@"开始认证" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISNEEDZHIYIN"];

        [weakself showGuidePage];
    }]];
    [alert showWithAnimated:YES];
}

// 监听收到美洽聊天消息的广播
- (void)didReceiveNewMQMessages:(NSNotification *)notification {
    //请求未读消息
    [self requestGetUnreadMessages];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SHIMINGCHENGGONG" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadBannerImage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MQ_RECEIVED_NEW_MESSAGES_NOTIFICATION object:nil];
    
}
-(void)requestGetUnreadMessages{
    kWeakSelf(self);
    [MQServiceToViewInterface getUnreadMessagesWithCompletion:^(NSArray *messages, NSError *error) {
        if ([messages count] == 0) {
            weakself.redMessageLbl.hidden = YES;
            weakself.redMessageLbl.text = @"";
            
            [weakself requestQueryFangLiuYan];
        }else{
            weakself.redMessageLbl.hidden = NO;
            weakself.redMessageLbl.text = @"";
        }
        
    }];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.mc_tableview.tableHeaderView = self.headerView;
    self.mc_tableview.backgroundColor = [UIColor whiteColor];
    
    
    
    __weak typeof(self) weakSelf = self;
    self.headerView.callBack = ^(CGFloat viewHig) {
        weakSelf.headerView.ly_height = viewHig;
    };
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBannerImage" object:nil];
        //请求未读消息
        [weakSelf requestGetUnreadMessages];
        [weakSelf.mc_tableview.mj_header endRefreshing];
    }];
    [self setNavigationBarTitle:@"首页" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    
    QMUIButton *kfBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [kfBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [kfBtn setTitle:@"客服" forState:UIControlStateNormal];
    [kfBtn addTarget:self action:@selector(clickKFAction) forControlEvents:UIControlEventTouchUpInside];
    kfBtn.spacingBetweenImageAndTitle = 5;
    kfBtn.titleLabel.font = LYFont(13);
    [kfBtn setImage:[UIImage imageNamed:@"kd_home_kf"] forState:UIControlStateNormal];
    kfBtn.frame = CGRectMake(SCREEN_WIDTH - 84, StatusBarHeight, 64, 44);
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:kfBtn];
    
    
    
    [kfBtn addSubview:self.redMessageLbl];
    
    // 抽奖 暂时隐藏
    //    QMUIModalPresentationViewController *diaVC = [[QMUIModalPresentationViewController alloc] init];
    //    self.withdrawTypeModal = diaVC;
    //    UIButton *content = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [content setBackgroundImage:[UIImage imageNamed:@"kd_home_choujiang"] forState:UIControlStateNormal];
    //    content.contentEdgeInsets = UIEdgeInsetsMake(0, 81, 0, 81);
    //    diaVC.contentView = content;
    //
    //    [diaVC showWithAnimated:YES completion:nil];
    
    //查询是否实名
   
    //新手指引遮罩
//    [self showGuidePage];
}
-(UILabel *)redMessageLbl{
    if (!_redMessageLbl) {
        _redMessageLbl = [[UILabel alloc]init];
        _redMessageLbl.backgroundColor = KRedColor;
        ViewRadius(_redMessageLbl, 4);
        _redMessageLbl.textColor = KWhiteColor;
        _redMessageLbl.text = @"";
        _redMessageLbl.hidden = YES;
        _redMessageLbl.textAlignment = NSTextAlignmentCenter;
        _redMessageLbl.font = [UIFont boldSystemFontOfSize:9];
        _redMessageLbl.frame = CGRectMake(22, 9, 8, 8);
    }
    return _redMessageLbl;
}
- (void)layoutTableView
{
    self.mc_tableview.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop);
}
- (void)clickKFAction
{
    [self.navigationController pushViewController:[[MCHomeServiceViewController alloc] init] animated:YES];
    //    [MCServiceStore pushMeiqiaVC];
}

-(void)requestQueryFangLiuYan{
    __weak typeof(self) weakSelf = self;
    [MCSessionManager.shareManager mc_POST:@"/user/app/jpush/MessagePush/Query" parameters:@{@"userid":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull resp) {
        if ([resp.code isEqualToString:@"000000"]) {
            //这里判断未读数组，把未读变成已读
            NSMutableArray * type2Array = [[NSMutableArray alloc]init];
            for (NSDictionary * typeDic in resp.result) {
                if ([typeDic[@"type"] integerValue] == 0) {
                    [type2Array addObject:typeDic];
                }
            }
            
            if (type2Array.count == 0) {
                weakSelf.redMessageLbl.hidden = YES;
                weakSelf.redMessageLbl.text = @"";
            }else{
                weakSelf.redMessageLbl.hidden = NO;
                weakSelf.redMessageLbl.text = @"";
            }
            
        }
    }];
}

-(void)requestIsShiMing{
}
-(void)showAlertView{
    [[KDLoginTool shareInstance] requestPlatform:YES];
}
-(void)showGuidePage{
    UIButton * btn = [self.headerView viewWithTag:102];
    //空白的frame
    CGRect emptyRect = CGRectMake(0, kTopHeight+29, btn.size_sd.width, btn.size_sd.height);
    //图片的frame
    CGRect imgRect = CGRectMake(btn.size_sd.width/2, kTopHeight+35+btn.size_sd.height, kRealWidthValue(200), kRealWidthValue(200)*1417/1890);
    kWeakSelf(self);
    [[KDGuidePageManager shareManager] showGuidePageWithType:KDGuidePageTypeHome emptyRect:emptyRect imgRect:imgRect imgStr:@"guide1" completion:^{
        [weakself.headerView btnAction:[weakself.headerView viewWithTag:102]];
    }];
}
@end
