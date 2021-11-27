//
//  KDRepaymentDetailModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/25.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDTotalAmountModel.h"
#import "KDTotalOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDRepaymentDetailModel : NSObject
/** eg. 20 */
@property (nonatomic, copy) NSString *billDay;
/** eg. 10 */
@property (nonatomic, copy) NSString *repaymentDay;
/** eg.  */
@property (nonatomic, strong) NSArray <KDTotalOrderModel *> *totalOrder;
/** eg.  */
@property (nonatomic, strong) NSArray <KDTotalAmountModel *> *totalAmount;
@end

NS_ASSUME_NONNULL_END
