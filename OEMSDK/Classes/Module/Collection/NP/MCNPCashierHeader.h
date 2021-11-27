//
//  MCNPCashierHeader.h
//  MCOEM
//
//  Created by wza on 2020/5/12.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCNPCashierHeaderDelegate <NSObject>

- (void)clickServiceOnLine;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MCNPCashierHeader : UIView

- (void)requestDefaultXinyong;

@property (nonatomic, weak) id<MCNPCashierHeaderDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
