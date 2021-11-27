//
//  KDDirectRefundViewCell.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDDirectRefundModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^RefreshUIBlock)(void);
@interface KDDirectRefundViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) KDDirectRefundModel *refundModel;
@property (nonatomic,strong)RefreshUIBlock refreshUIBlock;
@end

NS_ASSUME_NONNULL_END
