//
//  KDPlanKongKaPreviewCell.h
//  KaDeShiJie
//
//  Created by apple on 2020/12/3.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDPlanKongKaPreviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *pointView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskStatusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLabelWidth;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)setOrderStartDic:(NSDictionary *)startDic;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) NSDictionary * startDic;
@property (nonatomic, assign) NSInteger whereCome;
@end

NS_ASSUME_NONNULL_END
