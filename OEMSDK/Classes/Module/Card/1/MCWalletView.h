//
//  MCWalletView.h
//  MCOEM
//
//  Created by wza on 2020/6/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBankCardModel.h"
#import "MCWalletCollectionViewCell.h"



NS_ASSUME_NONNULL_BEGIN

@protocol MCWalletViewDelegate <NSObject>

- (void)walletViewDidSelectedAction:(MCBankCardCellActionType)type model:(MCBankCardModel *)model;

@end

@interface MCWalletView : UIView

@property(nonatomic, strong) NSArray<MCBankCardModel *> *dataSource;

@property(nonatomic, weak) id <MCWalletViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
