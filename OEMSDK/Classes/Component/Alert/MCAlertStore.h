//
//  MCAlertStore.h
//  Project
//
//  Created by Li Ping on 2019/6/21.
//  Copyright © 2019 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static CGFloat DEFAULT_H = 160; //最小高度，根据文字适配


typedef void (^sureBlock)(void);
typedef void (^cancelBlock)(void);

@interface MCAlertStore : NSObject

@property (nonatomic, copy) cancelBlock cancelblock;
@property (nonatomic, copy) sureBlock block;

+ (instancetype)shareInstance;

/**
 弹窗，只接收确认按钮回调

 @param tit 标题
 @param message 信息
 @param titles button的标题
 @param block 点击确认的回调
 */
+ (void)showWithTittle:(NSString *)tit message:(NSString *)message buttonTitles:(NSArray *)titles sureBlock:(nullable sureBlock)block;


/**
 弹窗，接收确认按钮、取消按钮的回调

 @param tit 标题
 @param message 信息
 @param titles button的标题
 @param block 确认回调
 @param cancelblock 取消回调
 */
+ (void)showWithTittle:(NSString *)tit message:(NSString *)message buttonTitles:(NSArray *)titles sureBlock:(sureBlock)block cancelBlock:(nullable cancelBlock)cancelblock;

@end

NS_ASSUME_NONNULL_END
