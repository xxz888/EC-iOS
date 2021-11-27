//
//  KDDelegateViewCell.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDTopDelegateNewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDDelegateViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) KDTopDelegateNewModel *model;
@end

NS_ASSUME_NONNULL_END
