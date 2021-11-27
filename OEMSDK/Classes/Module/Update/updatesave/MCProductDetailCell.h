//
//  MCProductDetailCell.h
//  MCOEM
//
//  Created by wza on 2020/5/13.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCFeilvModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCProductDetailCell : UITableViewCell

+ (instancetype)cellWithTableview:(UITableView *)tableview channelModel:(MCFeilvModel *)model;

@end

NS_ASSUME_NONNULL_END
