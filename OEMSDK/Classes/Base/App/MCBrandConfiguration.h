//
//  MCBrandInfo.h
//  MCOEM
//
//  Created by wza on 2020/3/4.
//  Copyright © 2020 MingChe. All rights reserved.
//  贴牌配置表（info.plist-> MCConfig）

#import <Foundation/Foundation.h>
#import <MGJRouter/MGJRouter.h>
#import "MCTabBarModel.h"
#import "MCCustomModel.h"

// 登录成功后的代码块
typedef void (^didLoginBlock)(MCNetResponse * _Nullable rsp);

#define BCFI [MCBrandConfiguration sharedInstance]

NS_ASSUME_NONNULL_BEGIN

@interface MCBrandConfiguration : NSObject

+ (instancetype)sharedInstance;

/// 更改模块
/// @param url 具体请查看文件 MCModuleHeader.h
/// @param handler handler
- (void)registerURLPattern:(NSString *)url toObjectHandler:(MGJRouterObjectHandler)handler;


#pragma mark - tab样式
//配置的一级页面，根据title是否为空去掉了未配置的
@property(nonatomic, strong) NSMutableArray<MCTabBarModel *> *tab_items;
//是否异形tabbar（中间凸起）, 默认NO
@property (nonatomic, assign) BOOL tab_iscenter;
//中间异形按钮的图片，当 tab_iscenter 为YES时设置
@property(nonatomic, strong) UIImage *tab_center_image;
//默认选中，默认 0
@property (nonatomic, assign) NSInteger tab_selected_index;

#pragma mark - 贴牌信息
//贴牌id
@property (nonatomic, copy) NSString *brand_id;
//贴牌名称
@property (nonatomic, copy) NSString *brand_name;
//公司名称，默认是 brand_name
@property (nonatomic, copy) NSString *brand_company;

#pragma mark - 开关
//是否有银行卡OCR,默认NO
@property (nonatomic, assign ) BOOL is_bank_card_ocr;
//banner是否根据城市定位，默认NO
@property (nonatomic, assign ) BOOL is_location_banner;
//是否需要引导页 ，默认YES
@property (nonatomic, assign ) BOOL is_guide_page;
//是否播放推送语音,默认NO
@property (nonatomic, assign ) BOOL is_notify_sound;
//分享后是否加积分，默认NO
@property (nonatomic, assign) BOOL is_share_conin;
//是否需要代人购买，默认NO
@property (nonatomic, assign) BOOL is_dairen_buy;

#pragma mark - 颜色
//主题色，默认随机色
@property (nonatomic, strong) UIColor *color_main;

#pragma mark - 图片
@property(nonatomic, strong) UIImage *image_logo;
@property(nonatomic, strong) UIImage *image_login_logo;

#pragma mark - 第三方keys
//极光推送
@property (nonatomic, copy ) NSString *key_jpush;
//友盟分享，使用系统分享api不填
@property (nonatomic, copy ) NSString *key_umshare;
//美洽客服
@property (nonatomic, copy ) NSString *key_meiqia;
//微信分享key，使用系统分享api不填
@property (nonatomic, copy ) NSString *key_wechat;
//微信分享appsecret，使用系统分享api不填
@property (nonatomic, copy ) NSString *key_wechat_appsecret;
//qq分享appid，使用系统分享api不填
@property (nonatomic, copy ) NSString *key_qq_share_appid;
//dns
@property (nonatomic, copy ) NSString *key_dns;
#pragma mark - 其他
//服务器版本号，默认 v1.0
@property (nonatomic, copy ) NSString *api_version;
//做tf时候写入的包名(可不用)
@property (nonatomic, copy ) NSString *tf_bundle_id;
//真正的host，去除另一个host中的http
@property(nonatomic, copy, readonly) NSString *pureHost;
/// 登录完成后block，默认是显示 MCTabBarViewController
@property(nonatomic, assign) didLoginBlock block_login;
/// 记录是进原生还是H5
@property (nonatomic, copy) NSString *native_limit;
// 设置页面账户安全标题，默认：账户安全
@property (nonatomic, copy) NSString *safe_title;






#pragma mark - MCConfig-module


@end

NS_ASSUME_NONNULL_END
