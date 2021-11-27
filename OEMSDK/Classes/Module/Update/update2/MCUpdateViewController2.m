//
//  MCUpdateViewController2.m
//  JFB
//
//  Created by Shao Wei Su on 2017/7/31.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "MCUpdateViewController2.h"
#import "MCUpdateViewController.h"
#import "OneOnlineCell.h"            // 重写系统cell
#import "OneOnlineOtherCell.h"       // 自定义cell
#import "MCProductModel.h"
#import "FormValidator.h"

#define STR(string) [NSString stringWithFormat:@"%@", string]

@interface MCUpdateViewController2 ()<UITableViewDelegate,UITableViewDataSource>

/** 产品tableView */
@property (nonatomic, strong) UITableView *proTableView;
// 所有产品数据原
@property (nonatomic, strong) NSMutableArray *allProArr;


@end

@implementation MCUpdateViewController2
#pragma mark ------------lazy------------------------
- (NSMutableArray *)allProArr {
    if (!_allProArr) {
        self.allProArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _allProArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始值
    [self setupValueForUI];
    // 主界面
    [self setupMainUI];

}

#pragma mark --- 界面设置 -------------
// 初始值
- (void)setupValueForUI {
    // 导航栏
    [self setNavigationBarTitle:@"产品升级" tintColor:nil];
    
    //修改系统cell 左边线
    if ([self.proTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.proTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.proTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.proTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


// 主界面
- (void)setupMainUI {
    self.proTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop) style:(UITableViewStylePlain)];
    self.view.backgroundColor = LYColor(210, 210, 210);
    self.proTableView.backgroundColor = self.view.backgroundColor;
    self.proTableView.delegate = self;
    self.proTableView.dataSource = self;
    self.proTableView.estimatedRowHeight = 0;
    self.proTableView.estimatedSectionHeaderHeight = 0;
    self.proTableView.estimatedSectionFooterHeight = 0;
    self.proTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    [self.view addSubview:self.proTableView];    
    [self.proTableView registerClass:[OneOnlineOtherCell class] forCellReuseIdentifier:@"OneOnlineOtherCell"];

    [self requestDataForProduct];
}
#pragma mark --- 代理方法 -------------------
// section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 2;
}
// 区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return 10;
    }
}

// row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
       return self.allProArr.count;
    }
}
// rowHeight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.section == 0) {
            return 44;
        }else {
            MCProductModel *model = self.allProArr[indexPath.row];
            return model.updateCellHeight;
        }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.section == 0) {
            
         
            OneOnlineCell *cell = [OneOnlineCell cellFromTableView:tableView];
            
            cell.imageView.image = [UIImage mc_imageNamed:@"feedback_icon0"];
            cell.textLabel.text = @"产品费率说明";
            cell.detailTextLabel.text = @"等级越高，收益越高";
            return cell;
            
        }else { // 产品
            OneOnlineOtherCell *cell = [OneOnlineOtherCell cellFromTableView:tableView];
            cell.proImageV.image = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.allProArr.count != 0) {
                
                cell.proModel = self.allProArr[indexPath.row];
            }
            // (0:线上购买显示价格 1:线下购买显示价格 2:线上购买不显示价格 3:线下购买不显示价格)
            NSString *tempStr = STR([self.allProArr[indexPath.section-1] valueForKey:@"trueFalseBuy"]);
            if ([tempStr isEqualToString:@"2"] || [tempStr isEqualToString:@"3"]) {
                
                cell.proNameLabel.text = [NSString stringWithFormat:@"%@", [self.allProArr[indexPath.row] valueForKey:@"name"]];
            }
            return cell;
    }
}
// selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

        if (indexPath.section == 0) { // 产品费率
            [self.navigationController pushViewController:[MCUpdateViewController new] animated:YES];
        }else { // 购买产品
            MCProductModel *model = self.allProArr[indexPath.row];
            if ([model.isBuy isEqualToString:@"1"]) {
                [MCToast showMessage:@"您已购买，无需再次购买"];
                return;
            }
            if ([model.trueFalseBuy isEqualToString:@"0"] || [model.trueFalseBuy isEqualToString:@"2"]) {
                [MCChoosePayment popAlertBeforeShowWithAmount:[model.money floatValue] productId:model.ID productName:model.name couponId:nil];
                
            } else if ([model.trueFalseBuy isEqualToString:@"1"] || [model.trueFalseBuy isEqualToString:@"3"]){
                // 拨打电话
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",SharedBrandInfo.brandPhone]]];
            }
        }
}

#pragma mark --- 数据请求 -------------
// 产品数据
- (void)requestDataForProduct {
    
    __weak typeof(self) weakSelf = self;
    [self.sessionManager mc_GET:[NSString stringWithFormat:@"/user/app/thirdlevel/prod/brand/%@",SharedBrandInfo.ID] parameters:nil ok:^(MCNetResponse * _Nonnull resp) {

        [weakSelf.allProArr removeAllObjects];
        NSArray *tempA = [MCProductModel mj_objectArrayWithKeyValuesArray:resp.result];
        for (MCProductModel *model in tempA) {
            if (model.trueFalseBuy.intValue != 4) {
                [weakSelf.allProArr addObject:model];
            }
        }
        // 降序排列
        NSArray *sortArr = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"grade" ascending:NO]];
        [weakSelf.allProArr sortUsingDescriptors:sortArr];
        [weakSelf.proTableView reloadData];
    }];
}
    
@end
