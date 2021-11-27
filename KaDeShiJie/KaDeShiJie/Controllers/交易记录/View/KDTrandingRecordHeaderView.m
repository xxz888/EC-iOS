//
//  KDTrandingRecordView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/23.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDTrandingRecordHeaderView.h"

@interface KDTrandingRecordHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet QMUIButton *yearBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *monthBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *btn1;
@property (weak, nonatomic) IBOutlet QMUIButton *btn2;
@property (weak, nonatomic) IBOutlet QMUIButton *btn3;

@end

@implementation KDTrandingRecordHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDTrandingRecordHeaderView"
                                              owner:nil
                                            options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.topView.layer.cornerRadius = 10;
    self.yearBtn.imagePosition = QMUIButtonImagePositionRight;
    self.monthBtn.imagePosition = QMUIButtonImagePositionRight;
    [self.yearBtn setTitle:[NSString stringWithFormat:@"%@年", [MCDateStore getYear]] forState:UIControlStateNormal];
    [self.monthBtn setTitle:[NSString stringWithFormat:@"%@月", [MCDateStore getMonth]] forState:UIControlStateNormal];
    
    
    self.btn1.selected = YES;
    self.btn1.imagePosition = QMUIButtonImagePositionTop;
    self.btn2.imagePosition = QMUIButtonImagePositionTop;
    self.btn3.imagePosition = QMUIButtonImagePositionTop;
}


- (IBAction)clickTypeBtnAction:(QMUIButton *)sender {
    if (sender.selected) {
        return;
    }
    for (int i = 0; i < 3; i++) {
        QMUIButton *btn = [self.topView viewWithTag:100 + i];
        if (btn.tag != sender.tag) {
            btn.selected = NO;
        } else {
            btn.selected = YES;
        }
    }
    if ([self.delegate respondsToSelector:@selector(headerViewDelegateWithType:)]) {
        [self.delegate headerViewDelegateWithType:sender.tag - 99];
    }
}
#pragma mark - 按钮点击
- (IBAction)clickYearBtn:(QMUIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.yearBtn.imageView.transform = CGAffineTransformRotate(self.yearBtn.transform, M_PI);
    }];
    
    BRDatePickerView *pickView = [[BRDatePickerView alloc] initWithPickerMode:BRDatePickerModeY];
    NSString *year = [MCDateStore getYear];
    pickView.minDate = [NSDate br_setYear:(year.intValue - 3)];
    pickView.maxDate = [NSDate br_setYear:year.intValue];
    pickView.selectDate = [NSDate date];
    [pickView show];
    pickView.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        [UIView animateWithDuration:0.5 animations:^{
            self.yearBtn.imageView.transform = CGAffineTransformIdentity;
        }];
        NSString *yearStr = [NSString stringWithFormat:@"%@年", selectValue];
        [self.yearBtn setTitle:yearStr forState:UIControlStateNormal];
        NSString *month = [self.monthBtn.titleLabel.text substringWithRange:NSMakeRange(0, 2)];
        NSString *time = [NSString stringWithFormat:@"%@%@", selectValue, month];
        if ([self.delegate respondsToSelector:@selector(headerViewDelegateWithTime:)]) {
            [self.delegate headerViewDelegateWithTime:time];
        }
    };
    pickView.cancelBlock = ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.yearBtn.imageView.transform = CGAffineTransformIdentity;
        }];
    };
}
- (IBAction)clickMonthBtn:(QMUIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.monthBtn.imageView.transform = CGAffineTransformRotate(self.monthBtn.transform, M_PI);
    }];
    BRStringPickerView *pickView = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
    pickView.dataSourceArr = @[@"01月", @"02月", @"03月", @"04月", @"05月", @"06月", @"07月", @"08月", @"09月", @"10月", @"11月", @"12月"];
    pickView.selectValue = [NSString stringWithFormat:@"%2@月", [MCDateStore getMonth]];
    [pickView show];
    pickView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
        [UIView animateWithDuration:0.5 animations:^{
            self.monthBtn.imageView.transform = CGAffineTransformIdentity;
        }];
        [self.monthBtn setTitle:resultModel.value forState:UIControlStateNormal];
        NSString *year = [self.yearBtn.titleLabel.text substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [resultModel.value substringWithRange:NSMakeRange(0, 2)];
        NSString *time = [NSString stringWithFormat:@"%@%@", year, month];
        if ([self.delegate respondsToSelector:@selector(headerViewDelegateWithTime:)]) {
            [self.delegate headerViewDelegateWithTime:time];
        }
    };
    pickView.cancelBlock = ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.monthBtn.imageView.transform = CGAffineTransformIdentity;
        }];
    };
}
@end
