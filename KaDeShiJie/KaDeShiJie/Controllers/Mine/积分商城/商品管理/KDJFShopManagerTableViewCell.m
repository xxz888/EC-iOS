//
//  KDJFShopManagerTableViewCell.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/11.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFShopManagerTableViewCell.h"

@implementation KDJFShopManagerTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"KDJFShopManagerTableViewCell";
    KDJFShopManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDJFShopManagerTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.sideView, 2);
    ViewRadius(self.sImv, 5);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
