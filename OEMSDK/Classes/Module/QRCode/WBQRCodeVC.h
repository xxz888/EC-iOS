//
//  WBQRCodeVC.h
//  SGQRCodeExample
//
//  Created by kingsic on 2018/2/8.
//  Copyright © 2018年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBQRCodeVCDelegate <NSObject>

- (void)scancodeViewControllerComplete:(NSString *)str;

@end

@interface WBQRCodeVC : MCBaseViewController

@property (nonatomic, weak) id <WBQRCodeVCDelegate> delegate;

@end
