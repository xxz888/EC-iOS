//
//  MCHistoryProfitModel.h
//  Project
//
//  Created by Li Ping on 2019/8/6.
//  Copyright © 2019 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCHistoryProfitContent : NSObject

@property (nonatomic, copy) NSString *profit;
@property (nonatomic, copy) NSString *date;

@end

@interface MCHistoryProfitModel : NSObject

@property (nonatomic, copy) NSString *totalPages;
@property (nonatomic, copy) NSString *totalProfit;
@property (nonatomic, copy) NSString *currentPage;
@property (nonatomic, copy) NSString *pageNum;

@property (nonatomic, strong) NSArray <MCHistoryProfitContent *> * content;

@end








NS_ASSUME_NONNULL_END
