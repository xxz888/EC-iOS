//
//  LCServiceCell.h
//  Lianchuang_477
//
//  Created by wza on 2020/8/19.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titLab;

+ (instancetype)cellFromTableview:(UITableView *)tableview data:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
