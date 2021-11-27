//
//  MCUpdateView.h
//  Project
//
//  Created by Li Ping on 2019/8/2.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCUpdateAlertView : UIView

- (void)showWithVersion:(NSString *)version content:(NSString *)content downloadUrl:(NSString *)url isForce:(BOOL)force;

@end

NS_ASSUME_NONNULL_END
