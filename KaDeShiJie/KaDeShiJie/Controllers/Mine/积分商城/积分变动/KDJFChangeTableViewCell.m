//
//  KDJFChangeTableViewCell.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/11.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFChangeTableViewCell.h"

@implementation KDJFChangeTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"KDJFChangeTableViewCell";
    KDJFChangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDJFChangeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
