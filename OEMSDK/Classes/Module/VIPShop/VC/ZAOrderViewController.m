//
//  ZAOrderViewController.m
//  Project
//
//  Created by SS001 on 2019/7/16.
//  Copyright © 2019 LY. All rights reserved.
//

#import "ZAOrderViewController.h"
#import "ZAOrderViewCell.h"
#import "ZAShopsModel.h"

@interface ZAOrderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *goodsArray;
@end

@implementation ZAOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setNavigationBarTitle:@"收货确认" tintColor:[UIColor whiteColor]];
    
    self.mc_tableview.delegate = self;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.rowHeight = 150;
    self.mc_tableview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    [self getGoodsData];
}

- (void)getGoodsData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:MCModelStore.shared.brandConfiguration.brand_id forKey:@"brandId"];
    [params setValue:@"产品收货" forKey:@"classifiCation"];
    [self.sessionManager mc_POST:@"/user/app/news/getnewsby/brandidandclassification/andpage" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        self.goodsArray = [ZAShopsModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]];
        [self.mc_tableview reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.goodsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZAOrderViewCell *cell = [ZAOrderViewCell cellWithTableView:tableView];
    cell.shopModel = self.goodsArray[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    head.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return head;
}

@end
