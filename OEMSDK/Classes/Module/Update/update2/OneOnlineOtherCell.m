//
//  OneOnlineOtherCell.m
//  JFB
//
//  Created by Shao Wei Su on 2017/7/31.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "OneOnlineOtherCell.h"
#import "FormValidator.h"
#define STR(string) [NSString stringWithFormat:@"%@", string]

@interface OneOnlineOtherCell ()

@property (nonatomic, strong) UILabel *moneyLabel;

@property(nonatomic, strong) UIButton *daifuButton;

@end

@implementation OneOnlineOtherCell

+ (instancetype)cellFromTableView:(UITableView *)tableview {
    static NSString *CELL_ID = @"OneOnlineOtherCell";
    OneOnlineOtherCell *cell = [tableview dequeueReusableCellWithIdentifier:CELL_ID];
    if (!cell) {
        cell  = [[OneOnlineOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
    }
    return cell;
}

- (UIButton *)daifuButton {
    if (!_daifuButton) {
        _daifuButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_daifuButton setTitle:@"代人购买" forState:UIControlStateNormal];
        [_daifuButton addTarget:self action:@selector(onDaifuTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.daifuButton];
        self.daifuButton.hidden = !SharedConfig.is_dairen_buy;
    }
    return _daifuButton;
}
- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor orangeColor];
        [self addSubview:self.moneyLabel];
    }
    return _moneyLabel;
}


- (UIImageView *)proImageV {
    
    if (!_proImageV) {
        
        self.proImageV = [[UIImageView alloc] init];
        [self addSubview:self.proImageV];
    }
    return _proImageV;
}
- (UILabel *)proNameLabel {
    
    if (!_proNameLabel) {
        
        self.proNameLabel = [[UILabel alloc] init];
        self.proNameLabel.textColor = [UIColor darkGrayColor];
        self.proNameLabel.textAlignment = NSTextAlignmentLeft;
        self.proNameLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.proNameLabel];
    }
    return _proNameLabel;
}
- (UILabel *)infoOneLabel {
    
    if (!_infoOneLabel) {
        
        self.infoOneLabel = [[UILabel alloc] init];
        self.infoOneLabel.textColor = [UIColor darkGrayColor];
        self.infoOneLabel.textAlignment = NSTextAlignmentLeft;
        self.infoOneLabel.font = [UIFont systemFontOfSize:14];
        self.infoOneLabel.numberOfLines = 0;
        [self addSubview:self.infoOneLabel];
    }
    return _infoOneLabel;
}
- (UILabel *)infoTwoLabel {
    
    if (!_infoTwoLabel) {
        
        self.infoTwoLabel = [[UILabel alloc] init];
        self.infoTwoLabel.textColor = [UIColor darkGrayColor];
        self.infoTwoLabel.textAlignment = NSTextAlignmentLeft;
        self.infoTwoLabel.font = [UIFont systemFontOfSize:14];
        self.infoTwoLabel.numberOfLines = 0;
        [self addSubview:self.infoTwoLabel];
    }
    return _infoTwoLabel;
}
- (UILabel *)isBuyLabel {
    if (!_isBuyLabel) {
        self.isBuyLabel = [[UILabel alloc] init];
        self.isBuyLabel.textColor = [UIColor whiteColor];
        self.isBuyLabel.font = [UIFont systemFontOfSize:14];
        self.isBuyLabel.textAlignment = NSTextAlignmentCenter;
        self.isBuyLabel.layer.cornerRadius = 6;
        self.isBuyLabel.layer.masksToBounds = YES;
        [self addSubview:self.isBuyLabel];
    }
    return _isBuyLabel;
}

- (UIImageView *)littleImvOne
{
    if (!_littleImvOne) {
        _littleImvOne = [[UIImageView alloc] init];
        _littleImvOne.image = [UIImage mc_imageNamed:@"img_all_upgrade"];
    }
    return _littleImvOne;
}
- (UIImageView *)littleImvTwo
{
    if (!_littleImvTwo) {
        _littleImvTwo = [[UIImageView alloc] init];
        _littleImvTwo.image = [UIImage mc_imageNamed:@"img_all_income"];
    }
    return _littleImvTwo;
}


// 赋值
- (void)setProModel:(MCProductModel *)proModel {
    _proModel = proModel;
    // 图片
    NSString *grade = STR(proModel.grade);
    self.proImageV.image = [UIImage mc_imageNamed:[NSString stringWithFormat:@"mcgrade_%@",grade]];
    
    // 名称
    if ([proModel.trueFalseBuy isEqualToString:@"0"] || [proModel.trueFalseBuy isEqualToString:@"1"]) {
        NSString *tempOne = [NSString stringWithFormat:@"¥%@", STR(proModel.money)];
        NSMutableAttributedString *attris = [[NSMutableAttributedString alloc] initWithString:tempOne];
        [attris addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[tempOne rangeOfString:@"¥"]];
        self.moneyLabel.attributedText = attris;
    } else if ([proModel.trueFalseBuy isEqualToString:@"2"]) {
        self.moneyLabel.text = MCBrandConfiguration.sharedInstance.brand_name;
    } else if ([proModel.trueFalseBuy isEqualToString:@"3"]) {
        self.moneyLabel.text = @"需联系客服";
    }
    
    self.proNameLabel.text = proModel.name;
    // 说明一
    self.infoOneLabel.text = STR(proModel.earningsState);
    // 说明二
    self.infoTwoLabel.text = STR(proModel.upgradestate);
    
    
    // 计算尺寸
    // 说明一的高度
    CGRect rectOne = [FormValidator rectWidthAndHeightWithStr:self.infoOneLabel.text AndFont:14 WithStrWidth:SCREEN_WIDTH-70];
    // 说明二的高度
    CGRect rectTwo = [FormValidator rectWidthAndHeightWithStr:self.infoTwoLabel.text AndFont:14 WithStrWidth:SCREEN_WIDTH-70];
        
    // 图片
    self.proImageV.frame = CGRectMake(10, 10, 50, 50);
    // 名称
    self.proNameLabel.frame = CGRectMake(self.proImageV.qmui_right+15, self.proImageV.qmui_top + 2.5, SCREEN_WIDTH-self.proImageV.qmui_right-20, 20);
    // 价格
    self.moneyLabel.frame = CGRectMake(self.proImageV.qmui_right+15, self.proNameLabel.qmui_bottom + 5, self.proNameLabel.ly_width, 20);
    // 小图片
    self.littleImvOne.frame = CGRectMake(20, self.proImageV.qmui_bottom+5, 20, 20);
    [self addSubview:self.littleImvOne];
    // 说明一
    self.infoOneLabel.frame = CGRectMake(self.littleImvOne.qmui_right+10, self.littleImvOne.qmui_top, SCREEN_WIDTH-self.littleImvOne.qmui_right-30, rectOne.size.height);
    // 小图片
    self.littleImvTwo.frame = CGRectMake(20, self.infoOneLabel.qmui_bottom + 5, 20, 20);
    [self addSubview:self.littleImvTwo];
    // 说明二
    self.infoTwoLabel.frame = CGRectMake(self.littleImvTwo.qmui_right+10, self.littleImvTwo.qmui_top, SCREEN_WIDTH-self.littleImvTwo.qmui_right-30, rectTwo.size.height);
    
    // 是否购买
    NSString *isBuy = proModel.isBuy;
    self.isBuyLabel.frame = CGRectMake(SCREEN_WIDTH-110, self.proNameLabel.qmui_top-2, 80, 25);
    
    self.daifuButton.frame = CGRectMake(0, 0, 80, 25);
    self.daifuButton.centerX = self.isBuyLabel.centerX;
    self.daifuButton.top = self.isBuyLabel.bottom + 5;
   
        self.isBuyLabel.backgroundColor = [UIColor mainColor];
        self.isBuyLabel.text = @"一键升级";
        
                //0线上购买，显示价格  //2线上购买,不显示价格
                if ([proModel.trueFalseBuy isEqualToString:@"0"] || [proModel.trueFalseBuy isEqualToString:@"2"]) {
                    if (proModel.grade.intValue <= SharedUserInfo.grade.intValue) {
                        self.isBuyLabel.backgroundColor = [UIColor darkGrayColor];
                        self.isBuyLabel.text = @"已经购买";
                    } else {
                        self.isBuyLabel.text = @"一键升级";
                        
                    }
                }
                //1在线客服，显示价格 //2在线客服，不显示价格
                if ([proModel.trueFalseBuy isEqualToString:@"1"] || [proModel.trueFalseBuy isEqualToString:@"3"]) {
                    if (proModel.grade.intValue <= SharedUserInfo.grade.intValue) {
                        self.isBuyLabel.backgroundColor = [UIColor darkGrayColor];
                        self.isBuyLabel.text = @"已经购买";
                    } else {
                        self.isBuyLabel.text = @"在线客服";
                    }
                }
}


- (void)onDaifuTouched:(UIButton *)button {
    QMUIDialogTextFieldViewController *dialogViewController = [[QMUIDialogTextFieldViewController alloc] init];
    dialogViewController.title = @"请输入手机号码";
    [dialogViewController addTextFieldWithTitle:nil configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
        textField.placeholder = @"11位手机号码";
        textField.keyboardType = UIKeyboardTypePhonePad;
        textField.maximumTextLength = 11;
    }];
    dialogViewController.enablesSubmitButtonAutomatically = YES;// 自动根据输入框的内容是否为空来控制 submitButton.enabled 状态。这个属性默认就是 YES，这里为写出来只是为了演示
    dialogViewController.shouldEnableSubmitButtonBlock = ^BOOL(QMUIDialogTextFieldViewController *aDialogViewController) {
        // 条件改为一定要写满11位才允许提交
        return aDialogViewController.textFields.firstObject.text.length == aDialogViewController.textFields.firstObject.maximumTextLength;
    };
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    __weak __typeof(self)weakSelf = self;
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *dialog) {
        QMUIDialogTextFieldViewController *td = (QMUIDialogTextFieldViewController *)dialog;
        [MCChoosePayment payForWithAmount:weakSelf.proModel.money.floatValue productId:weakSelf.proModel.ID productName:weakSelf.proModel.name couponId:@"" payForPhone:td.textFields.firstObject.text];
        
        [dialog hide];
    }];
    [dialogViewController show];
}

@end
