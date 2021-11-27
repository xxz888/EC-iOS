//
//  MCFenrunModel.h
//  MCOEM
//
//  Created by wza on 2020/5/9.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCFenrunModel : NSObject

@property (nonatomic, copy) NSString *acqrate;
@property (nonatomic, copy) NSString *scale;
@property (nonatomic, copy) NSString *acqAmount;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *oriuserid;
@property (nonatomic, copy) NSString *acquserid;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *ordercode;
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *oriphone;
@property (nonatomic, copy) NSString *acqphone;
@property (nonatomic, copy) NSString *orirate;
@property (nonatomic, copy) NSString *acqratio;

/**
 扩展属性
 */
//@property (nonatomic, copy) NSString *oriphoneAdress;
//@property (nonatomic, copy) NSString *oriphoneTag;

@end

NS_ASSUME_NONNULL_END
