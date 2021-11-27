//
//  QMWSMenuList.h
//  沁美文化
//
//  Created by Apple on 2017/7/16.
//  Copyright © 2017年 qinmei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QMWSMenuList <NSObject>

@property(nonatomic,copy) void(^selectItem)(NSInteger idx);

@property(nonatomic,copy) void(^viewTouch)();

@end
