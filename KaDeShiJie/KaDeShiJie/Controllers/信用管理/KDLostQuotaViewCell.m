//
//  KDLostQuotaViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/14.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDLostQuotaViewCell.h"
#import "KDRemedyView.h"

@interface KDLostQuotaViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;


@end

@implementation KDLostQuotaViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"lostquota";
    KDLostQuotaViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDLostQuotaViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 10;
    
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,65,18);
    gl.startPoint = CGPointMake(0.52, 0);
    gl.endPoint = CGPointMake(0.52, 0.99);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:204/255.0 green:162/255.0 blue:100/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:170/255.0 green:115/255.0 blue:34/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    self.remedyBtn.layer.cornerRadius = 9;
    self.remedyBtn.layer.masksToBounds = YES;
    [self.remedyBtn.layer insertSublayer:gl atIndex:0];
}

- (IBAction)clickRemedyBtn:(UIButton *)sender {
    KDRemedyView *remedyView = [[KDRemedyView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    remedyView.creditExtensionModel = self.model;
    [remedyView showView];
}

- (void)setModel:(KDCreditExtensionModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.firstUserName;
    self.moneyLabel.text = [NSString stringWithFormat:@"-%@", model.lostSuperiorQuota];
    self.idLabel.text = [NSString stringWithFormat:@"ID:%@", model.firstUserId];
}
@end
