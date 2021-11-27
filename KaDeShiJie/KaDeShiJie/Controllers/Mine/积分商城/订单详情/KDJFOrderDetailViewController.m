//
//  KDJFOrderDetailViewController.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/10.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFOrderDetailViewController.h"
#import "KDJFOrderDetailHeaderView.h"
#import "MCBaseViewController.h"

@interface KDJFOrderDetailViewController ()
@property(nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation KDJFOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    [self setNavigationBarTitle:@"订单详情" backgroundImage:[UIImage qmui_imageWithColor:UIColor.mainColor]];
    KDJFOrderDetailHeaderView * headView = [[KDJFOrderDetailHeaderView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, 700+kTopHeight)];
    self.mc_tableview.tableHeaderView = headView;
    self.mc_tableview.mj_header = nil;
    self.mc_tableview.mj_footer = nil;
    self.mc_tableview.bounces = NO;
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];

    
    [self getData];
}
-(void)getData{
    kWeakSelf(self);
    [self.sessionManager mc_Post_QingQiuTi:@"facade/app/coin/order/detail" parameters:@{@"ordercode":self.orderDic[@"ordercode"]} ok:^(MCNetResponse * _Nonnull resp) {
        if (resp.result) {
            weakself.dataArray  = [[NSMutableArray alloc]initWithArray:resp.result[@"content"]];
        }
//        [weakself.jfCollectionView reloadData];
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
    } failure:^(NSError * _Nonnull error) {
        [MCLoading hidden];
    }];
}
@end
