//
//  MCCashierKeyBoard.m
//  MCOEM
//
//  Created by wza on 2020/5/4.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCCashierKeyBoard.h"


@interface MCCashierKeyBoard ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWConstraint;


@property (weak, nonatomic) IBOutlet UIButton *shoukuanButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *backSpaceButton;

@end

@implementation MCCashierKeyBoard

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.shoukuanButton setTitle:@"确认\n收款" forState:UIControlStateNormal];
    self.shoukuanButton.titleLabel.lineBreakMode = 0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.buttonWConstraint.constant = (DEVICE_WIDTH-3)/4;
    
}

- (IBAction)buttonTouched:(UIButton *)sender {
    
    NSString *title = nil;
    if (sender == self.backSpaceButton) {          //退格
        title = @"退格";
    } else if (sender == self.clearButton) {       //清除
        title = @"清除";
    } else if (sender == self.shoukuanButton) {    //收款
        title = @"收款";
    } else {
        title = sender.currentTitle;
    }
    
    [self.delegate cashierKeyBoardDidClickOnTitle:title];
}






@end
