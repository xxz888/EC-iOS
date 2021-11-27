//
//  MCArticlesCell.h
//  MCOEM
//
//  Created by wza on 2020/5/12.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCArticleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCArticlesCell : UITableViewCell

+ (instancetype)cellWithTableview:(UITableView *)tableview articleModel:(MCArticleModel *)model;

@end

NS_ASSUME_NONNULL_END
