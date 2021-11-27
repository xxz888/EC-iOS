//
//  MCGradeName.h
//  Project
//
//  Created by SS001 on 2019/6/10.
//  Copyright © 2019 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCGradeName : NSObject

/**
 根据用户传入的等级获取等级的名称
 
 @param grade 传入的等级
 */

+ (void)getGradeNameWithGrade:(NSString *)grade callBack:(void (^)(NSString *gradeName))callBack;

@end

NS_ASSUME_NONNULL_END
