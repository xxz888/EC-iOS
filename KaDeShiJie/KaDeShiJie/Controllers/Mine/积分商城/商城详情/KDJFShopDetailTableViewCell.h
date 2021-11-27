//
//  KDJFShopDetailTableViewCell.h
//  KaDeShiJie
//
//  Created by apple on 2021/6/8.
//  Copyright © 2021 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDJFShopDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *detailImv;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
