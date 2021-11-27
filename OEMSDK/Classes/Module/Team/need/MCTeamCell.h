//
//  MCTeamCell.h
//  MCOEM
//
//  Created by wza on 2020/5/11.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCTeamModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCTeamCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableview teamModel:(MCTeamModel *)model;


@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;



@end

NS_ASSUME_NONNULL_END
