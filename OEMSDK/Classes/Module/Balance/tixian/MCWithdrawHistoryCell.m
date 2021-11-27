//
//  MCWithdrawHistoryCell.m
//  Pods
//
//  Created by wza on 2020/9/10.
//

#import "MCWithdrawHistoryCell.h"


@interface MCWithdrawHistoryCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *amountLab;

@end

@implementation MCWithdrawHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableview:(QMUITableView *)tableview {
    static NSString *cellID = @"MCWithdrawHistoryCell";
    MCWithdrawHistoryCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:cellID];
        cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    }
    return cell;
}

@end
