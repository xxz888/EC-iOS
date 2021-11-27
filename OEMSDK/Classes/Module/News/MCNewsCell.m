//
//  MCNewsCell.m
//  MCOEM
//
//  Created by wza on 2020/5/11.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCNewsCell.h"
#import "MCDateStore.h"
#import "MCGradeName.h"

@interface MCNewsCell ()

@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *readNumLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet QMUILabel *limitLab;

@end

@implementation MCNewsCell

+ (instancetype)cellWithTableview:(UITableView *)tableview newsModel:(MCNewsModel *)model {
    static NSString *cellID = @"MCNewsCell";
    MCNewsCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:cellID];
        cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    }
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.lowSource] placeholderImage:[MCImageStore placeholderImageWithSize:CGSizeMake(118, 90)]];
    cell.titLab.text = model.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([model.createTime hasSuffix:@"000"]) {
        cell.timeLab.text = [MCDateStore compareCurrentTime:model.createTime];
    } else {
        cell.timeLab.text = model.createTime;
    }
    
    if (model.onOff.intValue == 0) {
//        cell.limitLab.text = @" #全部会员可见 ";
        cell.limitLab.hidden = YES;
    } else {
        cell.limitLab.hidden = NO;
        [MCGradeName getGradeNameWithGrade:model.onOff callBack:^(NSString * _Nonnull gradeName) {
            cell.limitLab.text = [NSString stringWithFormat:@" #%@用户及以上可见 ", gradeName];
        }];
        
    }
    cell.readNumLab.text = [NSString stringWithFormat:@"阅读：%d",model.previewNumber.intValue];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.limitLab.backgroundColor = MAINCOLOR;
    self.limitLab.textColor = UIColor.whiteColor;
    
    self.limitLab.contentEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
    self.limitLab.layer.cornerRadius = 2.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.imgView.layer.cornerRadius = 4.f;
    
}

@end
