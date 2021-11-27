//
//  KDWithDrawHistoryheaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDWithDrawHistoryheaderView.h"

@interface KDWithDrawHistoryheaderView ()
@property (weak, nonatomic) IBOutlet UILabel *allEatnLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayEarnLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthEarnLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayWithDrawNumberView;
@property (weak, nonatomic) IBOutlet UILabel *monthWithDrawNumberView;
@property (weak, nonatomic) IBOutlet UILabel *todayWithDrawNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthWithDrawNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *allEarnView;
@property (weak, nonatomic) IBOutlet UILabel *todayEarnView;
@property (weak, nonatomic) IBOutlet UILabel *monthEarnView;
@property (weak, nonatomic) IBOutlet QMUIButton *bottomBtn;
@end

@implementation KDWithDrawHistoryheaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
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
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDWithDrawHistoryheaderView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 324);
}

- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    
    if ([titleString isEqualToString:@"提现记录"]) {
        self.allEatnLabel.text = @"提现总金额（元）";
        self.todayEarnLabel.text = @"当日提现（元）";
        self.monthEarnLabel.text = @"当月提现（元）";
        self.todayWithDrawNumberLabel.text = @"当日提现(笔)：";
        self.monthWithDrawNumberLabel.text = @"当月提现(笔)：";
        [self.bottomBtn setTitle:@"提现历史记录" forState:UIControlStateNormal];
    }
    if ([titleString isEqualToString:@"信用弥补记录"]) {
        self.allEatnLabel.text = @"弥补总额度（元）";
        self.todayEarnLabel.text = @"当日弥补额度（元）";
        self.monthEarnLabel.text = @"当月弥补额度（元）";
        self.todayWithDrawNumberLabel.text = @"当日弥补(笔)：";
        self.monthWithDrawNumberLabel.text = @"当月弥补(笔)：";
        [self.bottomBtn setTitle:@"历史弥补记录" forState:UIControlStateNormal];
    }
    if ([titleString isEqualToString:@"VIP收益"]) {
        self.allEatnLabel.text = @"VIP总收益（元）";
        self.todayEarnLabel.text = @"当日收益（元）";
        self.monthEarnLabel.text = @"当月收益（元）";
        self.todayWithDrawNumberLabel.text = @"当日充值(人)：";
        self.monthWithDrawNumberLabel.text = @"当月充值(人)：";
        [self.bottomBtn setTitle:@"收益明细" forState:UIControlStateNormal];
    }
}

- (void)setModel:(KDHistoryModel *)model
{
    _model = model;
    
    self.allEarnView.text = [NSString stringWithFormat:@"%.2f", model.totalAmount];
    self.todayEarnView.text = [NSString stringWithFormat:@"%.2f", model.todayAmount];
    self.monthEarnView.text = [NSString stringWithFormat:@"%.2f", model.monthAmount];
    self.todayWithDrawNumberView.text = [NSString stringWithFormat:@"%ld", model.todayCount];
    self.monthWithDrawNumberView.text = [NSString stringWithFormat:@"%ld", model.monthCount];
}
@end
