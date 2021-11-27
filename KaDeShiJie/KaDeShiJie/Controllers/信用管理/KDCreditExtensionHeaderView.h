//
//  KDCreditExtensionHeaderView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDCreditExtensionHeaderView : UIView

@property (nonatomic, copy) void (^selectIndex)(NSInteger type);
@property (nonatomic, copy) void (^searchCredit)(NSString *searchStr);
@end

NS_ASSUME_NONNULL_END
