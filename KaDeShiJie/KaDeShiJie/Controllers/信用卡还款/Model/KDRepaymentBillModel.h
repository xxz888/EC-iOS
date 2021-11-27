//
//  KDRepaymentBillModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDDirectCardContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDRepaymentBillModel : NSObject

/** eg. 4 */
@property (nonatomic, assign) NSInteger totalElements;
/** eg. 1 */
@property (nonatomic, assign) NSInteger size;
/** eg. 4 */
@property (nonatomic, assign) NSInteger totalPages;
/** eg.  */
@property (nonatomic, strong) NSArray <KDDirectCardContentModel *> *content;
/** eg. 0 */
@property (nonatomic, assign) NSInteger number;
/** eg. 0 */
@property (nonatomic, assign) BOOL last;
/** eg. 1 */
@property (nonatomic, assign) NSInteger numberOfElements;
/** eg. 1 */
@property (nonatomic, assign) BOOL first;


@end

NS_ASSUME_NONNULL_END
