//
//  KDCreditCardAccountModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDCreditCardAccountModel : NSObject

/** eg. creditCardNumber */
@property (nonatomic, copy) NSString *creditCardNumber;
/** eg. 100 */
@property (nonatomic, copy) NSString *brandId;
/** eg.  */
@property (nonatomic, copy) NSString *expiredTime;
/** eg. 200 */
@property (nonatomic, assign) NSInteger creditBlance;
/** eg. 26 */
@property (nonatomic, assign) NSInteger repaymentDate;
/** eg. userId */
@property (nonatomic, copy) NSString *userId;
/** eg. 1 */
@property (nonatomic, assign) NSInteger isAuth;
/** eg. 0 */
@property (nonatomic, assign) NSInteger isConsume;
/** eg. 99-7 */
@property (nonatomic, copy) NSString *version;
/** eg.  */
@property (nonatomic, copy) NSString *channelName;
/** eg.  */
@property (nonatomic, copy) NSString *userName;
/** eg. 15800633815 */
@property (nonatomic, copy) NSString *phone;
/** eg. 0 */
@property (nonatomic, assign) NSInteger blance;
/** eg. 0 */
@property (nonatomic, assign) NSInteger freezeBlance;
/** eg.  */
@property (nonatomic, copy) NSString *securityCode;
/** eg. 1 */
@property (nonatomic, assign) NSInteger billDate;
/** eg.  */
@property (nonatomic, copy) NSString *bankName;
/** eg. 34 */
@property (nonatomic, assign) NSInteger itemId;
/** eg.  */
@property (nonatomic, copy) NSString *brandName;

@end

NS_ASSUME_NONNULL_END
