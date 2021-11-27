//
//  MCQuestionModel.h
//  MCOEM
//
//  Created by SS001 on 2020/4/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^callBack)(NSArray *array);
@interface MCQuestionModel : NSObject
- (void)requestDataWithCallBack:(callBack)callBack;
@end

NS_ASSUME_NONNULL_END
