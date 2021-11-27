//
//  MCBannerView.h
//  MCOEM
//
//  Created by SS001 on 2020/3/30.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//typedef enum : NSUInteger {
//    MCBannerSingle = 0,
//    MCBannerMutiple,
//    MCBannerTeam,
//    MCBannerVideo,
//
//} MCBannerType;

typedef void(^mcBannerRectHeightBlock)(CGFloat h);

@interface MCBannerView : UIView

@property (nonatomic, assign) IBInspectable NSInteger bannerType;



- (instancetype)initWithFrame:(CGRect)frame bannerType:(NSInteger)type;

/**
 如果是网络加载的图片，可在该block中调整高度，多张图为第一张的高度
 */
@property (nonatomic, copy) mcBannerRectHeightBlock resetHeightBlock;

@end

NS_ASSUME_NONNULL_END
