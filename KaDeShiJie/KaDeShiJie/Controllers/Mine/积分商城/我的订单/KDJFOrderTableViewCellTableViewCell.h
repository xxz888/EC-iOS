//
//  KDJFOrderTableViewCellTableViewCell.h
//  KaDeShiJie
//
//  Created by apple on 2021/6/10.
//  Copyright © 2021 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDJFOrderTableViewCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderTitle;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *orderContent;
@property (weak, nonatomic) IBOutlet UIImageView *orderImv;
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;
@property (weak, nonatomic) IBOutlet UIView *orderSide;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
