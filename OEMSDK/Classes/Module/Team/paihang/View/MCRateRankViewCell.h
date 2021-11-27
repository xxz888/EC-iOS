//
//  MCRateRankViewCell.h
//  Pods
//
//  Created by SS001 on 2020/7/22.
//

#import <UIKit/UIKit.h>
#import "MCIncomeRateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCRateRankViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) MCIncomeRateModel *model;
@end

NS_ASSUME_NONNULL_END
