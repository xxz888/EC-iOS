//
//  MCServiceCell.m
//  Project
//
//  Created by Li Ping on 2019/7/16.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCServiceCell.h"


@interface MCServiceCell ()



@end

@implementation MCServiceCell

+ (instancetype)cellFromTableView:(UITableView *)tableview {
    static NSString * CELL_ID = @"MCServiceCell";
    MCServiceCell *cell = [tableview dequeueReusableCellWithIdentifier:CELL_ID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:CELL_ID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:CELL_ID];
        cell = [tableview dequeueReusableCellWithIdentifier:CELL_ID];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgView.layer.cornerRadius = 4;
    
}



@end
