//
//  MCServiceCell.h
//  Project
//
//  Created by Li Ping on 2019/7/16.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCServiceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *phonePhoneLab;
@property (weak, nonatomic) IBOutlet UILabel *bgView;





+ (instancetype)cellFromTableView:(UITableView *)tableview;

@end

NS_ASSUME_NONNULL_END
