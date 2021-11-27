//
//  KDWelcomeAlertView.h
//  KaDeShiJie
//
//  Created by wza on 2020/9/18.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDWelcomeAlertView : UIView

@property (weak, nonatomic) IBOutlet UIButton *btn;

+ (instancetype)alertView;

@end

NS_ASSUME_NONNULL_END
