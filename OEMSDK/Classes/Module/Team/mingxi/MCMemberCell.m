//
//  MCMemberCell.m
//  MCOEM
//
//  Created by wza on 2020/5/11.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCMemberCell.h"

@interface MCMemberCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;

@property(nonatomic, strong) MCMemberModel *model;

@end

@implementation MCMemberCell


+ (instancetype)cellWithTableview:(UITableView *)tableview memberModel:(MCMemberModel *)model {
    static NSString *cellID = @"MCMemberCell";
    MCMemberCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:cellID];
        cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    }
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imgView.image = [UIImage mc_imageNamed:[NSString stringWithFormat:@"mcgrade_%d",model.grade.intValue]];
    cell.lab1.text = (model.realnameStatus.intValue == 1) ? model.realname : @"未实名";
    cell.lab2.text = model.gradeName;
    if (model.phone && model.phone.length == 11) {
        NSString *pre = [model.phone substringToIndex:3];
        NSString *suf = [model.phone substringFromIndex:7];
        cell.lab3.text = [NSString stringWithFormat:@"%@****%@",pre,suf];
    }
    if (model.phone && model.phone.length > 11 && [model.phone containsString:@"注销"]) {
        NSString *phone = [model.phone substringToIndex:10];
        NSString *pre = [phone substringToIndex:3];
        NSString *suf = [phone substringFromIndex:7];
        cell.lab3.text = [NSString stringWithFormat:@"%@****%@ 注销",pre,suf];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.createTime.integerValue/1000];
    NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
    f2.dateFormat = @"yyyy-MM-dd";
    NSString *time = [f2 stringFromDate:date];
    cell.lab4.text = [NSString stringWithFormat:@"注册日期：%@",time];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (IBAction)call:(id)sender {
    NSString *phone ;
    if (self.model.phone.length == 11) {
        phone = self.model.phone;
        
    }
    if (self.model.phone.length > 11 && [self.model.phone containsString:@"注销"]) {
        phone = [self.model.phone substringToIndex:10];
    }
    [MCServiceStore call:phone];
}

@end
