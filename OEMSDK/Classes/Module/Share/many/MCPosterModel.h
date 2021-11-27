//
//  MCPosterModel.h
//  MCOEM
//
//  Created by wza on 2020/4/17.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCPosterModel : NSObject

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *qrcodeId;
@property (nonatomic, copy) NSString *qrcodeUrl;    //图片链接
@property (nonatomic, assign) NSInteger brandId;
@property (nonatomic, assign) NSInteger ID;

@end

NS_ASSUME_NONNULL_END
