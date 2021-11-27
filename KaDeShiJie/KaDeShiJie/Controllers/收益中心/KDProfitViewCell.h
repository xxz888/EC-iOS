//
//  KDProfitViewCell.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDProfitViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rightView;
@property (weak, nonatomic) IBOutlet UILabel *centerView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
