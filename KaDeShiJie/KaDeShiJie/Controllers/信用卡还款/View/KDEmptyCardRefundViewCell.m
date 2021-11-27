//
//  KDEmptyCardRefundViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDEmptyCardRefundViewCell.h"
#import "KDDirectPushChoseStatusView.h"
#import "KDPlanAlertView.h"

@interface KDEmptyCardRefundViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *markView;

// 每日还款次数
@property (weak, nonatomic) IBOutlet QMUIButton *refundCountBtn;

// 实际还款金额将略大于账单金额
@property (weak, nonatomic) IBOutlet UILabel *moneyDetailLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyTypeTopCons;
// 地址按钮
@property (weak, nonatomic) IBOutlet QMUIButton *addressBtn;
// 指定计划
@property (weak, nonatomic) IBOutlet KDFillButton *planBtn;
// 选择地址view
@property (nonatomic, strong) BRAddressPickerView *addressPicker;
@end

@implementation KDEmptyCardRefundViewCell

- (BRAddressPickerView *)addressPicker {
    if (!_addressPicker) {
        _addressPicker = [[BRAddressPickerView alloc] initWithPickerMode:BRAddressPickerModeCity];
        _addressPicker.title = @"请选择开户省市";
        _addressPicker.selectValues = @[@"上海市", @"上海市"];
        __weak __typeof(self)weakSelf = self;
        _addressPicker.resultBlock = ^(BRProvinceModel * _Nullable province, BRCityModel * _Nullable city, BRAreaModel * _Nullable area) {
            NSString *address = [NSString stringWithFormat:@"%@-%@",province.name,city.name];
            [weakSelf.addressBtn setTitle:address forState:UIControlStateNormal];
        };
    }
    return _addressPicker;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 10;
    self.markView.layer.cornerRadius = 3;
    self.refundCountBtn.imagePosition = QMUIButtonImagePositionRight;
    self.moneyTypeTopCons.constant = 14;
    self.planBtn.layer.cornerRadius = 24.5;
    self.addressBtn.imagePosition = QMUIButtonImagePositionRight;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"emptycardrefundcell";
    KDEmptyCardRefundViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDEmptyCardRefundViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 还款消费是否取消小数点
- (IBAction)choseMoneyTypeView:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (!sender.selected) {
        self.moneyDetailLabel.hidden = YES;
        self.moneyTypeTopCons.constant = 14;
    } else {
        self.moneyDetailLabel.hidden = NO;
        self.moneyTypeTopCons.constant = 33.5;
    }
}
#pragma mark - 选择地址
- (IBAction)clickAddressBtn:(QMUIButton *)sender {
    [self.addressPicker show];
}
#pragma mark - 选择还款次数
- (IBAction)clickRefundCountBtn:(QMUIButton *)sender {
    QMUIModalPresentationViewController *diaVC = [[QMUIModalPresentationViewController alloc] init];
    KDDirectPushChoseStatusView *typeView = [[KDDirectPushChoseStatusView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    diaVC.contentView = typeView;
    typeView.titleArray = @[@"1次", @"2次", @"3次", @"4次"];
    diaVC.contentViewMargins = UIEdgeInsetsZero;
    [diaVC showWithAnimated:YES completion:nil];
    typeView.choseStatus = ^(NSString * _Nonnull status) {
        [diaVC hideWithAnimated:YES completion:nil];
        [self.refundCountBtn setTitle:status forState:UIControlStateNormal];
        if ([status isEqualToString:@"取消"]) {
            [diaVC hideWithAnimated:YES completion:nil];
        }
    };
}
- (IBAction)clickPlanBtn:(KDFillButton *)sender {
    KDPlanAlertView *plan = [[KDPlanAlertView alloc] initWithFrame:CGRectMake(0, 0, 210, 270)];
    [plan showView];
}
@end
