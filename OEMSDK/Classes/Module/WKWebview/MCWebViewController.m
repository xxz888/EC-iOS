//
//  MCWebViewController.m
//  MCOEM
//
//  Created by wza on 2020/4/2.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCWebViewController.h"
#import <WebKit/WebKit.h>
#import "MCShareManyNavigateController.h"
#import "MCApp.h"


@interface MCWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic, strong) UIProgressView *progress;
@property (nonatomic, copy) NSString *old_redirect_url;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, copy) NSString *urlScheme;

@property(nonatomic, strong) QMUIPopupMenuView *menuView;

@property(nonatomic, assign) BOOL isMingcheDomain;

@property(nonatomic, copy) NSString *localPageName;

@end

@implementation MCWebViewController

- (QMUIPopupMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[QMUIPopupMenuView alloc] init];
        _menuView.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
        _menuView.maskViewBackgroundColor = UIColorMaskWhite;// 使用方法 2 并且打开了 automaticallyHidesWhenUserTap 的情况下，可以修改背景遮罩的颜色
        _menuView.shouldShowItemSeparator = YES;
        __weak __typeof(self)weakSelf = self;
        _menuView.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {
            // 利用 itemConfigurationHandler 批量设置所有 item 的样式
            
            [aItem.button setTitleColor:UIColorBlack forState:UIControlStateNormal];
        };
        
        QMUIPopupMenuButtonItem *item0 = [QMUIPopupMenuButtonItem itemWithImage:nil title:@"分享" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
            
            [MCShareStore shareWebLink:@[self.navigationItem.title, BCFI.image_logo, [NSURL URLWithString:self.urlString]]];
            [aItem.menuView hideWithAnimated:YES];
        }];
        
        QMUIPopupMenuButtonItem *item1 = [QMUIPopupMenuButtonItem itemWithImage:nil title:@"关闭页面" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
            [weakSelf close];
            [aItem.menuView hideWithAnimated:YES];
        }];
        
        QMUIPopupMenuButtonItem *item2 = [QMUIPopupMenuButtonItem itemWithImage:nil title:@"刷新页面" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
            //清理缓存
            NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
                [weakSelf.webView reload];
                [aItem.menuView hideWithAnimated:YES];
            }];
        }];
        
        QMUIPopupMenuButtonItem *item3 = [QMUIPopupMenuButtonItem itemWithImage:nil title:@"浏览器打开" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:weakSelf.urlString]];
            [aItem.menuView hideWithAnimated:YES];
        }];
        
        if (self.classifty && [self.classifty isEqualToString:@"资讯"]) {
            _menuView.items = @[item0, item1, item2, item3];
        } else {
            _menuView.items = @[item1, item2, item3];
        }
        
    }
    return _menuView;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.tabBarController.tabBar setHidden:YES];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:self.title tintColor:nil];
    /*取消加载本地vue包
    if ([self.title isEqualToString:@"空卡还款"] ||
        [self.title isEqualToString:@"信用卡还款"] ||
        [self.title isEqualToString:@"交易记录"]) {
        [self setNavigationBarHidden];
        self.localPageName = self.title;
        self.progress.hidden = YES;
        
        [MCLoading show];
    }
    */
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progress];
    [self loadWebRequest];
}

-(void)loadWebRequest{
    if (self.localPageName) {   //加载本地vue包
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"dist"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:1000];
        [request setValue:TOKEN forHTTPHeaderField:@"authToken"];
        [request setValue:SharedDefaults.deviceid forHTTPHeaderField:@"deviceId"];
        [request setValue:@"ios" forHTTPHeaderField:@"platform"];
        [request setValue:SharedAppInfo.version forHTTPHeaderField:@"version"];
        [self.webView loadRequest:request ];
        return;
    }
    
    
    if(self.urlString && self.urlString.length > 0){
        
        self.isMingcheDomain = [self.urlString containsString:@"minchetech.com"];
        NSString *tempString = [MCSessionManager.shareManager removeExtraSlashOfUrl:self.urlString];
        NSString *encodeString = [MCVerifyStore verifyURL:tempString];
        self.request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodeString] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15];
        if (self.isMingcheDomain) {
            [self.request setValue:TOKEN forHTTPHeaderField:@"authToken"];
            [self.request setValue:SharedDefaults.deviceid forHTTPHeaderField:@"deviceId"];
            [self.request setValue:@"ios" forHTTPHeaderField:@"platform"];
            [self.request setValue:SharedAppInfo.version forHTTPHeaderField:@"version"];
        }
        [self.webView loadRequest:self.request];
    } else {
//        [MCToast showMessage:@"链接无效"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    UIBarButtonItem *backItem = [UIBarButtonItem qmui_backItemWithTarget:self action:@selector(backTouched:)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithTitle:@"•••" target:self action:@selector(rightTouched:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.menuView.sourceBarItem = rightItem;
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc] init];
        [conf.userContentController addScriptMessageHandler:self name:@"iosWebKit"];
        
        CGFloat contentTop = self.mc_nav_hidden ? StatusBarHeight : NavigationContentTop;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, contentTop, SCREEN_WIDTH, SCREEN_HEIGHT-contentTop) configuration:conf];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.clipsToBounds = YES;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _webView;
}
- (UIProgressView *)progress {
    if (!_progress) {
        _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        CGFloat contentTop = self.mc_nav_hidden ? StatusBarHeight : NavigationContentTop;
        _progress.frame = CGRectMake(0, contentTop, SCREEN_WIDTH, 2);
        _progress.tintColor = MAINCOLOR.qmui_inverseColor;
        _progress.trackTintColor = self.navigationBarTintColor;
    }
    return _progress;
}
#pragma mark - event response
- (void)backTouched:(UIBarButtonItem *)item {
    [self.webView stopLoading];
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        
        if (self.navigationController.viewControllers.count == 1) {
            SharedDefaults.not_auto_logonin = YES;
            [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_tabbar_list];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (void)close {
    [self.webView stopLoading];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightTouched:(UIBarButtonItem *)item {
    [self.menuView showWithAnimated:YES];
}
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.progress.alpha = 1.0f;
        [self.progress setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.progress.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.progress setProgress:0 animated:NO];
                             }];
        }
        
    } else if (object == self.webView && [keyPath isEqualToString:@"title"]) {
        if (!self.title) {
            [self setNavigationBarTitle:self.webView.title tintColor:nil];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (self.localPageName) { //如果是加载本地文件，不做处理
        return decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    
    NSURLRequest *request        = navigationAction.request;
    NSString     *scheme         = [request.URL scheme];
    NSURL *url = request.URL;
    NSString     *absoluteString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];

    if (self.isMingcheDomain && [absoluteString hasPrefix:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"] && ![absoluteString containsString:[NSString stringWithFormat:@"redirect_url=%@://",self.urlScheme]]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        
        NSURL *newUrl = [self handleWXPayUrl:url];
        NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:newUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
        newRequest.URL = newUrl;
        [webView loadRequest:newRequest];
//        NSLog(@"newrequest:%@",newRequest);
        return ;
    }
    if (self.isMingcheDomain && [absoluteString hasPrefix:@"alipay://alipayclient/"] && ![absoluteString containsString: self.urlScheme]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        
        NSURL *newAliUrl = [self handleAlipayUrl:url];
        NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:newAliUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
        newRequest.URL = newAliUrl;
        [webView loadRequest:newRequest];
        return;
    }
    
    
    if (![scheme isEqualToString:@"https"] && ![scheme isEqualToString:@"http"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:request.URL];
        if (canOpen) {
            [[UIApplication sharedApplication] openURL:request.URL];
        }
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSString * name = message.body;
    if([name isEqualToString:@"shoukuan"]){
        //收款
        [MCPagingStore pagingURL:rt_collection_cashier];
    }
    if([name isEqualToString:@"share"]){
        //分享
        [MCPagingStore pagingURL:rt_share_single];
    }
    if([name isEqualToString:@"huiyuan"]){
        //会员升级
        [MCPagingStore pagingURL:rt_update_list];
    }
    if([name isEqualToString:@"tuijian"]){
        //分享有礼
        [self.navigationController pushViewController:[MCShareManyNavigateController new] animated:YES];
    }
    if([name isEqualToString:@"wenku"]){
        //转发图文
        [MCPagingStore pagingURL:rt_share_article];
    }
    if([name isEqualToString:@"huankuan"]){
        //还款
        [MCPagingStore pushWebWithTitle:@"智能还款" classification:@"功能跳转"];
    }
    if ([name isEqualToString:@"pengyouquan"]) {    //朋友圈
        //朋友圈
        [MCPagingStore pagingURL:rt_share_article];
    }
    if ([name isEqualToString:@"goroothome"]) {    //首页
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if ([name isEqualToString:@"gologin"]) {    //重新登录
        [MCApp userLogout];
    }
    if ([name isEqualToString:@"taobaoShare"]) {
        [self.webView evaluateJavaScript:@"document.getElementById('share-image').getAttribute('src')" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            MCLog(@"%@\%@",obj,error);
            if (!error && [obj isKindOfClass:[NSString class]]) {
                NSString *src = (NSString *)obj;
                NSRange bRange = [src rangeOfString:@"base64,"];
                NSString *encodeString = [src substringFromIndex:bRange.location+bRange.length];
                NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:encodeString options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
                UIImage *decodedImage = [UIImage imageWithData: decodeData];
                if (decodedImage) {
                    [MCShareStore shareIOS:decodedImage];
                } else {
                    MCLog(@"生成图片失败");
                }
            }
        }];
    }
    if ([name isEqualToString:@"nativeHome"]) { //展示原生页面
        UIApplication.sharedApplication.keyWindow.rootViewController = [MGJRouter objectForURL:rt_tabbar_list];
    }
    if ([name isEqualToString:@"nativeLogout"]) {    //退出登录
        [MCApp userLogout];
    }
    if ([name isEqualToString:@"nativeReloadContainer"]) {    //刷新KDWebContainer
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mcNotificationWebContainnerReset" object:nil];
    }
}

- (void)dealloc
{
    _webView.UIDelegate = nil;
    _webView.navigationDelegate = nil;
    [_webView stopLoading];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"iosWebKit"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
}


#pragma mark - Private Mtheds

- (NSDictionary*)dictionaryFromQuery:(NSString*)query
{
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0] stringByRemovingPercentEncoding];
            NSString* value = [[kvPair objectAtIndex:1] stringByRemovingPercentEncoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}
- (NSURL *)handleAlipayUrl:(NSURL*)url {
//    NSLog(@"oldUrl:%@",url);
    NSString *aliPre = @"alipay://alipayclient/?";
    NSMutableString *tempStr = [[NSMutableString alloc] initWithString:url.absoluteString];
    NSString *subTempStr = [tempStr substringFromIndex:[tempStr rangeOfString:aliPre].length];
    NSMutableString *jsonStr = [[NSMutableString alloc] initWithString:[self URLDecodedString:subTempStr]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:jsonStr.mj_JSONObject];
    self.old_redirect_url = [param objectForKey:@"fromAppUrlScheme"];
    [param setObject:self.urlScheme forKey:@"fromAppUrlScheme"];
    NSString *encodeString = [self URLEncoded:param.mj_JSONString];
    NSString *newurlstring = [NSString stringWithFormat:@"%@%@",aliPre,encodeString];
//    NSLog(@"newurlstring:%@",newurlstring);
    return [NSURL URLWithString:newurlstring];
}
- (NSURL *)handleWXPayUrl:(NSURL*)url {

    NSString *prefix1 = @"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb";
    NSMutableDictionary *param = [self parameterWithURL:url];
    NSMutableString *newStr;
    if ([url.absoluteString hasPrefix:prefix1]) {
        newStr = [NSMutableString stringWithString:prefix1];
    }
    self.old_redirect_url = [param objectForKey:@"redirect_url"];
    [newStr appendString:@"?"];
    [newStr appendString:@"prepay_id="];
    [newStr appendString:[param objectForKey:@"prepay_id"]];
    [newStr appendString:@"&redirect_url="];
    [newStr appendString:[self URLEncoded:[NSString stringWithFormat:@"%@://", self.urlScheme]]];
    [newStr appendString:@"&package="];
    [newStr appendString:[param objectForKey:@"package"]];
//    NSLog(@"newStr:%@",newStr);
    return [NSURL URLWithString:newStr];
}
- (NSString *)URLEncoded:(NSString *)string
{
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
}

-(NSString *)URLDecodedString:(NSString *)str
{
    return [str stringByRemovingPercentEncoding];
}
//  从url提取字典
-(NSMutableDictionary *) parameterWithURL:(NSURL *) url {
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    
    return parm;
}
//获取scheme
- (NSString *)getScheme {
    NSString * localpath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary * infoDic = [[NSDictionary alloc] initWithContentsOfFile:localpath];
    if (infoDic) {
        NSArray *urlTypes = [infoDic objectForKey:@"CFBundleURLTypes"];
        for (NSDictionary *urlType in urlTypes) {
            NSArray *arr = [urlType objectForKey:@"CFBundleURLSchemes"];
            for (NSString *url in arr) {
                if ([url containsString:@".mingchetech.com"]) {
                    return url;
                }
            }
        }
    }
    return @"";
}

- (NSString *)urlScheme {
    if (!_urlScheme) {
        _urlScheme = [self getScheme];
    }
    return _urlScheme;
}


#pragma mark - 加载本地VUE
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    if (![MCLATESTCONTROLLER isEqual:self]) {    //展示的不是当前controller
        return completionHandler();
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    if (self.localPageName) {   //加载本地文件时候注入
        [MCLoading hidden];
        [self envaluateJS];
    }
}

- (void)envaluateJS {
    
    //从原生拿参数
    NSDictionary *pd = @{
        @"phone":SharedUserInfo.phone,
        @"token":TOKEN,
        @"brandId":BCFI.brand_id,
        @"userId":SharedUserInfo.userid,
        @"ip":BCFI.pureHost,
        @"deviceId":SharedDefaults.deviceid,
        @"pageName":self.localPageName
    };
    
    //MCLog(@"===================%@",pd);
    
    //处理调用不成功的问题
    NSString *loadJSString = @"function commitNativeInfo() {console.log(\"===========================2\", document.title, typeof nativeInitParams,userMapJson); if (document.title == \"中转\") if (typeof nativeInitParams != \"undefined\"){ try{ nativeInitParams(userMapJson); if (typeof getcard != \"undefined\"){ setTimeout(getcard, 500); } }catch(e){ console.log(e);}} else setTimeout(commitNativeInfo, 500); } commitNativeInfo();";
    
    NSString * jsStr = [NSString stringWithFormat:@"var userMapJson=%@; %@",pd.mj_JSONString, loadJSString];
    
    //MCLog(@"mj_JSONString:%@",pd.mj_JSONString);
    
    __weak __typeof(self)weakSelf = self;
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //MCLog(@"nativeInitParams--------error %@",error);
        //MCLog(@"nativeInitParams--------result %@",result);
    }];
    
}


@end
