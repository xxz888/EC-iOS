//
//  KDPlanPreviewView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDPlanPreviewView.h"

@interface KDPlanPreviewView ()
@property (nonatomic, strong) QMUIModalPresentationViewController *modalVC;
@end

@implementation KDPlanPreviewView

- (QMUIModalPresentationViewController *)modalVC
{
    if (!_modalVC) {
        _modalVC = [[QMUIModalPresentationViewController alloc] init];
    }
    return _modalVC;
}

- (void)showView
{
    KDPlanPreviewView *planView = [[[NSBundle mainBundle] loadNibNamed:@"KDPlanPreviewView" owner:nil options:nil] lastObject];
    self.modalVC.contentView = planView;
    self.modalVC.contentViewMargins = UIEdgeInsetsMake(0, (ScreenScale - 210) * 0.5, 0, (ScreenScale - 210) * 0.5);
    [self.modalVC showWithAnimated:YES completion:nil];
}

- (IBAction)clickBtn1:(id)sender {
    [self.modalVC hidingAnimation];
    if ([self.delegate respondsToSelector:@selector(planPreviewViewWithType:)]) {
        [self.delegate planPreviewViewWithType:1];
    }
}

- (IBAction)clickBtn2:(id)sender {
    [self.modalVC hidingAnimation];
    if ([self.delegate respondsToSelector:@selector(planPreviewViewWithType:)]) {
        [self.delegate planPreviewViewWithType:2];
    }
}
@end
