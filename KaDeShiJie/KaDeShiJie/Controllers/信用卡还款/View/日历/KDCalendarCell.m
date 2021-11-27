//
//  KDCalendarCell.m
//  MCExample
//
//  Created by wza on 2020/9/23.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "KDCalendarCell.h"
#import <OEMSDK/OEMSDK.h>

@interface KDCalendarCell ()



@end

@implementation KDCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:(CGRect)frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}


- (MSSCircleLabel *)cLab {
    if (!_cLab) {
        _cLab = [[MSSCircleLabel alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
        _cLab.font = UIFontBoldMake(17);
        _cLab.minimumScaleFactor = 0.1;
        _cLab.adjustsFontSizeToFitWidth = YES;

    }
    return _cLab;
}

- (void)setupSubviews {
    self.cLab.center = self.contentView.center;
    [self.contentView addSubview:self.cLab];
}


- (void)setModel:(MSSCalendarModel *)model {
    _model = model;
    
    self.cLab.text = [NSString stringWithFormat:@"%zi", model.day];
    self.cLab.type = model.labType;
    
    if (model.labType != normal) {
        self.cLab.textColor = UIColorWhite;
    }
    
    if (model.labType == MSSCircleLabelTypeZhangdan) {
        self.cLab.text = @"账单日";
    }
    if (model.labType == MSSCircleLabelTypeHuankuan) {
        self.cLab.text = @"还款日";
    }
//还款日
//    NSString * repayString =  [NSString stringWithFormat:@"%@-%ld-%ld",
//                              [MCDateStore getUseYear:self.currentMonth],
//                              self.repaymentMonth,
//                              self.repaymentDay];
    //选择的日期
    NSString * clickString = [NSString stringWithFormat:@"%ld-%ld-%ld",model.year,model.month,model.day];
    //如果日期在当前日期和还款日之间，就亮色，否则就灰色
    if ([MCDateStore date:clickString isBetweenDate:[NSDate date] andDate:@"2030-01-01"]) {
        self.cLab.textColor = UIColorMakeWithHex(@"#626262");
    }else{
        self.cLab.textColor = UIColorMakeWithHex(@"#B3B3B3");
    }
    NSInteger data1 = [self getSelectShiJianChuo:[NSString stringWithFormat:@"%ld-%ld-%ld",model.year,model.month,model.day]];
    NSInteger  data2 = [self getCurrentShiJianChuo];
    if (model.day == 27) {
        
    }
    
    if (data1 > data2 ||
        (model.year == [[MCDateStore getYear] integerValue] && model.month == [[MCDateStore getMonth] integerValue] && model.day == [MCDateStore getCurrentDay])) {
        self.cLab.textColor = UIColorMakeWithHex(@"#626262");
    }else{
        self.cLab.textColor = UIColorMakeWithHex(@"#B3B3B3");
    }
     
    
    

    self.cLab.textColor = model.selectItem ? KWhiteColor:self.cLab.textColor;
    
    self.cLab.textColor = model.labType == 2 || model.labType == 3 ? KWhiteColor : self.cLab.textColor;
    
    //这里判断当天是否可以点击
    //结果说明：resp_message为0代表当天不执行计划，为1代表当天开始执行计划
    if (model.day == [MCDateStore getCurrentDay] && self.selectCurrent == 0) {
        self.cLab.textColor = UIColorMakeWithHex(@"#B3B3B3");
    }
}
-(NSInteger )getCurrentShiJianChuo{
    //当前时间转换成秒
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *datenow = [NSDate date];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return [timeSp integerValue];
}
-(NSInteger)getSelectShiJianChuo:(NSString *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate* date = [formatter dateFromString:time]; //------------将字符串按formatter转成nsdate
        return [date timeIntervalSince1970];
}
- (BOOL)isSameDay:(long)iTime1 Time2:(long)iTime2
{
    //传入时间毫秒数
    NSDate *pDate1 = [NSDate dateWithTimeIntervalSince1970:iTime1/1000];
    NSDate *pDate2 = [NSDate dateWithTimeIntervalSince1970:iTime2/1000];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:pDate1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:pDate2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}
@end
