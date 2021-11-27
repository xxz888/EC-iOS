//
//  MCIncomeRateViewController.m
//  Project
//
//  Created by SS001 on 2020/4/7.
//  Copyright © 2020 LY. All rights reserved.
//

#import "MCIncomeRateViewController.h"
#import "MCIncomeRateModel.h"
#import "MCIncomeRateCell.h"

static NSString *rankingList = @"/user/app/rebate/query/ranking/list";

@interface MCIncomeRateViewController ()<UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *firstLabelView;
@property (weak, nonatomic) IBOutlet QMUIButton *firstMoneyView;

@property (weak, nonatomic) IBOutlet UILabel *secondLabelView;
@property (weak, nonatomic) IBOutlet QMUIButton *secondMoneyView;

@property (weak, nonatomic) IBOutlet UILabel *thirdLabelView;
@property (weak, nonatomic) IBOutlet QMUIButton *thirdMoneyView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MCIncomeRateViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarHidden];
    
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:207/255.0 blue:3/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:188/255.0 blue:0/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.view.layer insertSublayer:gl atIndex:0];
    
    [self pullRateDataFromService];
    
    self.tableView.rowHeight = 70;
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.masksToBounds = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"MCIncomeRateCell" bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:@"cell"];
    
    
}

//获取排名
-(void)pullRateDataFromService{
    NSDictionary *params = @{@"brandId":MCModelStore.shared.brandConfiguration.brand_id,
                             @"userId":MCModelStore.shared.userInfo.userid,
                             @"startDate":@"2018-09-01"};
    __weak __typeof(self)weakSelf = self;
    [[MCSessionManager shareManager] mc_POST:@"/user/app/rebate/query/ranking/list" parameters:params ok:^(MCNetResponse * _Nonnull okResponse) {
        NSArray *arr = [MCIncomeRateModel mj_objectArrayWithKeyValuesArray:okResponse.result];
        NSArray *array = [arr sortedArrayUsingComparator:^NSComparisonResult(MCIncomeRateModel *obj1, MCIncomeRateModel *obj2) {
            return obj1.ranking.intValue > obj2.ranking.intValue;
        }];
        [weakSelf.dataArray addObjectsFromArray:array];
        [weakSelf setupTopView];
        [weakSelf.tableView reloadData];
    }];
}
- (IBAction)onBackTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupTopView
{
    if (self.dataArray.count<3) { return; }
    MCIncomeRateModel *firstModel = self.dataArray.firstObject;
    self.firstLabelView.attributedText = [self getAttsWithModel:0 font:12 secondFont:10];
    [self.firstMoneyView setTitle:firstModel.rebate forState:UIControlStateNormal];
    
    MCIncomeRateModel *secondModel = self.dataArray[1];
    self.secondLabelView.attributedText = [self getAttsWithModel:1 font:11.2 secondFont:8];
    [self.secondMoneyView setTitle:secondModel.rebate forState:UIControlStateNormal];
    
    MCIncomeRateModel *thirdModel = self.dataArray[2];
    self.thirdLabelView.attributedText = [self getAttsWithModel:2 font:11.2 secondFont:8];
    [self.thirdMoneyView setTitle:thirdModel.rebate forState:UIControlStateNormal];
}
- (NSMutableAttributedString *)getAttsWithModel:(NSInteger)ranking font:(CGFloat)firstFont secondFont:(CGFloat)secondFont
{
    MCIncomeRateModel *model = self.dataArray[ranking];
    NSString *str = [NSString stringWithFormat:@"%@ %@", model.name, model.phone];
    NSRange range = [str rangeOfString:model.phone];
    NSRange firstRange = [str rangeOfString:model.name];
    NSMutableAttributedString *atts = [[NSMutableAttributedString alloc] initWithString:str];
    CGFloat scale = SCREEN_WIDTH / 375;
    [atts addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:firstFont * scale] range:firstRange];
    [atts addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:secondFont * scale] range:range];
    return atts;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.dataArray.count - 3;
    if (count >= 7) {
        return 7;
    } else if (count > 0) {
        return count;
    } else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger offset=self.dataArray.count>3?3:0;
    MCIncomeRateModel* model=self.dataArray[indexPath.row+offset];
    MCIncomeRateCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.myrateLB.text= [NSString stringWithFormat:@"%@", model.ranking];
    cell.headIM.image=[UIImage mc_imageNamed:@"incomeRate_logo"];
    cell.userName.text=model.name;
    cell.phoneLB.text=[NSString stringWithFormat:@"%@", model.phone];
    cell.amountLB.text = [NSString stringWithFormat:@"%.2f", model.rebate.floatValue];
    return cell;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
