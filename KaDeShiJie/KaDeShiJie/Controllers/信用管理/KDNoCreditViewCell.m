//
//  KDNoCreditViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDNoCreditViewCell.h"
#import "KDConfirmCreditViewController.h"

@interface KDNoCreditViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *creditBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@end

@implementation KDNoCreditViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"nocredit";
    KDNoCreditViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDNoCreditViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,44,18);
    gl.startPoint = CGPointMake(0.53, 0);
    gl.endPoint = CGPointMake(0.53, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:204/255.0 green:162/255.0 blue:100/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:170/255.0 green:115/255.0 blue:34/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    self.creditBtn.layer.cornerRadius = 8.5;
    self.creditBtn.layer.masksToBounds = YES;
    [self.creditBtn.layer insertSublayer:gl atIndex:0];
    
    self.bgView.layer.cornerRadius = 10;
}


- (IBAction)creditBtn:(UIButton *)sender {
    if (self.model.realNameStatus.intValue == 1) {
        KDConfirmCreditViewController *vc = [[KDConfirmCreditViewController alloc] init];
        vc.model = self.model;
        [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
    } else {
        [MCToast showMessage:@"对方还未实名，不能给对方授信"];
    }
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
}
@end
