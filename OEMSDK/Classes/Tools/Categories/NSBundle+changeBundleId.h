//
//  NSBundle+changeBundleId.h
//  Project
//
//  Created by wza on 2020/4/6.
//  Copyright © 2020 LY. All rights reserved.
//




#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (changeBundleId)

/**
 修改包名

 @param bundleId 包名，nil为默认包名
 */
- (void)changeBundleIdentifier:(NSString *)bundleId;

@end

NS_ASSUME_NONNULL_END
