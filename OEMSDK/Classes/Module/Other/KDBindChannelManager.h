//
//  KDBindChannelManager.h
//  OEMSDK
//
//  Created by apple on 2020/12/16.
//

#import <Foundation/Foundation.h>
#import "KDDirectRefundModel1.h"
#import "KDChannelView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDBindChannelManager : NSObject
+ (instancetype)sharedConfig;
@property (nonatomic, strong) KDDirectRefundModel1 * directRefundModel;//信用卡的信息
@property (nonatomic, strong) MCBankCardModel * mcBankCardmodel;//储蓄卡的信息
@property (nonatomic, strong) QMUIModalPresentationViewController * presentAlert;
@property (nonatomic, strong) KDChannelView * commonAlert;


@property (nonatomic, strong) NSString * creditCardNumber;
@property (nonatomic, strong) NSString * getSmsUrl;
@property (nonatomic, strong) NSString * confirmSmsUrl;
@property (nonatomic, strong) NSString * channelTag;
#pragma mark -----------------------多通道设置，获取所有信用卡信息---------------------
-(void)getAllXinYongKaList;
@end

NS_ASSUME_NONNULL_END
