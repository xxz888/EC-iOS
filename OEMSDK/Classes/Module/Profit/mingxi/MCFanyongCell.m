//
//  MCFanyongCell.m
//  MCOEM
//
//  Created by wza on 2020/5/9.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCFanyongCell.h"

@implementation MCFanyongCell

+ (instancetype)cellForTableview:(UITableView *)tableview fanyongInfo:(MCFanyongModel *)model {
    static NSString *cellID = @"MCFanyongCell";
    MCFanyongCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:cellID];
        cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    }
    cell.imgView.image = SharedAppInfo.icon;
    if (model.oriphone.length > 7) {
        NSMutableAttributedString* attr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"来自尾号%@的收益",[model.oriphone substringFromIndex:7]]];
        [attr setAttributes:@{NSForegroundColorAttributeName:UIColorGrayDarken} range:NSMakeRange(0, 11)];
        [attr setAttributes:@{NSForegroundColorAttributeName:MAINCOLOR} range:NSMakeRange(4, 4)];
        cell.remarkLab.attributedText = attr;
    }
    cell.timeLab.text = model.createTime;
    cell.moneyLab.text = [NSString stringWithFormat:@"+%.2f",[model.acqAmount floatValue]];
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgView.layer.cornerRadius = self.imgView.height/2;
    self.moneyLab.textColor = MAINCOLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
