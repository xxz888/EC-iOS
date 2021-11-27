//
//  KDProfitHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDProfitHeaderView.h"


@interface KDProfitHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *allEarnView;
@property (weak, nonatomic) IBOutlet UILabel *todayEarnView;
@property (weak, nonatomic) IBOutlet UILabel *monthEarnView;
@property (weak, nonatomic) IBOutlet UILabel *topTitleView;
@property (nonatomic, copy) NSString *queryType;
@property (nonatomic, strong) KDProfitModel *profitModel;
@end

@implementation KDProfitHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.yearBtn.imagePosition = QMUIButtonImagePositionRight;
    self.monthBtn.imagePosition = QMUIButtonImagePositionRight;
    [self.yearBtn setTitle:[NSString stringWithFormat:@"%@年", [MCDateStore getYear]] forState:UIControlStateNormal];
    [self.monthBtn setTitle:[NSString stringWithFormat:@"%@月", [MCDateStore getMonth]] forState:UIControlStateNormal];
    
    self.topView.layer.cornerRadius = 10;
    self.topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    self.topView.layer.shadowOffset = CGSizeMake(0,1.5);
    self.topView.layer.shadowOpacity = 1;
    self.topView.layer.shadowRadius = 10;
    
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDProfitHeaderView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 325);
}

#pragma mark - 按钮点击
- (IBAction)clickYearBtn:(QMUIButton *)sender {
    BRDatePickerView *pickView = [[BRDatePickerView alloc] initWithPickerMode:BRDatePickerModeY];
    NSString *year = [MCDateStore getYear];
    pickView.minDate = [NSDate br_setYear:(year.intValue - 3)];
    pickView.maxDate = [NSDate br_setYear:year.intValue];
    pickView.selectDate = [NSDate date];
    [pickView show];
    pickView.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        [self.yearBtn setTitle:selectValue forState:UIControlStateNormal];
        [self reloadData];
    };
}
- (IBAction)clickMonthBtn:(QMUIButton *)sender {
    BRStringPickerView *pickView = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
    pickView.dataSourceArr = @[@"01月", @"02月", @"03月", @"04月", @"05月", @"06月", @"07月", @"08月", @"09月", @"10月", @"11月", @"12月"];
    pickView.selectValue = [NSString stringWithFormat:@"%2@月", [MCDateStore getMonth]];
    [pickView show];
    pickView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
        [self.monthBtn setTitle:resultModel.value forState:UIControlStateNormal];
        [self reloadData];
    };
}
#pragma mark - 数据显示
- (void)setNavTitle:(NSString *)navTitle
{
    _navTitle = navTitle;
    
    if ([navTitle isEqualToString:@"刷卡分润"]) {
        self.topTitleView.text = @"刷卡总分润（元）";
        self.queryType = @"1";
    }
    if ([navTitle isEqualToString:@"还款分润"]) {
        self.topTitleView.text = @"还款总分润（元）";
        self.queryType = @"2";
    }
    if ([navTitle isEqualToString:@"空卡分润"]) {
        self.topTitleView.text = @"空卡总分润（元）";
        self.queryType = @"3";
    }
    if ([navTitle isEqualToString:@"共享智还分润"]) {
        self.topTitleView.text = @"共享智还总分润（元）";
        
    }
    if ([navTitle isEqualToString:@"花呗分润"]) {
        self.topTitleView.text = @"花呗总分润（元）";
        self.queryType = @"6";
    }
    
    [self reloadData];
}

- (void)reloadData
{
    NSString *year = [self.yearBtn.titleLabel.text substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [self.monthBtn.titleLabel.text substringWithRange:NSMakeRange(0, 2)];
    NSString *time = [NSString stringWithFormat:@"%@%@",  year, month];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.queryType forKey:@"queryType"];
    [params setValue:time forKey:@"queryDate"];
    MCLog(@"param:%@", params);
    [[MCSessionManager shareManager] mc_POST:@"/transactionclear/app/query/profit/sum" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        //MCLog(@"%@",resp.result);
        self.profitModel = [KDProfitModel mj_objectWithKeyValues:resp.result];
    }];
}

- (void)setProfitModel:(KDProfitModel *)profitModel
{
    _profitModel = profitModel;
    
    self.allEarnView.text = [NSString stringWithFormat:@"%.2f", profitModel.totalRebate.floatValue];
    self.todayEarnView.text = [NSString stringWithFormat:@"%.2f", profitModel.todayRebate.floatValue];
    self.monthEarnView.text = [NSString stringWithFormat:@"%.2f", profitModel.monthRebate.floatValue];
    
    if (self.getDataWithReloadData) {
        self.getDataWithReloadData(profitModel);
    }
}
@end
