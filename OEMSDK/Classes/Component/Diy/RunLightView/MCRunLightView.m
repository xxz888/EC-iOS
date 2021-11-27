//
//  MCRunLightView.m
//  Project
//
//  Created by Ning on 2019/11/18.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCRunLightView.h"
#import "MCScrollText.h"
#define  kLeftIconeImageView  [UIImage mc_imageNamed:@"rh_home_gonggao"]
@interface MCRunLightView ()

@end
@implementation MCRunLightView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconeImageView];
        [self addSubview:self.leftLabel];
        [self addSubview:self.scrololerView];
    }
    return self;
}

- (MCScrollText*) scrololerView {
    if (nil == _scrololerView) {
        _scrololerView = [[MCScrollText alloc] initWithFrame:CGRectMake(self.leftLabel.qmui_right + 10, 0, SCREEN_WIDTH - self.leftLabel.qmui_right - 20, 40)];
    }
    return _scrololerView;
}
- (UIImageView*) iconeImageView {
    if (nil == _iconeImageView) {
        _iconeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (self.ly_height - 20) * 0.5, 20, 20)];
        _iconeImageView.image = [kLeftIconeImageView imageWithColor:[UIColor mainColor]];
    }
    return _iconeImageView;
}

- (UILabel *)leftLabel
{
    if (_leftLabel == nil) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.iconeImageView.qmui_right + 10, self.iconeImageView.ly_y - 2, 1, 24)];
        lineView.backgroundColor = [UIColor qmui_colorWithHexString:@"#D8D8D8"];
        [self addSubview:lineView];
        
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineView.qmui_right + 10, self.iconeImageView.ly_y + 2, 32, 16)];
        _leftLabel.textColor = [UIColor whiteColor];
        _leftLabel.text = @"消息";
        _leftLabel.font = LYFont(10);
        _leftLabel.layer.masksToBounds = YES;
        _leftLabel.layer.cornerRadius = 3;
        _leftLabel.backgroundColor = [UIColor mainColor];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftLabel;
}
@end
