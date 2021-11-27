//
//  MCLiuYanBanTableViewCell.m
//  OEMSDK
//
//  Created by apple on 2021/1/5.
//

#import "MCLiuYanBanTableViewCell.h"

@implementation MCLiuYanBanTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MCLiuYanBanTableViewCell";
    MCLiuYanBanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MCLiuYanBanTableViewCell" bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    

    
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImv.image = SharedAppInfo.icon;
    self.contenttView.layer.shadowRadius = 10;
    ViewRadius(self.iconImv, 18);
    
    // 1. 创建一个点击事件，点击时触发labelClick方法
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickKFAction)];
    // 2. 将点击事件添加到label上
    [self.contentLbl addGestureRecognizer:labelTapGestureRecognizer];
    // 可以理解为设置label可被点击
    self.contentLbl.userInteractionEnabled = YES;
    
    

    
    
}
- (void)clickKFAction
{
    if ([self.contentLbl.text containsString:@"在线客服"]) {
        [MCServiceStore pushMeiqiaVC];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
