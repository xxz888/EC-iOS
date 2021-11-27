//
//  MCChangePwdViewController.h
//  AFNetworking
//
//  Created by SS001 on 2020/7/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCChangePwdViewController : MCBaseViewController
/** 判断下标：（0：重置登录密码 1：重置交易密码 2：忘记交易密码） */
@property (nonatomic, assign) NSInteger index;
/** 新密码 */
@property (nonatomic, copy) NSString *nowDataString;

@property (nonatomic, copy) NSString *phone;
@end

NS_ASSUME_NONNULL_END
