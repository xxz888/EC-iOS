//
//  MCStatusCell.h
//  MCOEM
//
//  Created by wza on 2020/4/28.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^buttonTouchBlock)(QMUIButton *button);

@interface MCStatusCell : UITableViewCell

@property(nonatomic, strong) QMUIButton *button;

+ (instancetype)cellForTableView:(UITableView *)tableView;

@property(nonatomic, copy) buttonTouchBlock touchBlock;

@end

NS_ASSUME_NONNULL_END
