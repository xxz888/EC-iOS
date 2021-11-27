//
//  MCMessageCell_logo.h
//  AFNetworking
//
//  Created by wza on 2020/7/30.
//

#import <UIKit/UIKit.h>
#import "MCMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCMessageCell_logo : UITableViewCell

+ (instancetype)cellWithTableview:(UITableView *)tableview messageModel:(MCMessageModel *)model;

@end

NS_ASSUME_NONNULL_END
