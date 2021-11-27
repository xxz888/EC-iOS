//
//  KDJFOrderTableViewCellTableViewCell.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/10.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFOrderTableViewCellTableViewCell.h"

@implementation KDJFOrderTableViewCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.orderSide, 2);
    ViewRadius(self.orderImv, 5);
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"KDJFOrderTableViewCellTableViewCell";
    KDJFOrderTableViewCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDJFOrderTableViewCellTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
