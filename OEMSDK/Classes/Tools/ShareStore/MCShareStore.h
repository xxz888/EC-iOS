//
//  MCShareStore.h
//  MCStores
//
//  Created by Li Ping on 2019/5/23.
//  Copyright © 2019 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MCPopShareController.h"

typedef void(^ShareHandle)(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError);

NS_ASSUME_NONNULL_BEGIN

@interface MCShareStore : NSObject



/**
 弹出分享图片
 */
+ (void)popShareImage;

/**
 使用系统分享

 @param image 分享的图片
 */
+ (void)shareIOS:(UIImage *)image;

+ (void)shareIOS:(UIImage *)image completionHandler:(ShareHandle)handler;
/**
 使用友盟分享，若不成功调用系统分享（图片）

 @param image 分享的图片
 */
+ (void)sharePlatform:(UIImage *)image;

+ (void)shareWebLink:(NSArray *)items;

/**
 使用友盟分享，若不成功调用系统分享（图文链接）

 @param title 标题
 @param content 正文
 @param image 图片
 @param url 链接
 */
+ (void)sharePlatformWithTitle:( NSString * _Nullable)title content:( NSString * _Nullable)content image:(UIImage * _Nullable)image url:(NSString * _Nullable)url;







/**==================================================**/

/**
 分享到会话

 @param image image
 */
+ (void)shareToWeChatSession:(UIImage *)image;
+ (void)shareToWeChatSessionWithTitle:(NSString * _Nullable)title content:(NSString * _Nullable)content image:(UIImage * _Nullable)image url:(NSString * _Nullable)url;
/**
 分享到朋友圈

 @param image image
 */
+ (void)shareToWeChatTimeLine:(UIImage *)image;
+ (void)shareToWeChatTimeLineWithTitle:(NSString * _Nullable)title content:(NSString * _Nullable)content image:(UIImage * _Nullable)image url:(NSString * _Nullable)url;

/**
 分享到qq会话

 @param image image
 */
+ (void)shareToQQ:(UIImage *)image;
+ (void)shareToQQWithTitle:(NSString * _Nullable)title content:(NSString * _Nullable)content image:(UIImage * _Nullable)image url:(NSString * _Nullable)url;
/**
 分享到qq空间

 @param image image
 */
+ (void)shareToQzone:(UIImage *)image;
+ (void)shareToQzoneWithTitle:(NSString * _Nullable)title content:(NSString * _Nullable)content image:(UIImage * _Nullable)image url:(NSString * _Nullable)url;

/**
 保存到相册

 @param image iamge
 */
+ (void)saveToAlbum:(UIImage *)image;
+ (void)saveToAlbumFenXiang:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
