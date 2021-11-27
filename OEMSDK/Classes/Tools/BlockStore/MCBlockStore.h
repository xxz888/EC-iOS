//
//  MCBlockStore.h
//  Pods
//
//  Created by wza on 2020/9/2.
//

#import "MCStore.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCBlockStore : MCStore

/// 登录之后的显示原生还是h5
@property(nonatomic, assign, readonly) didLoginBlock blockNativeOrH5;


@end

NS_ASSUME_NONNULL_END
