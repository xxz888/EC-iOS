//
//  KDRefundTimeView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDRefundTimeView.h"

@interface KDRefundTimeView()
@property (nonatomic, assign) CGFloat viewHig;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@end

@implementation KDRefundTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDRefundTimeView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
}

- (void)setTimeArray:(NSArray *)timeArray
{
    _timeArray = timeArray;
    
    for (UIView *view in self.subviews) {
        if (view.tag < 200) {
            [view removeFromSuperview];
        }
    }
    
    if (timeArray == 0) {
        self.viewHig = 0;
    }
    if (timeArray.count < 5) {
        self.viewHig = 18;
        self.btn1.hidden = YES;
        self.btn2.hidden = YES;
    } else if (timeArray.count < 10) {
        self.viewHig = 46;
        self.btn1.hidden = YES;
        self.btn2.hidden = YES;
    } else {
        self.viewHig = 70;
        self.btn1.hidden = YES;
        self.btn2.hidden = YES;
    }
    
    if (self.timeArray.count != 0) {
        NSInteger count = 0;
        if (self.timeArray.count < 10) {
            count = self.timeArray.count;
        } else {
            count = 10;
        }
        CGFloat btnW = 50;
        CGFloat btnH = 18;
        CGFloat btnX = 0;
        CGFloat btnY = 0;
        CGFloat rowSpace = (SCREEN_WIDTH - 40 - btnW * 5 - 19.5 * 2) / 4;
        for (int i = 0; i < self.timeArray.count; i++) {
            NSInteger row = i % 5;
            NSInteger line = i / 5;
            btnX = 19.5 + (btnW + rowSpace) * row;
            btnY = (btnH + 10) * line;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = [UIColor qmui_colorWithHexString:@"#2574EA"].CGColor;
            btn.layer.cornerRadius = 9;
            btn.layer.masksToBounds = YES;
            [btn setTitleColor:[UIColor qmui_colorWithHexString:@"#2574EA"] forState:UIControlStateNormal];
            btn.titleLabel.font = LYFont(13);
            [btn setTitle:timeArray[i] forState:UIControlStateNormal];
            [self addSubview:btn];
            btn.tag = 100 + i;
//            if (i >= count) {
//                btn.hidden = YES;
//            } else {
//                btn.hidden = NO;
//            }
        }
    }
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH - 40, self.viewHig);
}
- (IBAction)clickBtn1:(UIButton *)sender {
    for (UIButton *btn in self.subviews) {
        btn.hidden = NO;
    }
    self.viewHig = (18 + 10) * self.timeArray.count / 5 + 18 + 11 + 12;
    [self layoutIfNeeded];
    if ([self.delegate respondsToSelector:@selector(refundTimeViewDelegateChangeTimeViewHig:)]) {
        [self.delegate refundTimeViewDelegateChangeTimeViewHig:self.viewHig];
    }
}
- (IBAction)clickbtn2:(id)sender {
    self.viewHig = 70;
    
    for (UIButton *btn in self.subviews) {
        if (btn.tag > 109) {
            btn.hidden = NO;
        } else {
            btn.hidden = NO;
        }
    }
    
    [self layoutIfNeeded];
    if ([self.delegate respondsToSelector:@selector(refundTimeViewDelegateChangeTimeViewHig:)]) {
        [self.delegate refundTimeViewDelegateChangeTimeViewHig:self.viewHig];
    }
}
@end
