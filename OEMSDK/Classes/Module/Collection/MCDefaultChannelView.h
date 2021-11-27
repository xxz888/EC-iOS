//
//  MCDefaultChannelView.h
//  MCOEM
//
//  Created by wza on 2020/5/5.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MCDefaultChannelViewDelegate <NSObject>

- (void)channelViewClickOn:(UIButton *)sender;

@end

@interface MCDefaultChannelView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab11;
@property (weak, nonatomic) IBOutlet UILabel *lab12;
@property (weak, nonatomic) IBOutlet UILabel *lab21;
@property (weak, nonatomic) IBOutlet UILabel *lab22;
@property (weak, nonatomic) IBOutlet UILabel *lab31;
@property (weak, nonatomic) IBOutlet UILabel *lab32;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property(nonatomic, weak) id<MCDefaultChannelViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
