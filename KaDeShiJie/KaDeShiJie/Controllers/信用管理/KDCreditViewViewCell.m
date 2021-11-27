//
//  KDCreditViewViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDCreditViewViewCell.h"
#import "KDCreditAlertView.h"
#import "KDConfirmCreditViewController.h"
#import "KDCancelCreditViewController.h"

@interface KDCreditViewViewCell ()
@property(nonatomic, strong) QMUIModalPresentationViewController *withdrawTypeModal;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditMoneyLabel;

@end

@implementation KDCreditViewViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"credit";
    KDCreditViewViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDCreditViewViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 取消授信
- (IBAction)cancelCreditAction:(UIButton *)sender {
//    QMUIModalPresentationViewController *diaVC = [[QMUIModalPresentationViewController alloc] init];
//    self.withdrawTypeModal = diaVC;
//    KDCreditAlertView *typeView = [[KDCreditAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 218)];
//    diaVC.contentView = typeView;
//    [diaVC showWithAnimated:YES completion:nil];
//    __weak typeof(self) weakSelf = self;
//    typeView.cancelBtnAction = ^{
//        [diaVC hideWithAnimated:YES completion:nil];
//    };
//    typeView.sureBtnAction = ^{
//
//    };
    KDCancelCreditViewController *vc = [[KDCancelCreditViewController alloc] init];
    vc.model = self.model;
    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
}
- (void)setModel:(KDCreditExtensionModel *)model
{
    _model = model;
    
    if (model.realNameStatus.intValue == 1) {
        self.nameLabel.text = model.firstUserName;
    } else {
        self.nameLabel.text = @"未实名";
    }
    self.timeLabel.text = [model.accreditTime substringWithRange:NSMakeRange(0, 10)];
    self.idLabel.text = [NSString stringWithFormat:@"ID:%@", model.firstUserId];
    
    NSString *first = [model.firstUserPhone substringWithRange:NSMakeRange(0, 3)];
    NSString *last = [model.firstUserPhone substringWithRange:NSMakeRange(7, 4)];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@****%@", first, last];
    
    self.creditMoneyLabel.text = model.superiorQuota;
}
- (IBAction)creditAction:(UIButton *)sender {
    KDConfirmCreditViewController *vc = [[KDConfirmCreditViewController alloc] init];
    vc.model = self.model;
    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
}
@end
