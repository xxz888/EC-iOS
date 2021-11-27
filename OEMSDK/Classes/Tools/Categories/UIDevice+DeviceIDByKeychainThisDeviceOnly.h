//
//  UIDevice+DeviceIDByKeychainThisDeviceOnly.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/16.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (DeviceIDByKeychainThisDeviceOnly)
+ (NSString *)identifierByKeychain;
@end

NS_ASSUME_NONNULL_END
