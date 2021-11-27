//
//  KDCreditModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/14.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDCreditModel : NSObject

/** 自身信用额度 */
@property (nonatomic, assign) CGFloat selfQuota;
/** 被授信额度 */
@property (nonatomic, assign) CGFloat superiorQuota;
/** 自身丢失信用额度 */
@property (nonatomic, assign) CGFloat lostSelfQuota;
/** 当前可用信用额度 */
@property (nonatomic, assign) CGFloat useableQuota;
/** 丢失被授信额度 */
@property (nonatomic, assign) CGFloat lostSuperiorQuota;
/** 给下级授信的总额度 */
@property (nonatomic, assign) CGFloat subordinateQuota;
/** 下级丢失授信额度 */
@property (nonatomic, assign) CGFloat lostSubordinateQuota;
/** 总信用额度 */
@property (nonatomic, assign) CGFloat totalQuota;

@end

NS_ASSUME_NONNULL_END
