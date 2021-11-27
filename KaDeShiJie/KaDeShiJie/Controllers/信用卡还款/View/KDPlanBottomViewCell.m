//
//  KDPlanBottomViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDPlanBottomViewCell.h"

@interface KDPlanBottomViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation KDPlanBottomViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.openBtn.layer.cornerRadius = self.openBtn.ly_height * 0.5;
    self.nameView.font = [UIFont qmui_systemFontOfSize:16 weight:QMUIFontWeightBold italic:NO];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"planBottomCell";
    KDPlanBottomViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDPlanBottomViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setIsLast:(BOOL)isLast
{
    _isLast = isLast;
    
    if (isLast) {
        self.bgView.layer.cornerRadius = 10;
        self.bgView.layer.qmui_maskedCorners = QMUILayerMinXMaxYCorner | QMUILayerMaxXMaxYCorner;
    }
}
@end
