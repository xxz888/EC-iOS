//
//  KDChosePayTypeModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/15.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDChosePayTypeModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage  *icon;
@property (nonatomic, strong) NSString *des;
/** 0:余额 1:添加储蓄卡 2:储蓄卡 */
@property (nonatomic, assign) NSInteger type;
/** 选中状态 */
@property (nonatomic, assign) BOOL select;
@end

NS_ASSUME_NONNULL_END
