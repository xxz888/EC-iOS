//
//  NSMutableDictionary+MCNoNull.m
//  MCOEM
//
//  Created by Nitch Zheng on 2020/3/19.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "NSMutableDictionary+MCNoNull.h"

@implementation NSMutableDictionary (YNAdd)
- (void)setParam:(id)object forKey:(NSString *)key {
    if (object && key.length) {
        [self setObject:object forKey:key];
    }
}
@end

@implementation NSArray (YNAdd)

- (id)objectSafeAtIndex:(NSUInteger)index {
    return index < self.count ? [self objectAtIndex:index] : nil;
}
- (id)secondObject {
    return [self objectSafeAtIndex:1];
}
@end

@implementation NSMutableArray (YNAdd)

- (void)addSafeObject:(id)anObject {
    if (anObject) {
        [self addObject:anObject];
    }
}
- (void)addObjects:(NSArray *)objects filter:(BOOL (^)(id, id))filter {
    [self addObjects:objects checkCount:self.count filter:filter];
}
- (void)addObjects:(NSArray *)objects minFilter:(BOOL (^)(id, id))filter {
    [self addObjects:objects checkCount:objects.count filter:filter];
}
- (void)addObjects:(NSArray *)objects checkCount:(NSInteger)checkCount filter:(BOOL (^)(id, id))filter {
    if (checkCount > self.count) {
        checkCount = self.count;
    }
    for (id item in objects) {
        BOOL duplicate = NO;
        for (int i = 0; i < checkCount; i++) {
            id exsitItem = self[self.count - 1 - i];
            duplicate = filter(exsitItem, item);
            if (duplicate) {
                break;
            }
        }
        if (!duplicate) {
            [self addObject:item];
        }
    }
}
@end

