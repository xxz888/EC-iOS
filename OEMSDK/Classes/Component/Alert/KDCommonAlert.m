//
//  KDCommonAlert.m
//  OEMSDK
//
//  Created by apple on 2020/10/29.
//

#import "KDCommonAlert.h"
@interface KDCommonAlert()

@end
@implementation KDCommonAlert

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void)initKDCommonAlertContent:(NSString *)content isShowClose:(BOOL)isShowClose{
    QMUIModalPresentationViewController * alert = [[QMUIModalPresentationViewController alloc]init];
    alert.contentView = self;
    alert.dimmingView.userInteractionEnabled = NO;
    self.alertContent.text = content;
    self.qmuiAlter = alert;
    self.leftBtn.hidden = self.rightBtn.hidden = isShowClose;
    self.closeBtn.hidden = !isShowClose;
    [alert showWithAnimated:YES completion:nil];
    
}
- (IBAction)rightAction:(id)sender {
    if (self.rightActionBlock) {
        self.rightActionBlock();
    }
    [self.qmuiAlter hideWithAnimated:YES completion:nil];
}

- (IBAction)leftAction:(id)sender {
    [self.qmuiAlter hideWithAnimated:YES completion:nil];
}

- (IBAction)closeAction:(id)sender {
    [self.qmuiAlter hideWithAnimated:YES completion:nil];
    if (self.middleActionBlock) {
        self.middleActionBlock();
    }
}
@end
