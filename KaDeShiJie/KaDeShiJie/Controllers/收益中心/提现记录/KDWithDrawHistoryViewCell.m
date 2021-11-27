//
//  KDWithDrawHistoryViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDWithDrawHistoryViewCell.h"

@interface KDWithDrawHistoryViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeView;
@property (weak, nonatomic) IBOutlet UILabel *tradeAmountView;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end

@implementation KDWithDrawHistoryViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"withdrawHistory";
    KDWithDrawHistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDWithDrawHistoryViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModel:(KDProfitDirectPushModel *)model
{
    _model = model;
    //0  待完成   1已成功    2已取消   3待处理  4待结算
    self.timeView.text = model.tradeTime;
    self.tradeAmountView.text = [NSString stringWithFormat:@"%.2f", model.tradeAmount];
//    self.statusLbl.text = [model.status isEqualToString:@"0"] ? @"待完成" :
//    [model.status isEqualToString:@"1"] ? @"已成功" :
//    [model.status isEqualToString:@"2"] ? @"已取消" :
//    [model.status isEqualToString:@"3"] ? @"待处理" :
//    [model.status isEqualToString:@"4"] ? @"待结算" : @"";
//
//
//    if ([self.statusLbl.text isEqualToString:@"已成功"]) {
//        self.statusLbl.textColor = [UIColor qmui_colorWithHexString:@"#53AF23"];
//    }else if ([self.statusLbl.text isEqualToString:@"已取消"]){
//        self.statusLbl.textColor = [UIColor qmui_colorWithHexString:@"#ff5722"];
//    }else{
//        self.statusLbl.textColor = [UIColor qmui_colorWithHexString:@"#ffc107"];
//    }
}
@end
