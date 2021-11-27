//
//  MCTabBarViewController.m
//  MCOEM
//
//  Created by wza on 2020/3/6.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCTabBarViewController.h"
#import "MCBaseViewController.h"
#import "MCTabBar.h"
#import "MCModuleListController.h"
#import "MCTabBarModel.h"
#import "MCBrandConfiguration.h"

@interface MCTabBarViewController ()

@end

@implementation MCTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupChilds];
    self.selectedIndex = MCModelStore.shared.brandConfiguration.tab_selected_index;
    
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(tabBarPan:)];
    pan.edges = UIRectEdgeLeft;
    [self.tabBar addGestureRecognizer:pan];
}
- (void)tabBarPan:(UIScreenEdgePanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.tabBar];
    if (pan.state == UIGestureRecognizerStateEnded && point.x > SCREEN_WIDTH*0.6) {
        [self openDebugIfInLAN];
    }
}
- (void)openDebugIfInLAN {
//    NSDictionary *ipDic = [self deviceWANIPAdress];
//    if (ipDic) {
//        if ([ipDic[@"cip"] isEqualToString:@"101.85.207.97"]) {   //内网
            MCNavigationController *nav = [[MCNavigationController alloc] initWithRootViewController:[MCModuleListController new]];
            [self presentViewController:nav animated:YES completion:nil];
//        }
//    }
}


- (void)setupChilds {
    
    if (MCModelStore.shared.brandConfiguration.tab_iscenter) {
        [self setValue:[[MCTabBar alloc] init] forKey:@"tabBar"];
        [self addShadowForCenter];
    }
    NSInteger childItems = BCFI.tab_items.count;
    
    NSMutableArray *navControllers = [NSMutableArray new];
    
    for (int i=0; i<childItems; i++) {
        MCTabBarModel *model = BCFI.tab_items[i];
        
        NSString *itemTitle = model.title;
        
        MCBaseViewController *vc = model.controller;
        vc.hidesBottomBarWhenPushed = NO;
        MCNavigationController *nav = [[MCNavigationController alloc] initWithRootViewController:vc];
        

        UIImage *img = [UIImage imageNamed:model.iconName];
        UIImage *selImg = [UIImage imageNamed:model.selectedIconName];
        UITabBarItem *item = [self creatTabBarItemWithTiele:itemTitle image:img seletedImage:selImg tag:i];
        nav.tabBarItem = item;
        
        [navControllers addObject:nav];
    }

    //title颜色和图片颜色保持一致
    /*
    UIImage *img = [UIImage imageNamed: BCFI.tab_items[0].iconName];
    UIImage *selImg = [UIImage imageNamed: BCFI.tab_items[0].selectedIconName];
    UIColor *titleColor = [MCImageStore getThemeColorOfImage:img];
    UIColor *selTitleColor = [MCImageStore getThemeColorOfImage:selImg];
    UITabBarItem *item = [UITabBarItem appearance];
    */
    
    //title颜色和图片颜色保持一致
    UIColor *titleColor = [UIColor qmui_colorWithHexString:@"#999999"];
    
    UIColor *selTitleColor = BCFI.color_main;
    UITabBarItem *item = [UITabBarItem appearance];
    
    // 适配iOS13导致的bug
    if (@available(iOS 13.0, *)) {
        // iOS 13以上
        self.tabBar.tintColor = selTitleColor;
        self.tabBar.unselectedItemTintColor = titleColor;
        
    } else {
        // iOS 13以下
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:selTitleColor} forState:UIControlStateSelected];
    }
    
    
    
    self.viewControllers = navControllers;
    
}

#pragma mark - 中心按钮添加阴影
- (void)addShadowForCenter{
    //阴影设置
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    
    [path addLineToPoint:CGPointMake(SCREEN_WIDTH/2-45/2-5,0)];
    [path addArcWithCenter:CGPointMake(SCREEN_WIDTH/2,0) radius:45/2+5 startAngle:M_PI endAngle:2*M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(SCREEN_WIDTH/2+45/2+5,0)];
    [path addLineToPoint:CGPointMake(SCREEN_WIDTH,0)];
    path.lineWidth = 5;
    
    [path stroke];
    
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    layer.shadowOffset = CGSizeMake(0,-3);
    layer.shadowColor = [UIColor qmui_colorWithHexString:@"#E8E8E8"].CGColor;
    layer.shadowRadius = 2.0f;//阴影半径，默认3
    layer.shadowOpacity = 0.5f;//阴影透明度，默认0
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    [self.tabBar.layer insertSublayer:layer atIndex:0];
}
- (UITabBarItem *)creatTabBarItemWithTiele:(NSString *)title image:(UIImage *)image seletedImage:(UIImage *)seletedImage tag:(int)tag {
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:image tag:tag];
    item.selectedImage = [seletedImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    item.qmui_doubleTapBlock = ^(UITabBarItem *tabBarItem, NSInteger index) {
        [[MCLATESTCONTROLLER getMCTableView].mj_header beginRefreshing];
    };
    return item;
}


/// 获取ip
-(NSDictionary *)deviceWANIPAdress{
    
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"https://pv.sohu.com/cityjson?ie=utf-8"];
    
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    //判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        //对字符串进行处理，然后进行json解析
        //删除字符串多余字符串
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        //将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return dict;
    }
    return nil;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (self.selectedIndex != selectedIndex) {
        _preSelectedIndex = self.selectedIndex;
    }
    [super setSelectedIndex:selectedIndex];
}
 
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger index = [tabBar.items indexOfObject:item];
    if (index != self.selectedIndex) {
        _preSelectedIndex = self.selectedIndex;
    }
}
@end
