//
//  QuestionDataSource.h
//  Project
//
//  Created by SS001 on 2020/3/19.
//  Copyright © 2020 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCQuestionDataSource : NSObject<UITableViewDataSource>
@property (nonatomic, strong) NSArray *data;
@end

NS_ASSUME_NONNULL_END
