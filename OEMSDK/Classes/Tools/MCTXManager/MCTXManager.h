//
//  MCTXManager.h
//  MCOEM
//
//  Created by wza on 2020/4/7.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


/// 调用结果
@interface MCTXResult : NSObject

@property(nonatomic, strong) NSError *error;
/// 银行卡OCR返回的银行卡号
@property (nonatomic, copy) NSString *brankCardNo;

/// 银行卡图片
@property(nonatomic, strong) UIImage *cardImg;


@end




typedef void(^MCTXCallBack) (MCTXResult *result);
/// 腾讯人脸、OCR
@interface MCTXManager : NSObject

+ (instancetype)shared;

- (void)startBankOcrCompletion:(MCTXCallBack)callBack;
- (void)startFaceEngineCompletion:(MCTXCallBack)callBack;

- (void)startBankOcrCompletion:(MCTXCallBack)callBack;

@end

NS_ASSUME_NONNULL_END
