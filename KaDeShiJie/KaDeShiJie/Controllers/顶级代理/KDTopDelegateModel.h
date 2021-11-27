//
//  KDTopDelegateModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/19.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDTopDelegateModel : NSObject

@property (nonatomic, copy) NSString *firstUserId;
@property (nonatomic, copy) NSString *firstUserName;
@property (nonatomic, copy) NSString *firstUserPhone;
@property (nonatomic, copy) NSString *fargetTime;
@property (nonatomic, assign) NSInteger realNameCount;
@property (nonatomic, assign) NSInteger activeCount;
@end

NS_ASSUME_NONNULL_END
