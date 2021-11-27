//
//  KDReturnMoneyHeaderView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KDReturnMoneyHeaderViewDelegate <NSObject>

- (void)returnMoneyHeaderViewGetTime:(NSString *)yearMonth;

@end

@interface KDReturnMoneyHeaderView : UIView
@property (weak, nonatomic) IBOutlet QMUIButton *yearBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *monthBtn;
@property (nonatomic, weak) id<KDReturnMoneyHeaderViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
