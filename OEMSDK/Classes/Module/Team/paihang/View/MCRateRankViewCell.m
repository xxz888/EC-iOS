//
//  MCRateRankViewCell.m
//  Pods
//
//  Created by SS001 on 2020/7/22.
//

#import "MCRateRankViewCell.h"

@interface MCRateRankViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *myrateLB;
@property (weak, nonatomic) IBOutlet UIImageView *headIM;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *phoneLB;
@property (weak, nonatomic) IBOutlet UILabel *amountLB;

@end

@implementation MCRateRankViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"RateRankCell";
    MCRateRankViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"MCRateRankViewCell" bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    return cell;
}

- (void)setModel:(MCIncomeRateModel *)model
{
    _model = model;
    
    self.myrateLB.text= [NSString stringWithFormat:@"%@", model.ranking];
    self.headIM.image=MCModelStore.shared.brandConfiguration.image_logo;
    self.userName.text=model.name;
    self.phoneLB.text=[NSString stringWithFormat:@"%@", model.phone];
    self.amountLB.text = [NSString stringWithFormat:@"%.2f", model.rebate.floatValue];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headIM.layer.cornerRadius = self.headIM.qmui_height * 0.5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
