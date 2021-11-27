//
//  ZAPayTypeViewCell.h
//  Project
//
//  Created by SS001 on 2019/7/16.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZAChannelModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZAPayTypeViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) ZAChannelModel *channelModel;
@end

NS_ASSUME_NONNULL_END
