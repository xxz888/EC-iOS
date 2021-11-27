//
//  KDNewsViewCell.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/8.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDNewsViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) MCNewsModel *model;
@end

NS_ASSUME_NONNULL_END
