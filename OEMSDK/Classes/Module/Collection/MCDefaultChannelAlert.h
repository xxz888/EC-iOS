//
//  MCDefaultChannelAlert.h
//  MCOEM
//
//  Created by wza on 2020/5/5.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCChannelModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^channelActionBlock)(MCChannelModel *model);

@interface MCDefaultChannelAlert : NSObject


- (void)showWithChannelInfo:(MCChannelModel *)model amount:(NSString *)amount changeHandler:(channelActionBlock)change sureHandler:(channelActionBlock)sure;

@end

NS_ASSUME_NONNULL_END
