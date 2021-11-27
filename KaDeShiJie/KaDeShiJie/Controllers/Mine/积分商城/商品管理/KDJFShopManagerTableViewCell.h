//
//  KDJFShopManagerTableViewCell.h
//  KaDeShiJie
//
//  Created by apple on 2021/6/11.
//  Copyright © 2021 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDJFShopManagerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIView *sideView;
@property (weak, nonatomic) IBOutlet UIImageView *sImv;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
