//
//  MCShareSingleImgViewController.h
//  AFNetworking
//
//  Created by SS001 on 2020/7/21.
//

#import "MCBaseViewController.h"

typedef enum : NSUInteger {
    MCShareSingleImageBlue,     //蓝色背景
    MCShareSingleImageRed,      //红色背景
    MCShareSingleImageBlack,    //黑色背景
} MCShareSingleImageType;

NS_ASSUME_NONNULL_BEGIN

@interface MCShareSingleImgViewController : MCBaseViewController

/// 通过背景图片实例化，MCBrandConfiguration中默认为红色
/// @param type MCShareSingleImageType
- (instancetype)initWithImageType:(MCShareSingleImageType)type;

@end

NS_ASSUME_NONNULL_END
