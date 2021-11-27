//
//  KDShareSingleHeader.m
//  KaDeShiJie
//
//  Created by wza on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDShareSingleHeader.h"

@interface KDShareSingleHeader ()
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@end

@implementation KDShareSingleHeader

- (UILabel *)topLabel
{
    if (!_topLabel) {
        UIImage *img = [UIImage imageNamed:@"share_single_img"];
        CGFloat hig = img.size.height * SCREEN_WIDTH / img.size.width;
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, hig - 250, 150, 20)];
        _topLabel.text = @"扫码即可注册开通";
        _topLabel.font = LYFont(13);
        _topLabel.textColor = [UIColor qmui_colorWithHexString:@"#333333"];
        _topLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topLabel;
}

- (UILabel *)bottomLabel
{
    if (!_bottomLabel) {
        CGRect rect =  [MCImageStore getAlphaFrameInImage:[UIImage imageNamed:@"share_single_img"]];
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5,
                                                                 
                                                                 [[UIScreen mainScreen] bounds].size.height == 667 ? 248 :
                                                                 [[UIScreen mainScreen] bounds].size.height == 896 ? 275 :
                                                                 [[UIScreen mainScreen] bounds].size.height == 736 ? 280 :
                                                                 [[UIScreen mainScreen] bounds].size.height == 812 ? 255 : 255

                                                                 , 150, 15)];
        NSString *first = [SharedUserInfo.phone substringWithRange:NSMakeRange(0, 3)];
        NSString *last = [SharedUserInfo.phone substringWithRange:NSMakeRange(7, 4)];
        _bottomLabel.text = [NSString stringWithFormat:@"推荐人:%@****%@", first, last];
        _bottomLabel.font = LYFont(11);
        _bottomLabel.textColor = [UIColor qmui_colorWithHexString:@"#ffffff"];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIImage *img = [UIImage imageNamed:@"share_single_img"];
    CGFloat hig = img.size.height * SCREEN_WIDTH / img.size.width;
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, hig);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (MCModelStore.shared.preUserPhone.length == 11) {
//        [self.imgView addSubview:self.topLabel];
        [self.imgView addSubview:self.bottomLabel];
    }
    
    
    
    
    
    self.imgView.image = [MCImageStore creatShareImageWithImage:[UIImage imageNamed:@"share_single_img"]];
    
    [self layoutIfNeeded];
    
    
}

- (UIImage *)snapshotScreenInView:(UIView *)view
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(view.bounds.size);
    }
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
