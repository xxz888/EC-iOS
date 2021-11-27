//
//  KDTotalAmountModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/25.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDTotalAmountModel : NSObject
/** eg. 0 */
@property (nonatomic, assign) NSInteger repaymentedSuccessCount;
/** eg. 0 */
@property (nonatomic, assign) CGFloat repaymentedAmount;
/** eg. rate */
@property (nonatomic, assign) CGFloat rate;
/** eg. 2000 */
@property (nonatomic, assign) CGFloat taskAmount;
/** eg. 0 */
@property (nonatomic, assign) CGFloat usedCharge;
/** eg. 6 */
@property (nonatomic, assign) NSInteger taskCount;
/** eg. 23.25 */
@property (nonatomic, assign) CGFloat totalServiceCharge;
/** eg. 0 */
@property (nonatomic, assign) CGFloat consumedAmount;
@end

NS_ASSUME_NONNULL_END
