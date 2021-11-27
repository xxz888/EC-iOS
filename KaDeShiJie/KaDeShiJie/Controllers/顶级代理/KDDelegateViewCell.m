//
//  KDDelegateViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDDelegateViewCell.h"

@interface KDDelegateViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *gradeView;
@property (weak, nonatomic) IBOutlet UILabel *phoneView;
@property (weak, nonatomic) IBOutlet UILabel *iDView;
@property (weak, nonatomic) IBOutlet UILabel *timeView;
@property (weak, nonatomic) IBOutlet UILabel *directPushView;
@property (weak, nonatomic) IBOutlet UILabel *realNameView;

@end

@implementation KDDelegateViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.gradeView.layer.masksToBounds = YES;
    self.gradeView.layer.cornerRadius = 7.5;
    self.bgView.layer.cornerRadius = 10;
    self.nameView.font = [UIFont qmui_systemFontOfSize:14 weight:QMUIFontWeightBold italic:NO];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"topdelegate";
    KDDelegateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDDelegateViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 107);
}


- (void)setModel:(KDTopDelegateNewModel *)model
{
    _model = model;
    self.nameView.text = model.userName.length != 0 ? model.userName : @"未实名";
    self.iDView.text = [NSString stringWithFormat:@"ID:%@", model.userId];
    self.timeView.text = [NSString stringWithFormat:@"达标时间:%@", model.createTime];
    NSString *first = [model.phone substringToIndex:3];
    NSString *last = [model.phone substringFromIndex:7];
    self.phoneView.text = [NSString stringWithFormat:@"%@****%@", first, last];
    self.directPushView.text = [NSString stringWithFormat:@"%@人", model.firSize];
    self.gradeView.text = model.gradeName;
    self.realNameView.text = [NSString stringWithFormat:@"%@人", model.realSize];
    
    
    self.gradeView.backgroundColor = [model.firSize integerValue] < 8 ? [UIColor qmui_colorWithHexString:@"#0072E3"] : [UIColor qmui_colorWithHexString:@"#F56F00"];
    
}


@end
