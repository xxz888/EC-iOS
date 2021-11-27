//
//  UIView+newnib.h
//  MCOEM
//
//  Created by wza on 2020/3/9.
//  Copyright © 2020 MingChe. All rights reserved.
//




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (newnib)
/**
 从xib创建的简便方法

 @return UIView
 */
+ (instancetype)newFromNib;
@end

NS_ASSUME_NONNULL_END
