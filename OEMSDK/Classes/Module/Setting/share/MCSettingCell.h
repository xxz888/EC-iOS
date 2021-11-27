//
//  MCSettingCommonCell.h
//  MCOEM
//
//  Created by wza on 2020/4/15.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCSettingCell : UITableViewCell

@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UIImageView *imgView;
@property(nonatomic, strong) UILabel *subTitleLab;


+ (instancetype)cellWithTableView:(UITableView *)tableview;

+ (instancetype)voiceCellWithTableView:(UITableView *)tableview;

@end

NS_ASSUME_NONNULL_END
