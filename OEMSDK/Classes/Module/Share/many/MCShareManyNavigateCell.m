//
//  MCShareManyNavigateCell.m
//  Pods
//
//  Created by wza on 2020/8/20.
//

#import "MCShareManyNavigateCell.h"

@implementation MCShareManyNavigateCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *imgView = [[UIImageView alloc] init];
    [self.contentView addSubview:imgView];
    
    self.bigImgView = imgView;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(3, 3, 3, 3));
    }];
    
    UIView *selBgview = [[UIView alloc] initWithFrame:self.frame];
    selBgview.layer.borderWidth = 3;
    selBgview.layer.borderColor = MAINCOLOR.CGColor;
    self.selectedBackgroundView = selBgview;
    
    
    
}

@end
