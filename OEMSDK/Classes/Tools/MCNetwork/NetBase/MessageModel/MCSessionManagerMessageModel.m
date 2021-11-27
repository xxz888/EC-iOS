//
//  MCSessionManagerMessageModel.m
//  MCOEM
//
//  Created by wza on 2020/4/13.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCSessionManagerMessageModel.h"

@implementation MCSessionManagerMessageModel

- (instancetype)initWithTarget:(id)target sel:(SEL)sel shortURLString:(NSString *)shortURLString parameters:(id)parameters okResp:(MCSMNormalHandler)okResp otherResp:(MCSMNormalHandler)otherResp failure:(MCSMErrorHandler)failure {
    
    self.shortURLString = [shortURLString copy];
    self.parameters = [parameters copy];

    self.okResp = [okResp copy];
    self.otherResp = [otherResp copy];
    self.failure = [failure copy];
    
    return [super initWithTarget:target sel:sel,self.shortURLString,self.parameters,self.okResp,self.otherResp,self.failure];
}

@end
