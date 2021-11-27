//
//  KDJFOrderDetailHeaderView.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/10.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFOrderDetailHeaderView.h"

@implementation KDJFOrderDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDJFOrderDetailHeaderView" owner:nil options:nil] firstObject];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    ViewRadius(self.dImv, 20);
    ViewRadius(self.dimv2, 11);
    
    ViewBorderRadius(self.fuzhi1Btn, 4, 1, [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]);
    ViewBorderRadius(self.fuzhi2Btn, 4, 1, [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]);

}


- (IBAction)fuzhi2Action:(id)sender {
}

- (IBAction)fuzhi1Action:(id)sender {
}
@end
