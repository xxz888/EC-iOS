//
//  KDJFOrderDetailHeaderView.h
//  KaDeShiJie
//
//  Created by apple on 2021/6/10.
//  Copyright © 2021 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDJFOrderDetailHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *fuzhi1Btn;
@property (weak, nonatomic) IBOutlet UIButton *fuzhi2Btn;
- (IBAction)fuzhi1Action:(id)sender;
- (IBAction)fuzhi2Action:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *dImv;
@property (weak, nonatomic) IBOutlet UIImageView *dimv2;

@end

NS_ASSUME_NONNULL_END
