//
//  MCShareOverViewCell.m
//  Pods
//
//  Created by wza on 2020/8/19.
//

#import "MCShareOverViewCell.h"

@implementation MCShareOverViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)cellFromTableView:(QMUITableView *)tableview image:(UIImage *)img {
    static NSString *cellID = @"MCShareOverViewCell";
    MCShareOverViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:cellID];
        cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    }
    cell.imgView.image = img;
    return cell;
}

@end
