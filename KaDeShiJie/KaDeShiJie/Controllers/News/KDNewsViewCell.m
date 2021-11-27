//
//  KDNewsViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/8.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDNewsViewCell.h"

@interface KDNewsViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *desView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *timeView;

@end

@implementation KDNewsViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 12;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"news";
    KDNewsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDNewsViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)setModel:(MCNewsModel *)model
{
    _model = model;
    
    self.titleView.text = model.title;
    self.desView.text = model.remark;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.lowSource]];
    self.timeView.text = model.createTime;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 294);
}
@end
