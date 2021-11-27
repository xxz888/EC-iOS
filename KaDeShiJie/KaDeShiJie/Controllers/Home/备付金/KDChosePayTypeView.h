//
//  KDChosePayTypeView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDChosePayTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDChosePayTypeView : UIView

@property (nonatomic, copy) void (^callBack)(KDChosePayTypeModel *choseModel, NSString *selectName);
@property (nonatomic, copy) void (^hideView)(void);
@property (nonatomic, strong) NSString *bankName;
@end

NS_ASSUME_NONNULL_END
