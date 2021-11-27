//
//  QSHHistoryListCell.m
//  Project
//
//  Created by Li Ping on 2019/8/6.
//  Copyright © 2019 LY. All rights reserved.
//

#import "QSHHistoryListCell.h"

@implementation QSHHistoryListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellFromTableView:(UITableView *)table {
    static NSString *CELL_ID = @"QSHHistoryListCell";
    QSHHistoryListCell *cell = [table dequeueReusableCellWithIdentifier:CELL_ID];
    if (!cell) {
        [table registerNib:[UINib nibWithNibName:CELL_ID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:CELL_ID];
        cell = [table dequeueReusableCellWithIdentifier:CELL_ID];
    }
    return cell;
}

@end
