//
//  SingleBankCell.h
//  Project
//
//  Created by liuYuanFu on 2019/6/5.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SingleBankCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *checkAccountLb;

@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@property (weak, nonatomic) IBOutlet UILabel *liRuLb;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (strong,nonatomic)NSArray *cellArrZ;

@end

NS_ASSUME_NONNULL_END
