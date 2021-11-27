//
//  ZAPayTypeViewCell.m
//  Project
//
//  Created by SS001 on 2019/7/16.
//  Copyright © 2019 LY. All rights reserved.
//

#import "ZAPayTypeViewCell.h"

@interface ZAPayTypeViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *detailView;
@property (weak, nonatomic) IBOutlet UIImageView *rightIconView;
@end

@implementation ZAPayTypeViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"channel_cell";
    ZAPayTypeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"ZAPayTypeViewCell" bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setChannelModel:(ZAChannelModel *)channelModel
{
    _channelModel = channelModel;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:channelModel.log]];
    self.titleView.text = channelModel.name;
    self.detailView.text = channelModel.remarks;
    self.rightIconView.hidden = !channelModel.isChose;
}

@end
