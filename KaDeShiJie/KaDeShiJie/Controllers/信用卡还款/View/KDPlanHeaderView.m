//
//  KDPlanHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDPlanHeaderView.h"

@interface KDPlanHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet QMUIButton *openBtn;

@end

@implementation KDPlanHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.masksToBounds = YES;
    self.openBtn.imagePosition = QMUIButtonImagePositionRight;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDPlanHeaderView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (IBAction)clickOpenBtnAction:(QMUIButton *)sender {
    if (self.open) {
        self.open = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.openBtn.imageView.transform = CGAffineTransformIdentity;
            self.bgView.layer.qmui_maskedCorners = QMUILayerMinXMinYCorner | QMUILayerMaxXMinYCorner | QMUILayerMinXMaxYCorner | QMUILayerMaxXMaxYCorner;
        }];
    } else {
        self.open = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.bgView.layer.cornerRadius = 10;
            self.bgView.layer.qmui_maskedCorners = QMUILayerMinXMinYCorner | QMUILayerMaxXMinYCorner;
            self.openBtn.imageView.transform = CGAffineTransformRotate(self.openBtn.transform, M_PI);
        }];
    }
    if ([self.delegate respondsToSelector:@selector(planHeaderViewDelegateWithOpenType:)]) {
        [self.delegate planHeaderViewDelegateWithOpenType:self.open];
    }
}
@end
