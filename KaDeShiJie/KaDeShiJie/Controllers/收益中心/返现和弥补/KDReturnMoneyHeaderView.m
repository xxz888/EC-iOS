//
//  KDReturnMoneyHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDReturnMoneyHeaderView.h"

@interface KDReturnMoneyHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *topView;


@end

@implementation KDReturnMoneyHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.yearBtn.imagePosition = QMUIButtonImagePositionRight;
    self.monthBtn.imagePosition = QMUIButtonImagePositionRight;
    [self.yearBtn setTitle:[NSString stringWithFormat:@"%@年", [MCDateStore getYear]] forState:UIControlStateNormal];
    [self.monthBtn setTitle:[NSString stringWithFormat:@"%@月", [MCDateStore getMonth]] forState:UIControlStateNormal];
    
    self.topView.layer.cornerRadius = 10;
    self.topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    self.topView.layer.shadowOffset = CGSizeMake(0,1.5);
    self.topView.layer.shadowOpacity = 1;
    self.topView.layer.shadowRadius = 10;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDReturnMoneyHeaderView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
}
#pragma mark - 按钮点击
- (IBAction)clickYearBtn:(QMUIButton *)sender {
    BRDatePickerView *pickView = [[BRDatePickerView alloc] initWithPickerMode:BRDatePickerModeY];
    NSString *year = [MCDateStore getYear];
    pickView.minDate = [NSDate br_setYear:(year.intValue - 3)];
    pickView.maxDate = [NSDate br_setYear:year.intValue];
    pickView.selectDate = [NSDate date];
    [pickView show];
    pickView.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        [self.yearBtn setTitle:selectValue forState:UIControlStateNormal];
        NSString *year = [selectValue substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [self.monthBtn.titleLabel.text substringWithRange:NSMakeRange(0, 2)];
        NSString *time = [NSString stringWithFormat:@"%@%@", year, month];
        if ([self.delegate respondsToSelector:@selector(returnMoneyHeaderViewGetTime:)]) {
            [self.delegate returnMoneyHeaderViewGetTime:time];
        }
    };
}
- (IBAction)clickMonthBtn:(QMUIButton *)sender {
    BRStringPickerView *pickView = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
    pickView.dataSourceArr = @[@"01月", @"02月", @"03月", @"04月", @"05月", @"06月", @"07月", @"08月", @"09月", @"10月", @"11月", @"12月"];
    pickView.selectValue = [NSString stringWithFormat:@"%2@月", [MCDateStore getMonth]];
    [pickView show];
    pickView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
        [self.monthBtn setTitle:resultModel.value forState:UIControlStateNormal];
        NSString *year = [self.yearBtn.titleLabel.text substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [resultModel.value substringWithRange:NSMakeRange(0, 2)];
        NSString *time = [NSString stringWithFormat:@"%@%@", year, month];
        if ([self.delegate respondsToSelector:@selector(returnMoneyHeaderViewGetTime:)]) {
            [self.delegate returnMoneyHeaderViewGetTime:time];
        }
    };
}
@end
