//
//  MCCashierChooseCell.h
//  MCOEM
//
//  Created by wza on 2020/5/5.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCChooseCardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCCashierChooseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UIButton *tagButton;


+ (instancetype)cellForTableView:(UITableView *)tableview cardInfo:(MCChooseCardModel *)model;



@end

NS_ASSUME_NONNULL_END
