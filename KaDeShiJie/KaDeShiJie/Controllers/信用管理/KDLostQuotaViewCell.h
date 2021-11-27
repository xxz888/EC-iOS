//
//  KDLostQuotaViewCell.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/14.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDCreditExtensionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDLostQuotaViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) KDCreditExtensionModel *model;
@property (weak, nonatomic) IBOutlet UIButton *remedyBtn;
@end

NS_ASSUME_NONNULL_END
