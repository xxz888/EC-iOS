//
//  KDPlanKongKaPreviewCell.m
//  KaDeShiJie
//
//  Created by apple on 2020/12/3.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDPlanKongKaPreviewCell.h"

@implementation KDPlanKongKaPreviewCell

-  (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"planpreview";
    KDPlanKongKaPreviewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDPlanKongKaPreviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//判断是否为整形：

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
- (void)setOrderStartDic:(NSDictionary *)startDic{
    self.startDic = startDic;
    // 1 下单 2 历史记录 3 信用卡还款进来
    self.timeLabel.text = [startDic[@"executeTime"] length] == 19 ? [startDic[@"executeTime"] substringToIndex:16]:startDic[@"executeTime"];
    NSInteger type = [startDic[@"type"] integerValue];
    //还款前面有一个小蓝点,消费前面没有 type=1 空卡-首笔扣手续费 || type=2 空卡-试消 || type=3 空卡-还款 || type=4 空卡-消费
    self.pointView.hidden    =   type==1||type == 2||type == 4;
    //状态
    self.taskStatusLabel.text = type==1?@"手续费":type==2?@"试消":type==3?@"还款":@"消费";
    //金额的label
    self.moneyLabel.text = doubleToNSString([startDic[@"amount"] doubleValue]);
    self.moneyLabel.text =  type==3 ? [@"+" append:self.moneyLabel.text] : [@"-" append:self.moneyLabel.text];
    if (self.whereCome == 1) {
        //设置计划下单,需要隐藏状态栏一列
        self.statusLabel.text = @"";
        self.statusLabelWidth.constant = 15;
        
    }else if (self.whereCome == 3 || self.whereCome == 2){
        //列表点击进来,需要显示状态栏一列

        //记录和还款点击进来,需要显示状态一列
        self.statusLabel.hidden = NO;
        self.statusLabelWidth.constant = 60;
        //执行状态：1-未执行、2-执行中、3-执行成功、4-执行失败、5-延后执行',
        self.statusLabel.text = [startDic[@"status"] integerValue] == 1 ? @"待执行" :
        [startDic[@"status"] integerValue] == 2 ? @"执行中" :
        [startDic[@"status"] integerValue] == 3 ? @"已成功" :
        [startDic[@"status"] integerValue] == 4 ? @"已失败" :
        [startDic[@"status"] integerValue] == 5 ? @"已延后" : @"";
        
        self.statusLabel.textColor = [UIColor qmui_colorWithHexString:
                                      [startDic[@"status"] integerValue] == 1 ? @"#ffc107" :
                                      [startDic[@"status"] integerValue] == 2 ? @"#ffc107" :
                                      [startDic[@"status"] integerValue] == 3 ? @"#87dc5b" :
                                      [startDic[@"status"] integerValue] == 4 ? @"#ff5722" :
                                      [startDic[@"status"] integerValue] == 5 ? @"#ffc107" : @""];
    }else{
//        //状态
//        self.taskStatusLabel.text = @"";
//
//        //金额的label,消费计划取realAmount,还款计划取amount
//        if ([orderModel.des containsString:@"还款"]) {
//            self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",orderModel.amount];
//            self.pointView.hidden = NO;
//        }else{
//            self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",orderModel.realAmount];
//            self.pointView.hidden = YES;
//        }
//
//
//        //记录和还款点击进来,需要显示状态一列
//        self.statusLabel.text = orderModel.taskStatusName;
//        self.statusLabel.hidden = NO;
//        self.statusLabelWidth.constant = 60;
//        //设置状态颜色
//        if ([orderModel.taskStatusName isEqualToString:@"已成功"]) {
//            self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#53AF23"];
//        } else if ([orderModel.taskStatusName isEqualToString:@"待执行"] || [orderModel.taskStatusName isEqualToString:@"待完成"] ) {
//            self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#F08300"];
//        } else if ([orderModel.taskStatusName isEqualToString:@"已失败"]) {
//            self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#666666"];
//        } else if ([orderModel.taskStatusName isEqualToString:@"还款中"]) {
//            self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#F63802"];
//        }
    }
}

@end
