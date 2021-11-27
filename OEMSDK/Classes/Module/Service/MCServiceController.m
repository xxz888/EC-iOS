//
//  MCServiceController.m
//  Project
//
//  Created by Li Ping on 2019/7/16.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCServiceController.h"
#import "MCServiceCell.h"

#import "MCQuestionViewController.h"
#import "MCFeedBackController.h"
#import "KDCommonAlert.h"
@interface MCServiceController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray <NSDictionary *> *dataSource;

@end

@implementation MCServiceController

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop) style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.rowHeight = 60;
        _tableview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        if (@available(iOS 11.0, *)) {
            _tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableview];
    
    self.title = @"客服";
    [self setNavigationBarTitle:@"客服" tintColor:nil];
    
    self.dataSource = @[@{@"img":@"za_kf_btn_recommended_icon",
                          @"title":@"我的推荐人",
                          @"subTitle":@"手机号",
                          @"subDetail":(MCModelStore.shared.preUserPhone ?: @"无"),
                          @"sel":@"toTuiJian"
                          },
                        @{@"img":@"za_kf_btn_online_icon",
                          @"title":@"在线客服",
                          @"subTitle":@"",
                          @"subDetail":@"",
                          @"sel":@"toKefu"
                          },
//                        @{@"img":@"za_kf_btn_wx_icon",
//                          @"title":@"微信客服",
//                          @"subTitle":@"",
//                          @"subDetail":@"",
//                          @"sel":@"toWeixin"
//                          },
                        @{@"img":@"za_kf_btn_complaints_icon",
                          @"title":@"投诉建议",
                          @"subTitle":@"",
                          @"subDetail":@"",
                          @"sel":@"toTousu"
                          },
                        @{@"img":@"za_kf_question",
                          @"title":@"常见问题",
                          @"subTitle":@"",
                          @"subDetail":@"",
                          @"sel":@"toWenti"}
                        ];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MCServiceCell *cell = [MCServiceCell cellFromTableView:tableView];
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.imgView.image = [UIImage mc_imageNamed:dic[@"img"]];
    cell.titleLab.text = dic[@"title"];
    cell.phonePhoneLab.text = dic[@"subTitle"];
    cell.phoneLab.text = dic[@"subDetail"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.row];
    SEL sel = NSSelectorFromString(dic[@"sel"]);
    [self performSelector:sel withObject:nil afterDelay:0];
}

- (void)toTuiJian {
    if (MCModelStore.shared.preUserPhone) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",MCModelStore.shared.preUserPhone]]];
    } else {
        [MCToast showMessage:@"没有上级！"];
    }
    
}
- (void)toKefu {
    if (SharedBrandInfo.brandPhone) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",SharedBrandInfo.brandPhone]]];
    } else {
        [MCToast showMessage:@"获取客服电话失败！"];
    }
}
- (void)toWeixin {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = SharedBrandInfo.brandWeiXin;
    
    kWeakSelf(self);
    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
    [commonAlert initKDCommonAlertContent:@"微信号已复制，请打开微信并添加好友"  isShowClose:NO];
    commonAlert.rightActionBlock = ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
    };
    
    
//    [MCAlertStore showWithTittle:@"温馨提示" message:@"微信号已复制，请打开微信并添加好友" buttonTitles:@[@"取消",@"打开微信"] sureBlock:^{
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
//    } cancelBlock:^{
//
//    }];
}
- (void)toTousu {
    [self.navigationController pushViewController:[MCFeedBackController new] animated:YES];
}
- (void)toWenti {
    [self.navigationController pushViewController:[MCQuestionViewController new] animated:YES];
}


@end
