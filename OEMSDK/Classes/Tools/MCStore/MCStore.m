//
//  MCStore.m
//  Pods
//
//  Created by wza on 2020/9/2.
//

#import "MCStore.h"

@implementation MCStore

static MCStore *_singleStore = nil;

+ (instancetype)shared {
    
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        if (_singleStore == nil) {
            _singleStore = [[self alloc] init];
        }
    });
    return _singleStore;
}

@end
