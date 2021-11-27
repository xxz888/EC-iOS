//
//  KDPlanPreviewViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/23.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDPlanPreviewViewCell.h"

@interface KDPlanPreviewViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *pointView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskStatusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLabelWidth;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation KDPlanPreviewViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"planpreview";
    KDPlanPreviewViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDPlanPreviewViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
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
- (void)setOrderModel:(KDTotalOrderModel *)orderModel
{
    _orderModel = orderModel;
    // 1 下单 2 历史记录 3 信用卡还款进来


    
    if (self.balancePlanId) {
        if (self.whereCome == 1) {
            //还款前面有一个小蓝点,消费前面没有
            self.pointView.hidden =  orderModel.type == 1;
            //下单返回的数据返回的四个字,消费计划和还款计划四个字,与ui图不一致,要切割
            self.taskStatusLabel.text = orderModel.des;
            //金额的label,消费计划取realAmount,还款计划取amount
            self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", orderModel.amount];
            self.moneyLabel.text = orderModel.type == 1 ? [@"-" append:self.moneyLabel.text] : [@"+" append:self.moneyLabel.text];
            //设置计划下单,需要隐藏状态栏一列
            self.statusLabel.text = @"";
            self.statusLabelWidth.constant = 15;
            self.timeLabel.text = orderModel.executeTime;
        }else{
            //状态
            self.statusLabel.text = [orderModel.status integerValue] == 1 ? @"待执行" :
                                        [orderModel.status integerValue] == 2 ? @"还款中" :
                                        [orderModel.status integerValue] == 3 ? @"已成功" :
                                        [orderModel.status integerValue] == 4 ? @"已失败" :
                                        [orderModel.status integerValue] == 5 ? @"已取消" : @"";

            
            //还款前面有一个小蓝点,消费前面没有
            self.pointView.hidden =  orderModel.type == 1;
            //下单返回的数据返回的四个字,消费计划和还款计划四个字,与ui图不一致,要切割
            self.taskStatusLabel.text = orderModel.des;
            //金额的label,消费计划取realAmount,还款计划取amount
            self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", orderModel.amount];
            self.moneyLabel.text = orderModel.type == 1 ? [@"-" append:self.moneyLabel.text] : [@"+" append:self.moneyLabel.text];
            self.timeLabel.text = orderModel.executeTime;
            //记录和还款点击进来,需要显示状态一列
            self.statusLabel.hidden = NO;
            self.statusLabelWidth.constant = 60;
            //设置状态颜色
            if ([self.statusLabel.text isEqualToString:@"已成功"]) {
                self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#87dc5b"];
            } else if ([self.statusLabel.text isEqualToString:@"待执行"] || [self.statusLabel.text isEqualToString:@"待完成"] ) {
                self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#ffc107"];
            } else if ([self.statusLabel.text isEqualToString:@"已失败"]) {
                self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#ff5722"];
            } else if ([self.statusLabel.text isEqualToString:@"还款中"] || [self.statusLabel.text isEqualToString:@"已取消"]) {
                self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#ffc107"];
            }
        }

    }else{
        self.timeLabel.text = [orderModel.executeDateTime length] == 19 ? [orderModel.executeDateTime substringToIndex:16]:orderModel.executeDateTime;
        if (self.whereCome == 1) {

                //还款前面有一个小蓝点,消费前面没有
                self.pointView.hidden =     [orderModel.des isEqualToString:@"消费计划"];
                //下单返回的数据返回的四个字,消费计划和还款计划四个字,与ui图不一致,要切割
                self.taskStatusLabel.text = [orderModel.des split:@"计划"][0];
                //金额的label,消费计划取realAmount,还款计划取amount
                self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", [orderModel.des isEqualToString:@"消费计划"] ? orderModel.realAmount : orderModel.amount];
                self.moneyLabel.text = [orderModel.des isEqualToString:@"消费计划"] ? [@"-" append:self.moneyLabel.text] : [@"+" append:self.moneyLabel.text];
                //设置计划下单,需要隐藏状态栏一列
                self.statusLabel.text = @"";
                self.statusLabelWidth.constant = 15;

            
            
        }else{
            //状态
            self.taskStatusLabel.text = orderModel.typeName;
            
            //金额的label,消费计划取realAmount,还款计划取amount
            if (orderModel.type == 10) {
                self.pointView.hidden = NO;
                self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f",orderModel.realAmount];
            }else{
                if (orderModel.taskStatus == 1 && orderModel.orderStatus == 1) {
                    self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",orderModel.realAmount];
                }else{
                    self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",orderModel.amount];
                }
                self.pointView.hidden = YES;
            }
            self.pointView.hidden = orderModel.type != 11 ;

            //记录和还款点击进来,需要显示状态一列
            self.statusLabel.text = orderModel.taskStatusName;
            self.statusLabel.hidden = NO;
            self.statusLabelWidth.constant = 60;
            //设置状态颜色
            if ([orderModel.taskStatusName isEqualToString:@"已成功"]) {
                self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#87dc5b"];
            } else if ([orderModel.taskStatusName isEqualToString:@"待执行"] || [orderModel.taskStatusName isEqualToString:@"待完成"] ) {
                self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#ffc107"];
            } else if ([orderModel.taskStatusName isEqualToString:@"已失败"]) {
                self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#ff5722"];
            } else if ([orderModel.taskStatusName isEqualToString:@"还款中"]) {
                self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#ffc107"];
            }
        }

    }
    
    

    

    
}
@end
