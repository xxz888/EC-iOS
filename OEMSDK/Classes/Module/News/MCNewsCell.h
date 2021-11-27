//
//  MCNewsCell.h
//  MCOEM
//
//  Created by wza on 2020/5/11.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCNewsCell : UITableViewCell

+ (instancetype)cellWithTableview:(UITableView *)tableview newsModel:(MCNewsModel *)model;

@end

NS_ASSUME_NONNULL_END
