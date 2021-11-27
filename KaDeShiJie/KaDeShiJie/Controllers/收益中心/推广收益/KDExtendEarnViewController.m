//
//  KDExtendEarnViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDExtendEarnViewController.h"
#import "KDExtendPerformanceViewController.h"
#import "KDExtensionEarnModel.h"

@interface KDExtendEarnViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet QMUILabel *firstLabel;
@property (weak, nonatomic) IBOutlet QMUILabel *maxminLabel;
@property (weak, nonatomic) IBOutlet QMUILabel *minXmaxYLabel;
@property (weak, nonatomic) IBOutlet QMUILabel *maxXmaxYLabel;

@property (weak, nonatomic) IBOutlet UILabel *zhituirenzheng;
@property (weak, nonatomic) IBOutlet UILabel *jiantuirenzehng;
@property (weak, nonatomic) IBOutlet UILabel *erjijiantuirenzheng;


@property (nonatomic, strong) KDExtensionEarnModel *earnModel;
@property (weak, nonatomic) IBOutlet UILabel *allEarnLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayEarnLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthEarnLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayRealNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthRealNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayActiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthActiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *lab01;

@property (weak, nonatomic) IBOutlet UILabel *lab0;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;
@property (weak, nonatomic) IBOutlet QMUILabel *lab6;
@end

@implementation KDExtendEarnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topView.layer.cornerRadius = 10;
    self.bottomView.layer.masksToBounds = YES;
    self.bottomView.layer.cornerRadius = 10;
    self.firstLabel.layer.qmui_maskedCorners = QMUILayerMinXMinYCorner;
    self.firstLabel.layer.cornerRadius = 10;
    
    self.maxminLabel.layer.qmui_maskedCorners = QMUILayerMaxXMinYCorner;
    self.maxminLabel.layer.cornerRadius = 10;
    
    self.minXmaxYLabel.layer.qmui_maskedCorners = QMUILayerMinXMaxYCorner;
    self.minXmaxYLabel.layer.cornerRadius = 10;
    
    self.lab6.layer.qmui_maskedCorners = QMUILayerMaxXMaxYCorner;
    self.lab6.layer.cornerRadius = 10;
    
    self.bgView.layer.cornerRadius = 10;
    
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
    
    [self getExtensionEarnData];
}
- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/** 推广业绩 */
- (IBAction)clickBtnToMore:(id)sender {
    [self.navigationController pushViewController:[KDExtendPerformanceViewController new] animated:YES];
}
- (void)getExtensionEarnData {
    kWeakSelf(self);
    [self.sessionManager mc_POST:@"/user/app/query/direct/user/award/history/sum" parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        weakself.earnModel = [KDExtensionEarnModel mj_objectWithKeyValues:resp.result];
        
        [weakself getconfigjihuo];


    }];
}

- (void)getconfigjihuo{
    kWeakSelf(self);

    NSDictionary * dic = @{@"brandId":BCFI.brand_id,
                           @"level":@"",
                           @"minNum":@"",
                           @"maxNum":@"",
                           @"amount":@"",
                           @"status":@""
    };
    
    [weakself.sessionManager mc_POST:@"/user/app/query/activate/award/config" parameters:dic ok:^(MCNetResponse * _Nonnull resp) {
        /*
         直推：1-14人 60元 15-34人 65元 35-9999人 70元
         间推：1-299人 12元 300-999909人15元
         二级间推：1-2999人 6元 3000-999999人10元
         **/
        for (NSDictionary * dic in resp.result) {
            if (weakself.earnModel.direct1ActiveCount <= 14 && [dic[@"maxNum"] integerValue] == 14 && [dic[@"level"] integerValue] == 1) {
                weakself.lab2.text = [NSString stringWithFormat:@"%@元/人",dic[@"amount"]];
            }
            if ((self.earnModel.direct1ActiveCount >=15 && self.earnModel.direct1ActiveCount <= 34) &&
                [dic[@"maxNum"] integerValue] == 34 && [dic[@"level"] integerValue] == 1) {
                weakself.lab2.text = [NSString stringWithFormat:@"%@元/人",dic[@"amount"]];
            }
            if (weakself.earnModel.direct1ActiveCount > 34 && [dic[@"minNum"] integerValue] == 35 && [dic[@"level"] integerValue] == 1) {
                weakself.lab2.text = [NSString stringWithFormat:@"%@元/人",dic[@"amount"]];
            }
            
            
            if (weakself.earnModel.direct2ActiveCount <= 299 && [dic[@"maxNum"] integerValue] == 299 && [dic[@"level"] integerValue] == 2) {
                weakself.lab4.text = [NSString stringWithFormat:@"%@元/人",dic[@"amount"]];
            }
            if (weakself.earnModel.direct2ActiveCount > 299 && [dic[@"minNum"] integerValue] == 300 && [dic[@"level"] integerValue] == 2) {
                weakself.lab4.text = [NSString stringWithFormat:@"%@元/人",dic[@"amount"]];
            }
         
            
            if (weakself.earnModel.direct3ActiveCount <= 2999 && [dic[@"maxNum"] integerValue] == 2999 && [dic[@"level"] integerValue] == 3) {
                weakself.lab6.text = [NSString stringWithFormat:@"%@元/人",dic[@"amount"]];
            }
            if (weakself.earnModel.direct3ActiveCount > 2999 && [dic[@"minNum"] integerValue] == 3000 && [dic[@"level"] integerValue] == 3) {
                weakself.lab6.text = [NSString stringWithFormat:@"%@元/人",dic[@"amount"]];
            }
            
        }
        
        
        NSArray * verifyArray =  [[NSUserDefaults standardUserDefaults] objectForKey:@"verify"];

        for (NSDictionary * dic in verifyArray) {
            if ([dic[@"level"] integerValue] == 1) {
                weakself.zhituirenzheng.text = [NSString stringWithFormat:@"%@元/人",dic[@"amount"]];
            }
            if ([dic[@"level"] integerValue] == 2) {
                weakself.jiantuirenzehng.text = [NSString stringWithFormat:@"%@元/人",dic[@"amount"]];
            }
            if ([dic[@"level"] integerValue] == 3) {
                weakself.erjijiantuirenzheng.text = [NSString stringWithFormat:@"%@元/人",dic[@"amount"]];
            }
        }
//        self.lab2.text =  self.earnModel.direct1ActiveCount <= 14  ? @"60.00元/人"  :
//                         (self.earnModel.direct1ActiveCount >=15 && self.earnModel.direct1ActiveCount <= 34) ? @"65.00元/人"  : @"70.00元/人";
//        self.lab4.text =  self.earnModel.direct2ActiveCount <= 299  ? @"12.00元/人" : @"15.00元/人";
//        self.lab6.text =  self.earnModel.direct3ActiveCount <= 2999   ? @"6.00元/人"  : @"10.00元/人";
    }];
}
- (void)setEarnModel:(KDExtensionEarnModel *)earnModel
{
    _earnModel = earnModel;
    
    NSString *title = [NSString stringWithFormat:@"已注册%ld人 已实名%ld人 直推激活%ld人", earnModel.totalRegister, earnModel.totalRealName, earnModel.direct1ActiveCount];
//    NSString *title = [NSString stringWithFormat:@"已注册%@人 已实名%@人 直推激活%@人", @"12345", @"12345", @"12345"];
    NSMutableAttributedString *atts = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange range1 = [title rangeOfString:@"已注册"];
    NSRange range2 = [title rangeOfString:@"已实名"];
    NSRange range3 = [title rangeOfString:@"直推激活"];
  
    [atts addAttribute:NSForegroundColorAttributeName value:[UIColor qmui_colorWithHexString:@"#333333"] range:range1];
    [atts addAttribute:NSForegroundColorAttributeName value:[UIColor qmui_colorWithHexString:@"#333333"] range:range2];
    [atts addAttribute:NSForegroundColorAttributeName value:[UIColor qmui_colorWithHexString:@"#333333"] range:range3];
    self.lab0.attributedText = atts;
    
    
    NSString *title1 = [NSString stringWithFormat:@"间推激活%ld人 二级间推激活%ld人", earnModel.direct2ActiveCount, earnModel.direct3ActiveCount];
//    NSString *title1 = [NSString stringWithFormat:@"间推激活%@人 二级间推激活%@人", @"12345", @"12345"];

    NSMutableAttributedString *atts1 = [[NSMutableAttributedString alloc] initWithString:title1];
    NSRange range41 = [title1 rangeOfString:@"间推激活"];
    NSRange range51 = [title1 rangeOfString:@"二级间推激活"];
    
    [atts1 addAttribute:NSForegroundColorAttributeName value:[UIColor qmui_colorWithHexString:@"#333333"] range:range41];
    [atts1 addAttribute:NSForegroundColorAttributeName value:[UIColor qmui_colorWithHexString:@"#333333"] range:range51];
    self.lab01.attributedText = atts1;
    
    
    
    
    
    
    
    
    
    
    
    
    
    self.allEarnLabel.text = [NSString stringWithFormat:@"%.2f", earnModel.totalRebate];
    self.todayEarnLabel.text = [NSString stringWithFormat:@"%.2f", earnModel.todayRebate];
    self.monthEarnLabel.text = [NSString stringWithFormat:@"%.2f", earnModel.monthRebate];
    
    self.todayRealNameLabel.text = [NSString stringWithFormat:@"%ld", earnModel.todayAuth];
    self.monthRealNameLabel.text = [NSString stringWithFormat:@"%ld", earnModel.monthAuth];
    self.todayActiveLabel.text = [NSString stringWithFormat:@"%ld", earnModel.todayActive];
    self.monthActiveLabel.text = [NSString stringWithFormat:@"%ld", earnModel.monthActive];
    
    
}
@end
