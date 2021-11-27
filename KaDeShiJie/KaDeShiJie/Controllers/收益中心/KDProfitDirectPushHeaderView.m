//
//  KDProfitDirectPushHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDProfitDirectPushHeaderView.h"

@interface KDProfitDirectPushHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@end

@implementation KDProfitDirectPushHeaderView

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDProfitDirectPushHeaderView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 207);
}
@end
