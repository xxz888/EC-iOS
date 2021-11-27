//
//  MCProtocolViewController.m
//  MCOEM
//
//  Created by SS001 on 2020/3/31.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCProtocolViewController.h"
#import <WebKit/WebKit.h>

@interface MCProtocolViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation MCProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:[self.whereCome isEqualToString:@"1"] ? @"注册协议" : @"用户信息授权协议" tintColor:UIColor.whiteColor];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavigationContentTopConstant, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTopConstant) configuration:config];
    [self.view addSubview:self.webView];
    
    NSString *filePath = [[NSBundle OEMSDKBundle] pathForResource:[self.whereCome isEqualToString:@"1"] ? @"UserAgreement.html" : @"UserAuthorize.html" ofType:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    
    self.webView.navigationDelegate = self;
}




#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString * jsStr  =[NSString stringWithFormat:@"changeBrandCompany('%@')",SharedConfig.brand_company];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        MCLog(@"--------error %@",error);
        MCLog(@"--------result %@",result);
    }];
}

@end
