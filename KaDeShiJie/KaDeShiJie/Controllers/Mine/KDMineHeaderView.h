//
//  KDMineHeaderView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/8.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDMineHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
- (void)getUserGradeName;
@end

NS_ASSUME_NONNULL_END
