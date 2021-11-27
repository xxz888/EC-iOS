//
//  KDDirectPushViewCell.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDPushModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDDirectPushViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableVie;
@property (nonatomic, strong) KDPushModel *pushModel;
@property (weak, nonatomic) IBOutlet UILabel *phoneView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneViewRight;

@property(nonatomic, copy) NSString *status;
@end

NS_ASSUME_NONNULL_END
