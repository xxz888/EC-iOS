//
//  KDJFShopDetailHeaderView.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/8.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFShopDetailHeaderView.h"

@implementation KDJFShopDetailHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDJFShopDetailHeaderView"
                                              owner:nil
                                            options:nil] lastObject];
    }
    return self;
}
@end
