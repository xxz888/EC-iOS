//
//  KDAisleDetailViewCell.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/12.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDAisleDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDAisleDetailViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) KDAisleDetailModel *model;
@end

NS_ASSUME_NONNULL_END
