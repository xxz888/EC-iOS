//
//  MCMessageCell.m
//  MCOEM
//
//  Created by wza on 2020/4/30.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCMessageCell.h"

@interface MCMessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation MCMessageCell

+ (instancetype)cellWithTableview:(UITableView *)tableview messageModel:(MCMessageModel *)model {
    static NSString *cellID = @"MCMessageCell";
    MCMessageCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:cellID];
        cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    }
    cell.lab1.text = model.title;
    cell.lab2.text = model.content;
    cell.lab3.text = model.createTime;
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.lab2.text];
    NSRange range1 = [[str string] rangeOfString:@"在线客服"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor qmui_colorWithHexString:@"#0066FF"] range:range1];
    cell.lab2.attributedText = str;
    

    return cell;
}
- (void)clickKFAction
{
    if ([self.lab2.text containsString:@"在线客服"]) {
        [MCServiceStore pushMeiqiaVC];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgView.layer.cornerRadius = 4;
    // 1. 创建一个点击事件，点击时触发labelClick方法
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickKFAction)];
    // 2. 将点击事件添加到label上
    [self.lab2 addGestureRecognizer:labelTapGestureRecognizer];
    // 可以理解为设置label可被点击
    self.lab2.userInteractionEnabled = YES;
}



@end
