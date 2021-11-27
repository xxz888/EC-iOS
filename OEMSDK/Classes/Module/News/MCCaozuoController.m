//
//  MCCaozuoController.m
//  MCOEM
//
//  Created by wza on 2020/5/12.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCCaozuoController.h"

@interface MCCaozuoController ()

@end

@implementation MCCaozuoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"操作教程" tintColor:nil];
    for (int i=1000; i<1008; i++) {
        UIStackView *stack = [self.view viewWithTag:i];
        if (stack && stack.arrangedSubviews && stack.arrangedSubviews.count > 0) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouched:)];
            [stack addGestureRecognizer:tap];
            for (UIView *subv in stack.arrangedSubviews) {
                if ([subv isKindOfClass:[UIImageView class]]) {
                    UIImageView *imgView = (UIImageView *)subv;
                    if (imgView.image) {
                        imgView.image = [imgView.image imageWithColor:MAINCOLOR];
                    }
                }
            }
        }
    }
}
- (void)onTouched:(UITapGestureRecognizer *)sender {
    UIStackView *stack = (UIStackView *)sender.view;
    if (stack) {
        for (UIView *subv in stack.arrangedSubviews) {
            if ([subv isKindOfClass:[UILabel class]]) {
                UILabel *titLab = (UILabel *)subv;
                if (titLab.text) {
                    [MCPagingStore pushWebWithTitle:titLab.text classification:@"功能跳转"];
                    break;
                }
            }
        }
    }
}

@end
