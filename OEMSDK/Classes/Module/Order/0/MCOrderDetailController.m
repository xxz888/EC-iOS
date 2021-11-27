//
//  Common_BargainDetailVC.m
//  Project
//
//  Created by 熊凤伟 on 2018/4/2.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "MCOrderDetailController.h"

@interface MCOrderDetailController ()<UITableViewDelegate,UITableViewDataSource>

/** tableView */
@property (nonatomic, weak) UITableView *bargainDetailTableView;
/** 标题数组 */
@property (nonatomic, strong) NSArray *titleArr;
/** 详情标题数组 */
@property (nonatomic, strong) NSArray *detailTitleArr;

@end

@implementation MCOrderDetailController

#pragma mark LIFE
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorForBackground;
    // 1. 界面设置
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
#pragma mark SETUP UI
- (void)setupUI {
    
    [self setNavigationBarTitle:@"账单详情" tintColor:nil];
    self.titleArr = @[@"交易金额", @"手续费用", @"商品说明", @"账单分类", @"创建日期", @"订单号", @"商户号"];
    
    NSString *amountStr = [NSString stringWithFormat:@"%.2f元", [self.bargainInfo.amount floatValue]];
    NSString *withdrawSre = [NSString stringWithFormat:@"%.2f元", [self.bargainInfo.extraFee floatValue]];
    NSString *descStr = self.bargainInfo.desc;
    // (0 订单充值  1订单支付   2订单提现  3订单退款  7信用卡还款 8信用卡充值 9信用卡消费  10新信用卡消费 11新信用卡还款)
    NSString *typeStr = [self.bargainInfo.type isEqualToString:@"0"] ? @"订单充值" : ([self.bargainInfo.type isEqualToString:@"1"] ? @"订单支付" : ([self.bargainInfo.type isEqualToString:@"2"] ? @"订单提现" : ([self.bargainInfo.type isEqualToString:@"3"] ? @"订单退款" : ([self.bargainInfo.type isEqualToString:@"7"] ? @"信用卡还款" : ([self.bargainInfo.type isEqualToString:@"8"] ? @"信用卡充值" : ([self.bargainInfo.type isEqualToString:@"8"] ? @"信用卡消费" : ([self.bargainInfo.type isEqualToString:@"10"] ? @"新信用卡消费" : ([self.bargainInfo.type isEqualToString:@"11"] ? @"新信用卡还款" : @""))))))));
    NSString *dateStr = self.bargainInfo.createTime;
    NSString *orderCodeStr = self.bargainInfo.ordercode;
    NSString *shopCodeStr = @"";
    self.detailTitleArr = @[amountStr, withdrawSre, descStr, typeStr, dateStr, orderCodeStr, shopCodeStr];
    
    // 1. header
    // 背景
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, NavigationContentTop + 1, SCREEN_WIDTH, 200)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    // 图片
    CGFloat nameW = [self stringWidthWithString:self.bargainInfo.channelname font:UIFontMake(26)];
    
    UIImageView *channelImageView = [[UIImageView alloc] initWithFrame:CGRectMake((headerView.width - nameW - 5 - 30) / 2, (headerView.height - 30 * 3 + 10 * 2) / 2, 30, 30)];
    [channelImageView sd_setImageWithURL:[NSURL URLWithString:self.bargainInfo.channelImage] placeholderImage:SharedAppInfo.icon];
    
    [headerView addSubview:channelImageView];
    // 名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(channelImageView.right + 5, channelImageView.top, nameW, 30)];
    nameLabel.text = self.bargainInfo.channelname;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = UIFontMake(26);
    [headerView addSubview:nameLabel];
    // 费率
    UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.right + 5, nameLabel.top - 5, 50, 20)];
    rateLabel.text = [NSString stringWithFormat:@"%.2f%%", [self.bargainInfo.rate floatValue] * 100];
    rateLabel.textColor = [UIColor whiteColor];
    rateLabel.textAlignment = NSTextAlignmentCenter;
    rateLabel.font = UIFontMake(12);
    rateLabel.backgroundColor = [UIColor darkGrayColor];
    rateLabel.layer.cornerRadius = 6;
    rateLabel.layer.masksToBounds = YES;
    [headerView addSubview:rateLabel];
    
    
    // 金额
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, nameLabel.bottom + 10, headerView.width - 20, 30)];
    amountLabel.text = [NSString stringWithFormat:@"￥%.2f", [self.bargainInfo.realAmount floatValue]];
    amountLabel.textColor = UIColorRed;
    amountLabel.textAlignment = NSTextAlignmentCenter;
    amountLabel.font = UIFontBoldMake(26);
    [headerView addSubview:amountLabel];
    // 状态
    NSString *statusStr = [self.bargainInfo.status isEqualToString:@"0"] ? @"订单状态：待完成" : ([self.bargainInfo.status isEqualToString:@"1"] ? @"订单状态：已成功" : ([self.bargainInfo.status isEqualToString:@"2"] ? @"订单状态：已取消" : ([self.bargainInfo.status isEqualToString:@"3"] ? @"订单状态：待处理" : @"订单状态：待结算")));
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(amountLabel.left, amountLabel.bottom + 10, amountLabel.width, 30)];
    statusLabel.text = statusStr;
    statusLabel.textColor = [UIColor lightGrayColor];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.font = UIFontMake(14);
    [headerView addSubview:statusLabel];
    
    // 2. tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.bottom + 5, SCREEN_WIDTH, SCREEN_HEIGHT - headerView.bottom - 5) style:(UITableViewStylePlain)];
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 60;
    
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:tableView];
    self.bargainDetailTableView = tableView;
}
#pragma mark TARGET METHOD

#pragma mark DELEGATE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.titleArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? 0 : 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 赋值
    cell.textLabel.text = self.titleArr[indexPath.section];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = UIFontMake(16);
    cell.detailTextLabel.text = self.detailTitleArr[indexPath.section];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.font = UIFontMake(14);
    cell.detailTextLabel.numberOfLines = 0;
    
    return cell;
}
- (CGFloat)stringWidthWithString:(NSString *)string font:(UIFont *)font {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.width;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.detailTitleArr[indexPath.section];
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-150, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:17]} context:nil];
    CGFloat height = rect.size.height + 10;
    return height > 60 ? height : 60;
}
#pragma mark PRIVATE METHOD

#pragma mark LOAD DATA

#pragma mark SETTER AND GETTER

@end
