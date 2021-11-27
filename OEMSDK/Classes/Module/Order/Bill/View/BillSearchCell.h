//
//  BillSearchCell.h
//  Project
//
//  Created by liuYuanFu on 2019/6/4.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BillSearchCell : UITableViewCell




@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@end

NS_ASSUME_NONNULL_END
