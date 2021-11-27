//
//  MCWithDrawTypeDialogView.m
//  Pods
//
//  Created by wza on 2020/8/21.
//

#import "MCWithDrawTypeDialogView.h"

@implementation MCWithDrawTypeDialogView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 15;
    self.clipsToBounds = YES;
}

- (IBAction)cardTouched:(id)sender {
    [self.delegate withdrawTypeDialogviewOnChanged:@"card"];
}

- (IBAction)aliTouched:(id)sender {
    [self.delegate withdrawTypeDialogviewOnChanged:@"ali"];
}

@end
