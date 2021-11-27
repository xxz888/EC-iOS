//
//  KDHomeXinYongKaViewController.m
//  KaDeShiJie
//
//  Created by BH on 2021/9/23.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDHomeXinYongKaViewController.h"
#import "KDHomeXinYongKaTableViewCell.h"

@interface KDHomeXinYongKaViewController()<QMUITableViewDataSource, QMUITableViewDelegate>
@property (nonatomic ,strong)NSMutableArray * dataArray;
@end
@implementation KDHomeXinYongKaViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"在线申请信用卡" tintColor:UIColor.whiteColor];

//    [self setNavigationBarTitle:@"在线申请信用卡" backgroundImage:[UIImage qmui_imageWithColor:UIColor.mainColor]];

    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#f5f5f5"];
    
   
//    self.mc_tableview.rowHeight = 50;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mc_tableview.tableFooterView = [UIView new];
    self.mc_tableview.ly_emptyView = [MCEmptyView emptyView];
    [self.mc_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [self.mc_tableview registerNib:[UINib nibWithNibName:@"KDHomeXinYongKaTableViewCell" bundle:nil] forCellReuseIdentifier:@"KDHomeXinYongKaTableViewCell"];
    
    
    self.dataArray= [[NSMutableArray alloc]init];
    
    [self creditcardapply];
}

#pragma mark - QMUITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((SCREEN_WIDTH-32) * 478/994)+5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.dataArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    KDHomeXinYongKaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"KDHomeXinYongKaTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];
//    cell.textLabel.text = dic[@"title"];
    cell.bankImv.image = [UIImage imageNamed:dic[@"title"]];
    
    
        return cell;
    
    
 
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.dataArray[indexPath.row];

    [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":dic[@"link"]}];
    
}


#pragma mark - 数据请求
- (void)creditcardapply
{
    kWeakSelf(self);

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

        [self.sessionManager mc_POST:@"/creditcardmanager/app/get/creditcardapply" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
            self.dataArray = resp.result;
            [self.mc_tableview reloadData];
        }];
}

#pragma mark - 数据请
@end
