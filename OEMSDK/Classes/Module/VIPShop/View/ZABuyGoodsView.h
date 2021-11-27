//
//  ZABuyGoodsView.h
//  Project
//
//  Created by SS001 on 2019/7/15.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZAGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZABuyGoodsView : UIView

+ (instancetype)showView;

@property (nonatomic, strong) ZAGoodsModel *goodsModel;

@property (nonatomic, copy) void (^callBack)(CGFloat viewH);

@end

NS_ASSUME_NONNULL_END
