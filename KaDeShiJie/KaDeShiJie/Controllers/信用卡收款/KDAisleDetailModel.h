//
//  KDAisleDetailModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/14.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDAisleDetailModel : NSObject

@property (nonatomic, copy) NSString *channelTag;
@property (nonatomic, assign) CGFloat everyDayMaxLimit;
@property (nonatomic, assign) BOOL isDeleted;
@property (nonatomic, assign) CGFloat singleMaxLimit;
@property (nonatomic, assign) CGFloat singleMinLimit;
@property (nonatomic, copy) NSString *supportBankAll;
@property (nonatomic, copy) NSString *supportBankName;
@property (nonatomic, copy) NSString *supportBankType;
@property (nonatomic, copy) NSString *ID;
@end

NS_ASSUME_NONNULL_END
