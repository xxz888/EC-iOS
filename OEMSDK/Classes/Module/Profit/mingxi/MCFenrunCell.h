//
//  MCFenrunCell.h
//  MCOEM
//
//  Created by wza on 2020/5/9.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCFenrunModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCFenrunCell : UITableViewCell

+ (instancetype)cellForTableview:(UITableView *)tableview fenrunInfo:(MCFenrunModel *)model;




@property (weak, nonatomic) IBOutlet UILabel *monthZHLab;
@property (weak, nonatomic) IBOutlet UILabel *monthLab;
@property (weak, nonatomic) IBOutlet QMUILabel *phoneTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;




@end

NS_ASSUME_NONNULL_END
