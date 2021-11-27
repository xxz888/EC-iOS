//
//  ZAOrderViewCell.h
//  Project
//
//  Created by SS001 on 2019/7/16.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZAShopsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZAOrderViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) ZAShopsModel *shopModel;

@end

NS_ASSUME_NONNULL_END
