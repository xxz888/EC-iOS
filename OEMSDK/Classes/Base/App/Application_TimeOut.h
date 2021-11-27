//
//  Application_TimeOut.h
//  Project
//
//  Created by 熊凤伟 on 2018/1/24.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kApplicationTimeoutInMinutes 10
#define kApplicationDidTimeoutNotification @"ApplicationDidTimeout"


@interface Application_TimeOut : UIApplication

{
    NSTimer *_idleTimer;
}

- (void)resetIdleTimer;

@end
