//
//  MCDefaultChannelAlert.m
//  MCOEM
//
//  Created by wza on 2020/5/5.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCDefaultChannelAlert.h"
#import "STModal.h"
#import "MCDefaultChannelView.h"
        
@interface MCDefaultChannelAlert () <MCDefaultChannelViewDelegate>

@property(nonatomic, strong) STModal *modal;



@property(nonatomic, copy) channelActionBlock sure;
@property(nonatomic, copy) channelActionBlock change;

@property(nonatomic, strong) MCChannelModel *channelInfo;
@property(nonatomic, strong) MCDefaultChannelView *view;

@end

@implementation MCDefaultChannelAlert
- (MCDefaultChannelView *)view {
    if (!_view) {
        _view = [MCDefaultChannelView newFromNib];
        _view.frame = CGRectMake(0, 0, SCREEN_WIDTH-20, 250);
        _view.layer.cornerRadius = 5;
        _view.delegate = self;
    }
    return _view;
}
- (STModal *)modal {
    if (!_modal) {
        _modal = [STModal modal];
        _modal.positionMode = STModelPositionCenter;
        _modal.hideWhenTouchOutside = YES;
    }
    return _modal;
}


- (void)showWithChannelInfo:(MCChannelModel *)model amount:(NSString *)amount changeHandler:(channelActionBlock)change sureHandler:(channelActionBlock)sure {
    
    self.sure = sure;
    self.change = change;
    self.channelInfo = model;
    
    
    self.view.lab2.textColor = MAINCOLOR;
    [self.view.sureButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    
    self.view.lab1.text = [NSString stringWithFormat:@"%@%@",model.name,model.channelParams];
    self.view.lab2.text = @"提示：2小时内到账（不限日期，快速到账）";
    

    NSString *singleMinLimit = model.singleMinLimit;
    NSString *singleMaxLimit = model.singleMaxLimit;
    int singleMin = 0;
    int singleMax = 0;
    if ([singleMinLimit intValue] >= 10000) {
        singleMin = [singleMinLimit intValue] / 10000;
        singleMinLimit = [NSString stringWithFormat:@"%d万元", singleMin];
    }
    if ([singleMaxLimit intValue] >= 10000) {
        singleMax = [singleMaxLimit intValue] / 10000;
        singleMaxLimit = [NSString stringWithFormat:@"%d万元", singleMax];
    }
    NSString *singMaxStr = [NSString stringWithFormat:@"单笔限额(元):%@-%@", singleMinLimit, singleMaxLimit];
    self.view.lab11.attributedText = [self subStringAtt:singMaxStr rangeStr:[NSString stringWithFormat:@"%@-%@",  singleMinLimit, singleMaxLimit]];
    
    
    
    
    int everyDayMax = 0;
    NSString *everyDayMaxLimit = model.everyDayMaxLimit;
    if ([everyDayMaxLimit intValue] >= 10000) {
        everyDayMax = [everyDayMaxLimit intValue] / 10000;
        everyDayMaxLimit = [NSString stringWithFormat:@"%d万元", everyDayMax];
    }
    NSString *everyStr = [NSString stringWithFormat:@"单日限额:(元):%@", everyDayMaxLimit];
    self.view.lab12.attributedText = [self subStringAtt:everyStr rangeStr:[NSString stringWithFormat:@"%@", everyDayMaxLimit]];
    
    

    
    NSString *jiaoYiDateStr = [NSString stringWithFormat:@"交易时间:%@-%@", model.startTime, model.endTime];
    self.view.lab21.attributedText = [self subStringAtt:jiaoYiDateStr rangeStr:[NSString stringWithFormat:@"%@-%@", model.startTime, model.endTime]];
    
    NSString *rateStr = [NSString stringWithFormat:@"交易费率:%.2f%%+%.2f元", model.rate.floatValue * 100, model.extraFee.floatValue];
    self.view.lab22.attributedText = [self subStringAtt:rateStr rangeStr:[NSString stringWithFormat:@"%.2f元", model.extraFee.floatValue]];
    
    NSString *serviceCharge = [NSString stringWithFormat:@"%.2f元", [amount floatValue] * model.rate.floatValue];
    self.view.lab31.text = [NSString stringWithFormat:@"手续费用：%@", serviceCharge];
    
    NSString *realAmount = [NSString stringWithFormat:@"%.2f元", [amount floatValue] - [amount floatValue] * model.rate.floatValue  - model.extraFee.floatValue];
    self.view.lab32.text = [NSString stringWithFormat:@"实际到账：%@", realAmount];
    
    [self.modal showContentView:self.view animated:YES];
}

- (NSMutableAttributedString *)subStringAtt:(NSString *)str rangeStr:(NSString *)rangeStr
{
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:str];
    [mutableStr addAttributes:@{NSForegroundColorAttributeName:MAINCOLOR} range:[str rangeOfString:rangeStr]];
    return mutableStr;
}
#pragma mark - MCDefaultChannelViewDelegate

- (void)channelViewClickOn:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"更换通道"]) {
        [self.modal hide:NO];
        self.change(self.channelInfo);
    } else if ([sender.currentTitle isEqualToString:@"确认收款"]) {
        [self.modal hide:YES];
        self.sure(self.channelInfo);
    } else {
        [self.modal hide:YES];
    }
    
}

@end
