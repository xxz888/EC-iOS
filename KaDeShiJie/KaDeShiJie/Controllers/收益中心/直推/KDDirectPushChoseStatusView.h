//
//  KDDirectPushChoseStatusView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDDirectPushChoseStatusView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pushHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn4Height;

@property (nonatomic, copy) void (^choseStatus)(NSString *status);

@property (nonatomic, strong) NSArray *titleArray;
@end

NS_ASSUME_NONNULL_END
