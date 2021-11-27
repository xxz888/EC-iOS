//
//  MCSettingViewController.m
//  MCOEM
//
//  Created by wza on 2020/4/15.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCSettingViewController.h"
#import <JPush/JPUSHService.h>
#import "MCUpdateAlertView.h"
#import "MCSettingCell.h"
#import "MCAboutViewController.h"
#import "MCApp.h"
#import <WebKit/WebKit.h>
#import "KDFillButton.h"
#import "MCResetPWDController.h"
#import "KDForgetPwdViewController.h"

NSString *const MCSettingItemVersionCheck = @"MCSettingItemVersionCheck";
NSString *const MCSettingItemVoice = @"MCSettingItemVoice";
NSString *const MCSettingItemClearCache = @"MCSettingItemClearCache";
NSString *const MCSettingItemCountSafe = @"MCSettingItemCountSafe";
NSString *const MCSettingItemAboutUs = @"MCSettingItemAboutUs";

@interface MCSettingViewController () <QMUITableViewDelegate, QMUITableViewDataSource>

@property(nonatomic, strong) NSMutableArray<NSDictionary*> *items;
@property(nonatomic, copy) NSArray<NSString *> *types;

@property(nonatomic, strong) UIView *footView;

@end

@implementation MCSettingViewController

- (instancetype)initWithSettingItems:(NSArray<NSString *> *)items {
    self = [super init];
    if (self) {
        self.types = items;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self setNavigationBarTitle:@"设置" tintColor:UIColor.whiteColor];
    self.mc_tableview.delegate = self;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.separatorInset = UIEdgeInsetsZero;
    self.mc_tableview.tableFooterView = self.footView;
    self.mc_tableview.mj_header = nil;
    
    [self setdata];
}

- (void)setdata {
    [self.items removeAllObjects];
    
    [self.items addObject:@{@"imgName":@"set_update",
                            @"title":@"版本更新",
                            @"subTitle":[NSString stringWithFormat:@"v%@",SharedAppInfo.version],
                            @"action":@"checkVersion"
    }];
    
    CGFloat size = [[SDImageCache sharedImageCache] totalDiskSize]/1024/1024;
    [self.items addObject:@{@"imgName":@"set_clean",
                            @"title":@"清理缓存",
                            @"subTitle":[NSString stringWithFormat:@"%.2fM",size],
                            @"action":@"cleanCache"
    }];
    [self.items addObject:@{@"imgName":@"one_mine_icon_safe",
                            @"title":SharedConfig.safe_title,
                            @"subTitle":@"",
                            @"action":@"manageCount"
    }];
    [self.items addObject:@{@"imgName":@"one_mine_icon_loginSafe",
                            @"title":@"设置登录密码",
                            @"subTitle":@"",
                            @"action":@"resetLoginPwd"
    }];
    
    [self.mc_tableview reloadData];
}

- (NSMutableArray<NSDictionary *> *)items {
    if (!_items) {
        _items = [NSMutableArray new];
    }
    return _items;
}

- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        KDFillButton *logoutBtn = [[KDFillButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 50)];
        logoutBtn.layer.cornerRadius = logoutBtn.height/2;
        [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        logoutBtn.center = _footView.center;
        [_footView addSubview:logoutBtn];
        [logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footView;
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *img = [UIImage mc_imageNamed:[self.items[indexPath.row] objectForKey:@"imgName"]];
    NSString *iT = [self.items[indexPath.row] objectForKey:@"title"];
    NSString *iST = [self.items[indexPath.row] objectForKey:@"subTitle"];
    
    
    if ([iT isEqualToString:@"语音提示"]) {
        MCSettingCell *cell = [MCSettingCell voiceCellWithTableView:tableView];
        cell.imgView.image = img;
        cell.titleLab.text = iT;
        
        return cell;
    } else {
        MCSettingCell *cell = [MCSettingCell cellWithTableView:tableView];
        if ([iT isEqualToString:@"关于我们"]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.imgView.image = img;
        cell.titleLab.text = iT;
        cell.subTitleLab.text = iST;
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selStr = [self.items[indexPath.row] objectForKey:@"action"];
    if (selStr && selStr.length > 0) {
        SEL ss = NSSelectorFromString(selStr);
        if (ss) {
            [self performSelector:ss withObject:nil afterDelay:0];
        }
    }
    
}

#pragma mark - Actions
- (void)aboutUs {
    [self.navigationController pushViewController:[MCAboutViewController new] animated:YES];
}
- (void)cleanCache {
    /*清理SDWebImage*/
    [SDImageCache.sharedImageCache clearMemory];
    [SDImageCache.sharedImageCache clearDiskOnCompletion:nil];
    
    /*清理webview*/
    NSSet *websiteDataTypes= [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    __weak __typeof(self)weakSelf = self;
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        [MCToast showMessage:@"清理成功"];
        [weakSelf setdata];
    }];
    
    
    
}
- (void)checkVersion {
    [MCVerifyStore verifyVersionShowToast:YES];
}
- (void)manageCount {
    MCResetPWDController *vc = [[MCResetPWDController alloc] initWithType:MCResetPWDTypeTrade];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)logout:(id)sedner {
    [MCApp userLogout];
}
-(void)resetLoginPwd{
    [MCLATESTCONTROLLER.navigationController pushViewController:[KDForgetPwdViewController new] animated:YES];
}
@end
