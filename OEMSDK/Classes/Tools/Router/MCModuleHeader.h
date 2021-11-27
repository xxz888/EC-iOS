//
//  MCModuleHeader.h
//  MCOEM
//
//  Created by wza on 2020/3/10.
//  Copyright © 2020 MingChe. All rights reserved.
//

#ifndef MCModuleHeader_h
#define MCModuleHeader_h

/*
 * url命名格式为 mc://oc/模块/页面，宏定义：rt_模块_页面
 */
#pragma mark - 通知
#define rt_notice_list                  @"mc://oc/notice/list"              //消息

#define rt_tabbar_list                  @"mc://oc/tabbar/list"              //底部tabbar

#pragma mark - 新闻分类
#define rt_news_list                    @"mc://oc/news/list"                //新闻分类
#define rt_news_community               @"mc://oc/news/community"           //信用社区
#define rt_news_operation               @"mc://oc/news/operation"           //操作教程
#define rt_news_videos                  @"mc://oc/news/videos"              //视频教程

#pragma mark - 分享
#define rt_share_single                 @"mc://oc/share/single"             //单张分享
#define rt_share_many                   @"mc://oc/share/many"               //多张分享
#define rt_share_article                @"mc://oc/share/article"            //中央文案、朋友圈


#pragma mark - 团队
#define rt_team_overview                @"mc://oc/team/overview"            //团队
#define rt_team_ranking                 @"mc://oc/team/ranking"             //排行榜

#pragma mark - 用户
#define rt_user_info                    @"mc://oc/user/info"                //个人信息
#define rt_user_realname                @"mc://oc/user/realname"            //实名
#define rt_user_signupin                @"mc://oc/user/signupin"            //登录注册
#define rt_user_sign                    @"mc://oc/user/sign"                //签到
#define rt_user_restPwd                 @"mc://oc/user/restPwd"                //重置密码
#define rt_user_homeService                 @"mc://oc/user/homeService"                //联系客服

#pragma mark - 银行卡
#define rt_card_list                    @"mc://oc/card/list"                //银行卡列表
#define rt_card_edit                    @"mc://oc/card/edit"                //银行卡添加、编辑
#define rt_card_add                     @"mc://oc/card/add"                 //绑卡



#pragma mark - 设置
#define rt_setting_list                 @"mc://oc/setting/list"             //设置
#define rt_setting_service              @"mc://oc/setting/service"          //客服
#define rt_setting_accountsafe          @"mc://oc/setting/accountsafe"      //账户安全

#pragma mark - 升级
#define rt_update_list                  @"mc://oc/update/list"              //升级
#define rt_update_updatesave            @"mc://oc/update/updatesave"        //升级省钱

#pragma mark - 收款
#define rt_collection_cashier           @"mc://oc/collection/cashier"       //收银台
#define rt_collection_npcashier         @"mc://oc/collection/npcashier"     //np收款

#pragma mark - 账单
#define rt_order_list                   @"mc://oc/order/list"               //账单

#pragma mark - 收益
#define rt_profit_overview              @"mc://oc/profit/overview"          //收益
#define rt_profit_list                  @"mc://oc/profit/list"              //收益明细

#pragma mark - 余额||钱包
#define rt_balance_overview             @"mc://oc/balance/overview"         //余额

#pragma mark - 费率
#define rt_rate_myrate                  @"mc://oc/rate/myrate"              //我的费率

#pragma mark - 定制化功能
#define rt_custom_dailishang            @"mc://oc/custom/dailishang"        //代理商入口

#pragma mark - webVc
#define rt_web_controller               @"mc://oc/web/controller"           //加载链接的控制器

#pragma mark - DIY
#define rt_diy_home                     @"mc://oc/diy/home"                 //首页组件化

#pragma mark - 身份认证1
#define rt_card_vc1                     @"mc://oc/card/vc1"                 //身份认证1
#define rt_card_vc2                     @"mc://oc/card/vc2"                 //身份认证2




#define rt_card_jianquan             @"mc://oc/card/jianquan"       //鉴权
#define rt_card_jiaoyi               @"mc://oc/card/jiaoyi"         //交易
#define rt_card_ttfsms               @"mc://oc/card/ttfsms"         //统统付短信
#define rt_card_bjffjiaoyi           @"mc://oc/card/rt_card_bjffjiaoyi"         //北京丰付交易
#define rt_card_shoukuanxiangqing       @"mc://oc/card/rt_card_shoukuanxiangqing"//收款交易详情
#define rt_card_jiaoyijilu       @"mc://oc/card/rt_card_jiaoyijilu"//交易记录

#define rt_card_liuyanban      @"mc://oc/card/liuyanban"//留言板界面


 #define TTFPay_1_QUICK  @"TTFPay_1_QUICK"
#define TFTPay_QUICK     @"TFTPay_QUICK"
#define TFTPay_1_QUICK   @"TFTPay_1_QUICK"
#define DFPay_QUICK      @"DFPAY_QUICK"
#define GSPay_HK_QUICK      @"GSPay_HK_QUICK"


#define GYFPay_KJ_QUICK    @"GYFPay_KJ_QUICK"
#define BJFFPay_KJ_QUICK    @"BJFFPay_KJ_QUICK"

#define GSPay_KJ_QUICK    @"GSPay_KJ_QUICK"

#define TTFPay_QUICK  @"TTFPay_QUICK"
#define DYPay_QUICK   @"DYPay_QUICK"
#define GYFPay_QUICK   @"GYFPay_QUICK"
#define TYDE_8920_QUICK   @"TYDE_8920_QUICK"

#define shoukuan_jianquan         @"shoukuan_jianquan"
#define kongkahuankuan_jianquan   @"kongkahuankuan_jianquan"
#define yuehuankuan_jianquan      @"yuehuankuan_jianquan"


/*headers*/
#import "MCLoginViewController.h"
#import "XLLoginViewController.h"
#import "MCLoginWithoutBgVC.h"

#import "DelegateShangViewController.h"
#import "MCCashierController.h"
#import "MCUpdateViewController.h"

#import "MCUpdateViewController2.h"
#import "MCUpdateViewController3.h"


#import "MCShareSingleViewController.h"
#import "MCShareManyViewController.h"
#import "MCMessageController.h"
#import "MCCardManagerController.h"
#import "MCIncomeRateViewController.h"
#import "MCUserInfoViewController.h"
#import "DelegateShangViewController.h"
#import "MCRealNameViewController.h"
#import "MCMyRateController.h"
#import "MCSignViewController.h"
#import "MCSettingViewController.h"
#import "MCOrderListController.h"
#import "MCServiceController.h"
#import "MCBalanceController.h"
#import "MCProfitController.h"
#import "MCTeamController.h"
#import "MCVideoController.h"
#import "MCNewsListController.h"
#import "MCCaozuoController.h"
#import "MCArticlesController.h"
#import "MCShequController.h"
#import "MCCountSafeController.h"
#import "MCNPCashierController.h"
#import "MCUpdateSaveController_X.h"
#import "MCCardManagerController1.h"
#import "MCWebViewController.h"
#import "MCEditBankCardController.h"
#import "MCDiyController.h"
#import "KDPayGatherViewController.h"
#import "MCShareSingleImgViewController.h"
#import "MCBillSearchViewController.h"
#import "MCVipViewController.h"
#import "MCRateRankViewController.h"

#import "MCMessageController_logo.h"
#import "MCProfitListController.h"

#import "MCAccreditation1ViewController.h"
#import "MCAccreditation2ViewController.h"
#import "KDForgetPwdViewController.h"
#import "MCHomeServiceViewController.h"


#import "KDPayJianQuanViewController.h"
#import "KDTTFJiaoYiViewController.h"
#import "MCLiuYanBanViewController.h"
#import "KDGuidePageManager.h"

#endif /* MCModuleHeader_h */
