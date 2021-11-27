//
//  MCWalletCollectionViewCell.h
//  MCOEM
//
//  Created by wza on 2020/6/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBankCardModel.h"
#import "MCBankCardCell.h"

NS_ASSUME_NONNULL_BEGIN



@interface MCWalletCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) MCBankCardModel *model;

@property(nonatomic, assign) BOOL isExpand;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (weak, nonatomic) IBOutlet UIView *actionView;

@property (weak, nonatomic) IBOutlet UISwitch *dfSwitch;

@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLab;

@property (weak, nonatomic) IBOutlet UIButton *dfButton;
@property (weak, nonatomic) IBOutlet UIImageView *waterImgView;
@property (weak, nonatomic) IBOutlet UILabel *cardNameLab;


@property(nonatomic, copy) MCBankCardCellBlock block;

@end

NS_ASSUME_NONNULL_END
