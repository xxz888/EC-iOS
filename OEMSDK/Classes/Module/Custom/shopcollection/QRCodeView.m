//
//  QRCodeView.m
//  Project
//
//  Created by SS001 on 2019/11/30.
//  Copyright © 2019 LY. All rights reserved.
//

#import "QRCodeView.h"

@interface QRCodeView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation QRCodeView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
}
@end
