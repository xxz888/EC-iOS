//
//  KDWXViewCell.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/14.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDWXModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDWXViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) KDWXModel *model;
@end

NS_ASSUME_NONNULL_END
