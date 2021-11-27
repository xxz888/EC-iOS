//
//  KDDirectPushViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDDirectPushViewCell.h"

@interface KDDirectPushViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *statusView;
@property (weak, nonatomic) IBOutlet UILabel *iDView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *timeView;
@property (weak, nonatomic) IBOutlet UIView *smView;
@property (weak, nonatomic) IBOutlet UILabel *direct1ActiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *direct1AmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *direct2ActiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *direct2AmountLabel;

@end

@implementation KDDirectPushViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgView.layer.cornerRadius = 10;
    self.statusView.layer.cornerRadius = 7.5;
    self.statusView.layer.masksToBounds = YES;
    self.smView.layer.cornerRadius = 4.5;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"directpush";
    KDDirectPushViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDDirectPushViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    return cell;
}
- (void)setStatus:(NSString *)status {
    _status = status;
    NSString *statusName = @"已注册";
    if (status.intValue == 1) {
        statusName = @"已注册";
    } else if (status.intValue == 2) {
        statusName = @"已实名";
    } else if (status.intValue == 3) {
        statusName = @"已激活";
    } else if (status.intValue == 4) {
        statusName = @"已认证";
    }
    self.statusView.text = statusName;
}
/*
           "phone":"18220392076", //手机号
           "realName":null,  //姓名
           "userId":20200000000005,  //用户id
           "realNameStatus":3,  //实名状态,1:已实名,3:未实名
           "activeSatatus":0,  //是否激活,0:否,1:是
           "direct1ActiveCount":0,  //直推激活数量
           "direct2ActiveCount":0,  //间推激活数量
           "direct1Amount":596.9,  //直推交易量
           "direct2Amount":0,  //间推交易量
           "createTime":"2020-09-12"  //交易时间
 **/
- (void)setPushModel:(KDPushModel *)pushModel
{
    _pushModel = pushModel;
    
    self.nameView.text = pushModel.realName ? pushModel.realName : @"未实名";
    
    //状态=0时，是全部，要做区分
    if (self.status.intValue == 0){
        //
        NSString * title = @"";
        if ([pushModel.activeSatatus integerValue] == 1 && [self.status integerValue] == 4) {
            title = @"已认证";
        }else if ([pushModel.activeSatatus integerValue] == 1 && [self.status integerValue] == 2){
            title = @"已实名";
        }else if ([pushModel.activeSatatus integerValue] == 1){
            title = @"已激活";
        }else{
            if ([pushModel.realNameStatus integerValue] == 0) {
                title = @"实名中";
            }else if ([pushModel.realNameStatus integerValue] == 1 && [self.status integerValue] == 4){
                title = @"已认证";
            }else if ([pushModel.realNameStatus integerValue] == 1){
                title = @"已实名";
            }else if ([pushModel.realNameStatus integerValue] == 2){
                title = @"实名失败";
            }else if ([pushModel.realNameStatus integerValue] == 3){
                title = @"已注册";
            }
        }
        self.statusView.text = title;
    }
    
    self.phoneView.text = pushModel.showPhone;
    self.iDView.text = [NSString stringWithFormat:@"ID:%@", pushModel.userId];
    self.timeView.text = [NSString stringWithFormat:@"注册时间:%@", pushModel.createTime];
    self.direct1ActiveLabel.text = [NSString stringWithFormat:@"%ld", pushModel.direct1ActiveCount];
    self.direct1AmountLabel.text = [NSString stringWithFormat:@"%.2f", pushModel.direct1Amount];
    self.direct2ActiveLabel.text = [NSString stringWithFormat:@"%ld", pushModel.direct2ActiveCount];
    self.direct2AmountLabel.text = [NSString stringWithFormat:@"%.2f", pushModel.direct2Amount];
    self.statusView.layer.borderWidth = 1;
    self.statusView.layer.cornerRadius = 5;
    if ([self.statusView.text isEqualToString:@"已激活"]) {
        self.statusView.backgroundColor = [UIColor qmui_colorWithHexString:@"#FFEFDD"];
        self.statusView.layer.borderColor = [UIColor qmui_colorWithHexString:@"#FFC885"].CGColor;
        self.statusView.textColor = [UIColor qmui_colorWithHexString:@"#F08300"];
    } else if ([self.statusView.text isEqualToString:@"已注册"]) {
        self.statusView.backgroundColor = [UIColor qmui_colorWithHexString:@"##E8E8E8"];
        self.statusView.layer.borderColor = [UIColor qmui_colorWithHexString:@"#CCCCCC"].CGColor;
        self.statusView.textColor = [UIColor qmui_colorWithHexString:@"#999999"];
    } else if ([self.statusView.text isEqualToString:@"已实名"]) {
        self.statusView.backgroundColor = [UIColor qmui_colorWithHexString:@"##E8E8E8"];
        self.statusView.layer.borderColor = [UIColor qmui_colorWithHexString:@"#CCCCCC"].CGColor;
        self.statusView.textColor = [UIColor qmui_colorWithHexString:@"#333333"];
    } else if ([self.statusView.text isEqualToString:@"已认证"]) {
        self.statusView.backgroundColor = [UIColor qmui_colorWithHexString:@"#FFEFDD"];
        self.statusView.layer.borderColor = [UIColor qmui_colorWithHexString:@"#FFAF78"].CGColor;
        self.statusView.textColor = [UIColor qmui_colorWithHexString:@"#F08300"];
    }
}
- (IBAction)callPersonAction:(id)sender {
    [MCServiceStore call:self.pushModel.phone];
}
@end
