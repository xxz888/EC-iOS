//
//  SingleBankView.h
//  Project
//
//  Created by liuYuanFu on 2019/6/5.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SingleBankView;
@protocol SigleBankDelegate <NSObject>

-(void)justMethodChuFa:(UIButton *)sender;

@end
@interface SingleBankView : UIView
@property (weak, nonatomic) id<SigleBankDelegate>delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top_bgHeight;
@property (weak, nonatomic) IBOutlet UIView *bankView;


// 导航条标题
@property (weak, nonatomic) IBOutlet UILabel *serviceTitle;

@property (weak, nonatomic) IBOutlet UILabel *phoneLb;

@property (weak, nonatomic) IBOutlet UIImageView *bankImg;

@property (weak, nonatomic) IBOutlet UILabel *bankLb;
// 热线/图标/名称
@property (strong, nonatomic) NSArray *headArr;
@end

NS_ASSUME_NONNULL_END
