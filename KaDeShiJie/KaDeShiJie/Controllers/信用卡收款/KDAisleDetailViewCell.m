//
//  KDAisleDetailViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/12.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDAisleDetailViewCell.h"

@interface KDAisleDetailViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation KDAisleDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AisleDetailView";
    KDAisleDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDAisleDetailViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    return cell;
}

- (void)setModel:(KDAisleDetailModel *)model
{
    _model = model;
    
    self.leftLabel.text = model.supportBankName;
    NSString * str1 = [NSString stringWithFormat:@"%.0f", model.singleMinLimit];
    str1 = [self getDealNumwithstring:str1];
    
    NSString * str2 = [NSString stringWithFormat:@"%.0f", model.singleMaxLimit];
    str2 = [self getDealNumwithstring:str2];
    
//    NSString * str3 = [NSString stringWithFormat:@"%.0f", model.everyDayMaxLimit];
//    str3 = [self getDealNumwithstring:str3];

    self.centerLabel.text = [NSString stringWithFormat:@"%@-%@", str1, str2];
    self.rightLabel.text = [NSString stringWithFormat:@"%.0f", model.everyDayMaxLimit];
}
-(NSString *)getDealNumwithstring:(NSString *)string{
    NSDecimalNumber *numberA = [NSDecimalNumber decimalNumberWithString:string];
    NSDecimalNumber *numberB ;
    NSString *unitStr;
    if (string.length > 4 && string.length <7 ) {
        numberB =  [NSDecimalNumber decimalNumberWithString:@"10000"];
        unitStr = @"万";
    }else if (string.length ==7){
        numberB =  [NSDecimalNumber decimalNumberWithString:@"1000000"];
        unitStr = @"百万";
    }else if(string.length ==8){
        numberB =  [NSDecimalNumber decimalNumberWithString:@"10000000"];
        unitStr = @"千万";
    }
    else if (string.length > 8){
        numberB =  [NSDecimalNumber decimalNumberWithString:@"100000000"];
        unitStr = @"亿";
    }else{
        return string;
    }
    //NSDecimalNumberBehaviors对象的创建  参数 1.RoundingMode 一个取舍枚举值 2.scale 处理范围 3.raiseOnExactness  精确出现异常是否抛出原因 4.raiseOnOverflow  上溢出是否抛出原因  4.raiseOnUnderflow  下溢出是否抛出原因  5.raiseOnDivideByZero  除以0是否抛出原因。
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    /// 这里不仅包含Multiply还有加 减 乘。
    NSDecimalNumber *numResult = [numberA decimalNumberByDividingBy:numberB withBehavior:roundingBehavior];
    NSString *strResult = [NSString stringWithFormat:@"%@%@",[numResult stringValue],unitStr];
    return strResult;
}
@end
