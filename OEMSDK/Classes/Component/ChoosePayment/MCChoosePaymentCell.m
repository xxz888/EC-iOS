//
//  MCChoosePaymentCell.m
//  Project
//
//  Created by Li Ping on 2019/6/3.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCChoosePaymentCell.h"
#import "MCPaymentModel.h"

@interface MCChoosePaymentCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;

@end

@implementation MCChoosePaymentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MCPaymentModel *)model {
    _model  = model;
    self.titleLab.text = model.subName;
    self.descLab.text = model.remarks;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.log]];
}

@end
