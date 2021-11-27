//
//  NSBundle+wgSubBundle.h
//  Pods
//
//  Created by wza on 2020/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (wgSubBundle)

//bundleName是和组件名字一样的
+ (instancetype)wg_subBundleWithBundleName:(NSString *)bundleName targetClass:(Class)targetClass;


/// OEMSDK默认的bundle，对应文件夹./Resource
+ (instancetype)OEMSDKBundle;

@end

NS_ASSUME_NONNULL_END
