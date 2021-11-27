//
//  KDProfitCellHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDProfitCellHeaderView.h"

@implementation KDProfitCellHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDProfitCellHeaderView" owner:nil options:nil] lastObject];
    }
    return self;
}

@end
