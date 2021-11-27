//
//  KDShareSingleHeader.h
//  KaDeShiJie
//
//  Created by wza on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDShareSingleHeader : UIView


@property (weak, nonatomic) IBOutlet UIImageView *imgView;


- (UIImage *)snapshotScreenInView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
