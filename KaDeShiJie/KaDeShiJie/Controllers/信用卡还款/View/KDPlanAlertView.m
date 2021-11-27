//
//  KDPlanAlertView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDPlanAlertView.h"

@interface KDPlanAlertView ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) QMUIModalPresentationViewController *modalVC;
@end

@implementation KDPlanAlertView

- (QMUIModalPresentationViewController *)modalVC
{
    if (!_modalVC) {
        _modalVC = [[QMUIModalPresentationViewController alloc] init];
    }
    return _modalVC;
}


- (IBAction)bottomAction:(UIButton *)sender {
    [self.modalVC hidingAnimation];
}

- (void)showView
{
    KDPlanAlertView *planView = [[[NSBundle mainBundle] loadNibNamed:@"KDPlanAlertView" owner:nil options:nil] lastObject];
    self.modalVC.contentView = planView;
    self.modalVC.contentViewMargins = UIEdgeInsetsMake(0, (ScreenScale - 210) * 0.5, 0, (ScreenScale - 210) * 0.5);
    [self.modalVC showWithAnimated:YES completion:nil];
}

@end
