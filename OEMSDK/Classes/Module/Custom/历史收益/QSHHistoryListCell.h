//
//  QSHHistoryListCell.h
//  Project
//
//  Created by Li Ping on 2019/8/6.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSHHistoryListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *earnLab;

+ (instancetype)cellFromTableView:(UITableView *)table;

@end

NS_ASSUME_NONNULL_END
