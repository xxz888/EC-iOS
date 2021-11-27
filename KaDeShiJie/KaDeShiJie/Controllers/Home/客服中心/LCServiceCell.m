//
//  LCServiceCell.m
//  Lianchuang_477
//
//  Created by wza on 2020/8/19.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "LCServiceCell.h"

@implementation LCServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)cellFromTableview:(UITableView *)tableview data:(NSDictionary *)dic {
    static NSString *cellID = @"LCServiceCell";
    LCServiceCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    }
    
    cell.imgView.image = [dic objectForKey:@"img"];
    cell.titLab.text = [dic objectForKey:@"title"];
    
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 65);
}
@end
