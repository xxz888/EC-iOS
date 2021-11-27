//
//  MCProductDetailCell.m
//  MCOEM
//
//  Created by wza on 2020/5/13.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCProductDetailCell.h"

@interface MCProductDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;


@property(nonatomic, strong) MCFeilvModel *model;

@end

@implementation MCProductDetailCell

+ (instancetype)cellWithTableview:(UITableView *)tableview channelModel:(MCFeilvModel *)model {
    static NSString *cellID = @"MCProductDetailCell";
    MCProductDetailCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:cellID];
        cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    }
    cell.model = model;
    return cell;
}
- (void)setModel:(MCFeilvModel *)model {
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.log] placeholderImage:self.imageView.image];
    self.nameLab.text = model.name;
    if ([model.subName containsString:@"还款"]) {
        self.typeLab.text = @"还款到信用卡";
    } else {
        self.typeLab.text = @"充值到提现卡";
    }
    if (model.singleMaxLimit.floatValue < 10000) {
        self.lab1.text = [NSString stringWithFormat:@"%d-%d", model.singleMinLimit.intValue, model.singleMaxLimit.intValue];
    } else {
        self.lab1.text = [NSString stringWithFormat:@"%d-%d万", model.singleMinLimit.intValue, (int)(model.singleMaxLimit.floatValue / 10000)];
    }
    
    self.lab2.text = [NSString stringWithFormat:@"%@-%@", model.startTime, model.endTime];
    
    int maxLimit = model.everyDayMaxLimit.intValue;
    if (maxLimit >= 10000) {
        maxLimit = maxLimit / 10000;
        self.lab4.text = [NSString stringWithFormat:@"%d万", maxLimit];
    } else {
        self.lab4.text = [NSString stringWithFormat:@"%d", maxLimit];
    }
    self.lab4.text = [NSString stringWithFormat:@"%.2f%%", model.rate.floatValue *100];
   
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.lab1.textColor=self.lab2.textColor=self.lab3.textColor=self.lab4.textColor=MAINCOLOR;
    
}

-(void)setFrame:(CGRect)frame{
    frame.origin.y += 1;
    frame.size.height -= 1;
    [super setFrame:frame];
}

@end
