//
//  LXUpgradeCell.h
//  Project
//
//  Created by Li Ping on 2019/7/26.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCProductModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXUpgradeCell : UITableViewCell

@property (nonatomic, strong) MCProductModel *model;

@property(nonatomic, strong) NSArray *cellImageArr;

+ (instancetype)cellFromTableView:(UITableView *)tableview;

@end

NS_ASSUME_NONNULL_END
