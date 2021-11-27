//
//  KDProfitDirectPushEmptyView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDProfitDirectPushEmptyView.h"

@interface KDProfitDirectPushEmptyView ()
@property (weak, nonatomic) IBOutlet UIButton *pushBtn;

@end

@implementation KDProfitDirectPushEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDProfitDirectPushEmptyView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,103,30);
    gl.startPoint = CGPointMake(0.53, 0);
    gl.endPoint = CGPointMake(0.53, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:204/255.0 green:162/255.0 blue:100/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:170/255.0 green:115/255.0 blue:34/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    self.pushBtn.layer.cornerRadius = 15;
    self.pushBtn.layer.masksToBounds = YES;
    [self.pushBtn.layer insertSublayer:gl atIndex:0];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, (SCREEN_HEIGHT - 267 - 207) * 0.5 + 207, SCREEN_WIDTH, 267);
}

/** 立即推广 */
- (IBAction)directPushAction:(UIButton *)sender {
    [MCPagingStore pagingURL:rt_share_single];
}

@end

