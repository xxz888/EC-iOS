//
//  MCBankCardCell.h
//  MCOEM
//
//  Created by wza on 2020/4/24.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBankCardModel.h"

NS_ASSUME_NONNULL_BEGIN




typedef enum : NSUInteger {
    MCBankCardCellActionDefault,
    MCBankCardCellActionDelete,
    MCBankCardCellActionModify,
} MCBankCardCellActionType;

typedef void (^MCBankCardCellBlock)(MCBankCardCellActionType type, MCBankCardModel *model);

@interface MCBankCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cenView;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIButton *defBtn;
@property (weak, nonatomic) IBOutlet UILabel *cardNo;
@property (weak, nonatomic) IBOutlet UILabel *cardType;
@property (weak, nonatomic) IBOutlet UILabel *cardDetail;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;



+ (instancetype)cellForTableView:(UITableView *)tableView;



@property(nonatomic, strong) MCBankCardModel *model;

@property(nonatomic, copy) MCBankCardCellBlock block;

@end

NS_ASSUME_NONNULL_END
