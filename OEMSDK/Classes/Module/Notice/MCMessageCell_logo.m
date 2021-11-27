//
//  MCMessageCell_logo.m
//  AFNetworking
//
//  Created by wza on 2020/7/30.
//

#import "MCMessageCell_logo.h"

@interface MCMessageCell_logo()

@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@end

@implementation MCMessageCell_logo

+ (instancetype)cellWithTableview:(UITableView *)tableview messageModel:(MCMessageModel *)model {
    static NSString *cellID = @"MCMessageCell_logo";
    MCMessageCell_logo *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:cellID];
        cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    }
    cell.lab1.text = model.title;
    cell.lab2.text = model.content;
    cell.lab3.text = model.createTime;
    cell.imgV.image = SharedAppInfo.icon;
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgView.layer.cornerRadius = 4;
    self.imgV.layer.cornerRadius = self.imgV.qmui_width/2;
}
@end
