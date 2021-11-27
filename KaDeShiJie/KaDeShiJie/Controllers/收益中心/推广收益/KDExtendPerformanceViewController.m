//
//  KDExtendPerformanceViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDExtendPerformanceViewController.h"
#import "KDDirectPushViewController.h"
#import "KDExtendPerformanceModel.h"

@interface KDExtendPerformanceViewController ()
@property (weak, nonatomic) IBOutlet QMUIButton *yearBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *monthBtn;
@property (nonatomic, strong) KDExtendPerformanceModel *performanceModel;

@property (weak, nonatomic) IBOutlet UILabel *lab0;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;

@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;
@property (weak, nonatomic) IBOutlet UILabel *lab6;
@property (weak, nonatomic) IBOutlet UILabel *lab7;

@property (weak, nonatomic) IBOutlet UILabel *lab8;
@property (weak, nonatomic) IBOutlet UILabel *lab9;
@property (weak, nonatomic) IBOutlet UILabel *lab10;
@property (weak, nonatomic) IBOutlet UILabel *lab11;

@property (weak, nonatomic) IBOutlet UILabel *lab12;
@property (weak, nonatomic) IBOutlet UILabel *lab13;
@property (weak, nonatomic) IBOutlet UILabel *lab14;
@property (weak, nonatomic) IBOutlet UILabel *lab15;
@end

@implementation KDExtendPerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.yearBtn.imagePosition = QMUIButtonImagePositionRight;
    self.monthBtn.imagePosition = QMUIButtonImagePositionRight;
    [self.yearBtn setTitle:[NSString stringWithFormat:@"%@年", [MCDateStore getYear]] forState:UIControlStateNormal];
    [self.monthBtn setTitle:[NSString stringWithFormat:@"%@月", [MCDateStore getMonth]] forState:UIControlStateNormal];
    
    // 导航条
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    [self setNavigationBarHidden];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage mc_imageNamed:@"nav_left_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, StatusBarHeightConstant, 44, 44);
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = @"推广收益";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    [self getData];
}
- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
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
        [self getData];
    };
}
- (IBAction)clickMonthBtn:(QMUIButton *)sender {
    BRStringPickerView *pickView = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
    pickView.dataSourceArr = @[@"01月", @"02月", @"03月", @"04月", @"05月", @"06月", @"07月", @"08月", @"09月", @"10月", @"11月", @"12月"];
    pickView.selectValue = [NSString stringWithFormat:@"%2@月", [MCDateStore getMonth]];
    [pickView show];
    pickView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
        [self.monthBtn setTitle:resultModel.value forState:UIControlStateNormal];
        [self getData];
    };
}
- (IBAction)viewBtnAction:(UIButton *)sender {
    NSArray *titleArr = @[@"直推", @"间推", @"二级间推"];
    KDDirectPushViewController *vc = [[KDDirectPushViewController alloc] init];
    vc.titleString = titleArr[sender.tag - 100];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getData
{
    NSString *year = [self.yearBtn.titleLabel.text substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [self.monthBtn.titleLabel.text substringWithRange:NSMakeRange(0, 2)];
    NSString *time = [NSString stringWithFormat:@"%@%@",  year, month];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"9" forKey:@"queryType"];
    [params setValue:time forKey:@"queryDate"];
    [self.sessionManager mc_POST:@"/transactionclear/app/query/profit/sum" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        self.performanceModel = [KDExtendPerformanceModel mj_objectWithKeyValues:resp.result];
    }];
}
- (void)setPerformanceModel:(KDExtendPerformanceModel *)performanceModel
{
    _performanceModel = performanceModel;
    
    self.lab0.text = [NSString stringWithFormat:@"%ld人", performanceModel.direc1.registerCount];
    self.lab1.text = [NSString stringWithFormat:@"%ld人", performanceModel.direc1.authCount];
    self.lab2.text = [NSString stringWithFormat:@"%ld人", performanceModel.direc1.activeCount];
    self.lab3.text = [NSString stringWithFormat:@"%.2f元", performanceModel.direc1.rebate];
    
    self.lab4.text = [NSString stringWithFormat:@"%ld人", performanceModel.direc2.registerCount];
    self.lab5.text = [NSString stringWithFormat:@"%ld人", performanceModel.direc2.authCount];
    self.lab6.text = [NSString stringWithFormat:@"%ld人", performanceModel.direc2.activeCount];
    self.lab7.text = [NSString stringWithFormat:@"%.2f元", performanceModel.direc2.rebate];
    
    self.lab8.text = [NSString stringWithFormat:@"%ld人", performanceModel.direc3.registerCount];
    self.lab9.text = [NSString stringWithFormat:@"%ld人", performanceModel.direc3.authCount];
    self.lab10.text = [NSString stringWithFormat:@"%ld人", performanceModel.direc3.activeCount];
    self.lab11.text = [NSString stringWithFormat:@"%.2f元", performanceModel.direc3.rebate];
    
    self.lab12.text = [NSString stringWithFormat:@"%ld人", performanceModel.total.registerCount];
    self.lab13.text = [NSString stringWithFormat:@"%ld人", performanceModel.total.authCount];
    self.lab14.text = [NSString stringWithFormat:@"%ld人", performanceModel.total.activeCount];
    self.lab15.text = [NSString stringWithFormat:@"%.2f元", performanceModel.total.rebate];
}
@end
