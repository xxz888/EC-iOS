//
//  MCSessionManagerMessageModel.h
//  MCOEM
//
//  Created by wza on 2020/4/13.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCSessionManagerMessageModel : MessageModel


@property(nonatomic, copy) NSString *shortURLString;
@property(nonatomic) id parameters;

@property(nonatomic, copy) MCSMNormalHandler okResp;
@property(nonatomic, copy) MCSMNormalHandler otherResp;
@property(nonatomic, copy) MCSMErrorHandler failure;


- (instancetype)initWithTarget:(id)target sel:(SEL)sel
                shortURLString:(nullable NSString *)shortURLString
                    parameters:(nullable id )parameters
                        okResp:(nullable MCSMNormalHandler)okResp
                     otherResp:(nullable MCSMNormalHandler)otherResp
                       failure:(MCSMErrorHandler)failure;

@end

NS_ASSUME_NONNULL_END
