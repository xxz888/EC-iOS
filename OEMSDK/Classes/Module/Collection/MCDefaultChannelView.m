//
//  MCDefaultChannelView.m
//  MCOEM
//
//  Created by wza on 2020/5/5.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCDefaultChannelView.h"

@implementation MCDefaultChannelView

- (IBAction)closeTouched:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate channelViewClickOn:sender];
    }
}
- (IBAction)changeTouched:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate channelViewClickOn:sender];
    }
}
- (IBAction)sureTouched:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate channelViewClickOn:sender];
    }
}


@end
