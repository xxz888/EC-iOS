//
//  MCTiXianAlertView.m
//  OEMSDK
//
//  Created by apple on 2021/4/1.
//

#import "MCTiXianAlertView.h"

@implementation MCTiXianAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)closeAction:(id)sender {
    [self.presentView hideWithAnimated:YES completion:nil];
    [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
}
@end
