//
//  MCChooseChannelController.h
//  MCOEM
//
//  Created by wza on 2020/5/6.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBaseViewController.h"
#import "MCChannelModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^chooseChannelBlock)(MCChannelModel *model);

@interface MCChooseChannelController : MCBaseViewController

- (instancetype)initWithCardNo:(NSString *)no amount:(NSString *)amount handler:(chooseChannelBlock)handeler;

@end

NS_ASSUME_NONNULL_END
