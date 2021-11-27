//
//  MCMessageCell.h
//  MCOEM
//
//  Created by wza on 2020/4/30.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCMessageCell : UITableViewCell

+ (instancetype)cellWithTableview:(UITableView *)tableview messageModel:(MCMessageModel *)model;

@end

NS_ASSUME_NONNULL_END
