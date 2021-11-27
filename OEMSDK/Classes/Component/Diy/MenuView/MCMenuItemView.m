//
//  MCMenuItemView.m
//  Project
//
//  Created by Ning on 2019/11/5.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCMenuItemView.h"

@implementation MCMenuItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.iconeWidth = 45;
        self.iconeWidth = 45;
        self.spacing    = 3;
        [self p_setUI];
        [self p_layoutView];
        [self p_addTapGestureRecognizer];
    }
    return self;
}

- (void) p_setUI{
//     [self addSubview:self.iconeBgView];
    [self addSubview:self.iconeImageView];
    [self addSubview:self.titleLabel];
}

- (void) p_layoutView{
    [self.iconeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).mas_equalTo(-8);
        make.width.mas_equalTo(self.iconeWidth);
        make.height.mas_equalTo(self.iconeWidth);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconeImageView.mas_bottom).mas_equalTo(3);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(17);
    }];
}

- (void)refreshUI{
    [self resetIconeWidth:self.iconeWidth height:self.iconeHeight];
}

- (void)p_addTapGestureRecognizer {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSeletedMenuItem:)];
    [self addGestureRecognizer:tap];
}

- (void) resetIconeWidth:(CGFloat)width height:(CGFloat)height{
    if (!width || !height) {return;}

    self.iconeWidth = width;
    self.iconeHeight = height;
    
    [self.iconeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.iconeWidth);
        make.height.mas_equalTo(self.iconeHeight);
    }];
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconeImageView.mas_bottom).mas_equalTo(self.spacing);
    }];
}

- (void) updataBackgroundColor:(UIColor*)backgroundColor
                    titlesFont:(UIFont*)fontSize
                    iconeWidth:(CGFloat)iconeWidth
                   iconeHeight:(CGFloat)iconeHeight{
    self.backgroundColor = backgroundColor;
    self.titleLabel.font = fontSize;
    [self resetIconeWidth:iconeWidth height:iconeHeight];
}

- (void) updataWithDataSource:(NSDictionary*)datasource{
    NSString* imageUrl = datasource[@"icon"];
    [self.iconeImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached progress:nil completed:nil];
    self.titleLabel.text = datasource[@"title"];
}

- (void) didSeletedMenuItem:(UITapGestureRecognizer*) tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSeletedMenuItemWithTag:)]) {
        [self.delegate didSeletedMenuItemWithTag:tap.view.tag];
    }
}

- (UIImageView*) iconeImageView {
    if (nil == _iconeImageView) {
        _iconeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconeImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconeImageView;
}

- (UILabel*) titleLabel {
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end
