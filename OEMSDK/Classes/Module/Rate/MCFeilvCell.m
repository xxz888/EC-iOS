//
//  MCFeilvCell.m
//  MCOEM
//
//  Created by wza on 2020/4/22.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCFeilvCell.h"

@implementation MCFeilvCell

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"MCFeilvCell";
    MCFeilvCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:cellID];
        cell = [tableview dequeueReusableCellWithIdentifier:cellID];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.channelName.font = UIFontMake(14);
    
}



@end
