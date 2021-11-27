//
//  KDProfitDirectPushViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDProfitDirectPushViewCell.h"

@interface KDProfitDirectPushViewCell ()
@property (weak, nonatomic) IBOutlet QMUIMarqueeLabel *timeView;
@property (weak, nonatomic) IBOutlet UILabel *tradeAmountView;
@property (weak, nonatomic) IBOutlet UILabel *rabateView;

@end

@implementation KDProfitDirectPushViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"profitdirectpush";
    KDProfitDirectPushViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDProfitDirectPushViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (void)setModel:(KDProfitDirectPushModel *)model
//{
//    _model = model;
//
//    self.rabateView.text = [NSString stringWithFormat:@"%.2f", model.rebate];
//
////    if (model.userName) {
////        self.tradeAmountView.text = model.userName;
////    } else {
////        self.tradeAmountView.text = [NSString stringWithFormat:@"%.2f", model.tradeAmount];
////    }
//
//    self.tradeAmountView.text = model.userName ?: @"";
//    self.rabateView.text = [NSString stringWithFormat:@"%.2f", model.tradeAmount];
//
//    NSString *time = [model.tradeTime substringFromIndex:5];
//    time = [time qmui_stringByReplacingPattern:@"-" withString:@"/"];
//    if (model.des.length != 0) {
//        self.timeView.text = model.des;
//    } else {
//        self.timeView.text = time;
//    }
//}
- (void)setTuiguangModel:(KDProfitDirectPushModel *)tuiguangModel {
    _tuiguangModel = tuiguangModel;
    
    self.timeView.text = tuiguangModel.tradeTime;
    self.nameView.text = tuiguangModel.userName ?:@"";
    self.tradeAmountView.text = [NSString stringWithFormat:@"%.2f", tuiguangModel.tradeAmount];
    self.rabateView.text = [NSString stringWithFormat:@"%.2f", tuiguangModel.rebate];
}
- (void)setFanyongModel:(KDProfitDirectPushModel *)fanyongModel {
    _fanyongModel = fanyongModel;
    self.timeView.text = fanyongModel.des;
    self.nameView.text = fanyongModel.userName ?:@"";
    self.tradeAmountView.text = [NSString stringWithFormat:@"%.2f", fanyongModel.tradeAmount];
    self.rabateView.text = [NSString stringWithFormat:@"%.2f", fanyongModel.rebate];
}

- (void)setDabiaoModel:(KDProfitDirectPushModel *)dabiaoModel {
    _dabiaoModel = dabiaoModel;
    self.tradeAmountView.text = dabiaoModel.userName ?: @"";
    self.rabateView.text = [NSString stringWithFormat:@"%.2f", dabiaoModel.tradeAmount];
//    NSString *time = [dabiaoModel.tradeTime substringFromIndex:5];
//    time = [time qmui_stringByReplacingPattern:@"-" withString:@"/"];
    self.timeView.text = dabiaoModel.tradeTime;
}



@end
