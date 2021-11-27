//
//  KDPlanCenterViewCell.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDDirectRefundModel.h"

@protocol KDPlanCenterViewCellDelegate <NSObject>

/** 0:默认 1:定制日期 */
- (void)centerCellChoseRefundType:(NSString *)type changeCenterCellHeight:(CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_BEGIN

@interface KDPlanCenterViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, weak) id<KDPlanCenterViewCellDelegate> delegate;
@property (nonatomic, strong) KDDirectRefundModel *directModel;
@end

NS_ASSUME_NONNULL_END
