//
//  MCChooseChannelCell.h
//  Project
//
//  Created by Li Ping on 2019/7/15.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCChannelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCChooseChannelCell : UITableViewCell



+ (instancetype)cellFromTableView:(UITableView *)tableview channelInfo:(MCChannelModel *)model amount:(NSString *)amount;



@end

NS_ASSUME_NONNULL_END
