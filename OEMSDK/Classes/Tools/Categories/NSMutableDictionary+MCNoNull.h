//
//  NSMutableDictionary+MCNoNull.h
//  MCOEM
//
//  Created by Nitch Zheng on 2020/3/19.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  添加字典时数据安全
 */
#ifndef SafeDicObj
#define SafeDicObj(obj) ((obj) ? (obj) : @"")
#endif

@interface NSMutableDictionary (YNAdd)
- (void)setParam:(id)object forKey:(NSString *)key;
@end

@interface NSArray<ObjectType> (YNAdd)
- (ObjectType)objectSafeAtIndex:(NSUInteger)index;
- (ObjectType)secondObject;
@end

@interface NSMutableArray<ObjectType> (YNAdd)
- (void)addSafeObject:(id)anObject;

/**
 添加数组元素 过滤器
 */
- (void)addObjects:(NSArray<ObjectType> *)objects minFilter:(BOOL(^)(ObjectType existObj, ObjectType addObj))filter;
- (void)addObjects:(NSArray<ObjectType> *)objects filter:(BOOL(^)(ObjectType existObj, ObjectType addObj))filter;
- (void)addObjects:(NSArray<ObjectType> *)objects checkCount:(NSInteger)checkCount filter:(BOOL(^)(ObjectType existObj, ObjectType addObj))filter;
@end

NS_ASSUME_NONNULL_END
