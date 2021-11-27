//
//  MCCustomModel.h
//  OEMSDK
//
//  Created by apple on 2020/12/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCCustomModel : NSObject

@property (nonatomic, copy) NSString *api;
@property (nonatomic, copy) NSString *bindChannelName;
@property (nonatomic, copy) NSString *whereCome;
@property (nonatomic, copy) NSString *smsApi;
@property (nonatomic, copy) NSString *smsParameters;
@property (nonatomic, copy) NSDictionary * kongKa_Save_Parameters;
@property (nonatomic, copy) NSDictionary * xinYongKa_Save_Parameters;

@end

NS_ASSUME_NONNULL_END
