//
//  KDProfitDirectPushViewCell.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDProfitDirectPushModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDProfitDirectPushViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property(nonatomic, strong) KDProfitDirectPushModel *tuiguangModel;
@property(nonatomic, strong) KDProfitDirectPushModel *fanyongModel;
@property(nonatomic, strong) KDProfitDirectPushModel *dabiaoModel;

@end

NS_ASSUME_NONNULL_END
