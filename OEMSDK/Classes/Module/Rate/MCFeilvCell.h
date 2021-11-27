//
//  MCFeilvCell.h
//  MCOEM
//
//  Created by wza on 2020/4/22.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCFeilvCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet QMUIMarqueeLabel *channelName;
@property (weak, nonatomic) IBOutlet UILabel *feilvLab;
@property (weak, nonatomic) IBOutlet UILabel *limitLab;

+ (instancetype)cellWithTableView:(UITableView *)tableview;


@end

NS_ASSUME_NONNULL_END
