//
//  KDGuidePageManager.h
//  KaDeShiJie
//
//  Created by apple on 2021/3/5.
//  Copyright © 2021 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define WLGuidePageHomeKey @"WLGuidePageHomeKey"
#define KDGuidePageTypeXinYongKaShouKuanKey @"KDGuidePageTypeXinYongKaShouKuanKey"


NS_ASSUME_NONNULL_BEGIN
typedef void(^FinishBlock)(void);
typedef void(^ShiMingBlock)(void);


typedef NS_ENUM(NSInteger, KDGuidePageType) {
    KDGuidePageTypeHome = 0,
    KDGuidePageTypeXinYongKaShouKuan,
};


@interface KDGuidePageManager : NSObject

// 获取单例
+ (instancetype)shareManager;

/**
 显示方法
 
 @param type 指引页类型
 */
- (void)showGuidePageWithType:(KDGuidePageType)type emptyRect:(CGRect)emptyRect imgRect:(CGRect)imgRect imgStr:(NSString *)imgStr;
/**
 显示方法
 
 @param type 指引页类型
 @param completion 完成时回调
 */
- (void)showGuidePageWithType:(KDGuidePageType)type emptyRect:(CGRect)emptyRect imgRect:(CGRect)imgRect imgStr:(NSString *)imgStr completion:(FinishBlock)completion;

#pragma mark --------------------查询是否实名-------------------------
-(void)requestShiMing:(ShiMingBlock)shimingBlock;
@end

NS_ASSUME_NONNULL_END
