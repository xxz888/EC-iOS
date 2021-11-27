//
//  MCTeamCell.m
//  MCOEM
//
//  Created by wza on 2020/5/11.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCTeamCell.h"

@implementation MCTeamCell

+ (instancetype)cellWithTableView:(UITableView *)tableview teamModel:(MCTeamModel *)model {
    static NSString *cellID = @"MCTeamCell";
    MCTeamCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:cellID];
        cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imgView.image = [UIImage mc_imageNamed:[NSString stringWithFormat:@"mcgrade_%d",model.grade.intValue]];
    cell.lab1.text = model.name;
    
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:@"直接推广人" attributes:@{NSFontAttributeName:UIFontMake(14),NSForegroundColorAttributeName:UIColorBlack}];
    NSAttributedString *ztNum = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.GradesonIds] attributes:@{NSFontAttributeName:UIFontBoldMake(14),NSForegroundColorAttributeName:MAINCOLOR}];
    [attr1 insertAttributedString:ztNum atIndex:attr1.length-1];
    cell.lab2.attributedText = attr1;
    
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:@"间接推广人" attributes:@{NSFontAttributeName:UIFontMake(14),NSForegroundColorAttributeName:UIColorBlack}];
    NSAttributedString *ztNum2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.Gradepreuids] attributes:@{NSFontAttributeName:UIFontBoldMake(14),NSForegroundColorAttributeName:MAINCOLOR}];
    [attr2 insertAttributedString:ztNum2 atIndex:attr2.length-1];
    cell.lab3.attributedText = attr2;
    
    
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
