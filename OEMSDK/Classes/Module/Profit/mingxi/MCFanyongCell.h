//
//  MCFanyongCell.h
//  MCOEM
//
//  Created by wza on 2020/5/9.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCFanyongModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCFanyongCell : UITableViewCell

+ (instancetype)cellForTableview:(UITableView *)tableview fanyongInfo:(MCFanyongModel *)model;




@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *remarkLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@end

NS_ASSUME_NONNULL_END
