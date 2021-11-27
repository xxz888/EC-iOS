//
//  SingleBankCell.m
//  Project
//
//  Created by liuYuanFu on 2019/6/5.
//  Copyright © 2019 LY. All rights reserved.
//

#import "SingleBankCell.h"

#define STR(string) [NSString stringWithFormat:@"%@", string]

@implementation SingleBankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backView.layer.cornerRadius = 5.0;
//    self.backView.layer.borderWidth = 1;
    self.backView.layer.shadowColor = [UIColor colorWithRed:240/255 green:240/255 blue:240/255 alpha:0.5].CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(3,3);
    self.backView.layer.shadowRadius = 4;
    self.backView.layer.shadowOpacity = 0.3f;
      
}

/* set写数组;当招商"例如"不存在数据时 隐藏"例如" */
-(void)setCellArrZ:(NSArray *)cellArrZ{
    _cellArrZ = cellArrZ;
    if (_cellArrZ.count == 3) {
        self.liRuLb.hidden = NO;
        self.liRuLb.text         =  cellArrZ[2];
    }else{
        self.liRuLb.hidden = YES;
    }
    
    // 查询账单
    self.checkAccountLb.text = cellArrZ[0];

    /* 发送到----*/
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"发送%@到%@",cellArrZ[1][0],cellArrZ[1][1]]];
    [string addAttribute:NSForegroundColorAttributeName value:UIColor.mainColor range:NSMakeRange(2,STR(cellArrZ[1][0]).length)];
//    [string addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"Helvetica-Bold" size: 14]
//                            range: NSMakeRange(3+STR(cellArrZ[1][0]).length,STR(cellArrZ[1][1]).length)];
    self.contentLb.attributedText = string;
    /* 例如 */
    if (![cellArrZ[2] isEqualToString:@""]) {
        NSMutableAttributedString* string2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"例如%@",cellArrZ[2]]];
        [string2 addAttribute:NSForegroundColorAttributeName value:UIColor.mainColor range:NSMakeRange(2, STR(cellArrZ[2]).length)];
        self.liRuLb.attributedText = string2;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
