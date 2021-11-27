//
//  KDPhoneAlertContent.h
//  Pods
//
//  Created by wza on 2020/9/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^touchBlock)(void);
@interface KDPhoneAlertContent : UIView

@property(nonatomic, copy) touchBlock touchBlock;

@end

NS_ASSUME_NONNULL_END
