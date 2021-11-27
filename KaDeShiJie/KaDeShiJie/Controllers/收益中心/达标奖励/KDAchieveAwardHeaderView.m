//
//  KDAchieveAwardHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDAchieveAwardHeaderView.h"

@interface KDAchieveAwardHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *allEarnView;
@property (weak, nonatomic) IBOutlet UILabel *todayEarnView;
@property (weak, nonatomic) IBOutlet UILabel *monthEarnView;

@end

@implementation KDAchieveAwardHeaderView

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDAchieveAwardHeaderView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 325);
}

- (void)setModel:(KDHistoryModel *)model {
    _model = model;
    self.allEarnView.text = [NSString stringWithFormat:@"%.2f", model.totalAmount];
    self.todayEarnView.text = [NSString stringWithFormat:@"%.2f", model.todayAmount];
    self.monthEarnView.text = [NSString stringWithFormat:@"%.2f", model.monthAmount];
}

@end
