//
//  Application_TimeOut.m
//  Project
//
//  Created by 熊凤伟 on 2018/1/24.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "Application_TimeOut.h"

@implementation Application_TimeOut

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    
    // Fire up the timer upon first event
    if(!_idleTimer) {
        [self resetIdleTimer];
    }
    
    // Check to see if there was a touch event
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0) {
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan) {
            [self resetIdleTimer];
        }
    }
}

- (void)resetIdleTimer {
    
    if (_idleTimer) {
        [_idleTimer invalidate];
    }
    
    // Schedule a timer to fire in kApplicationTimeoutInMinutes * 60
    int timeout = kApplicationTimeoutInMinutes * 60;
    _idleTimer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                   target:self
                                                 selector:@selector(idleTimerExceeded)
                                                 userInfo:nil
                                                  repeats:NO];
}

- (void)idleTimerExceeded {
    /* Post a notification so anyone who subscribes to it can be notified when
     * the application times out */
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidTimeoutNotification object:nil];
}

@end











