//
//  KDTrandingRecordViewCell.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/23.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDRepaymentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDTrandingRecordViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) KDRepaymentModel *repaymentModel;
@end

NS_ASSUME_NONNULL_END
