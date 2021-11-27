//
//  KDTopDelegateNewModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/27.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDTopDelegateNewModel : NSObject

/** eg. 0 */
@property (nonatomic, copy) NSString *firSize;
/** eg. 18712340015 */
@property (nonatomic, copy) NSString *phone;
/** eg. 3 */
@property (nonatomic, copy) NSString *promotionLevelId;
/** eg. 2020-09-26 */
@property (nonatomic, copy) NSString *createTime;
/** eg.  */
@property (nonatomic, copy) NSString *userName;
/** eg. 顶级代理 */
@property (nonatomic, copy) NSString *gradeName;
/** eg. userId */
@property (nonatomic, copy) NSString *userId;
/** eg. 1 */
@property (nonatomic, copy) NSString *realSize;

@end

NS_ASSUME_NONNULL_END
