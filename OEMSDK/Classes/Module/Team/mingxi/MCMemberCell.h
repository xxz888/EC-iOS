//
//  MCMemberCell.h
//  MCOEM
//
//  Created by wza on 2020/5/11.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCMemberModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCMemberCell : UITableViewCell

+ (instancetype)cellWithTableview:(UITableView *)tableview memberModel:(MCMemberModel *)model;

@end

NS_ASSUME_NONNULL_END
