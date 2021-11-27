//
//  ZABuyViewController.m
//  Project
//
//  Created by SS001 on 2019/7/16.
//  Copyright © 2019 LY. All rights reserved.
//

#import "ZABuyViewController.h"
#import "ZABuyGoodsView.h"

@interface ZABuyViewController ()
@property (nonatomic, strong) UIScrollView *contentView;
@end

@implementation ZABuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setNavigationBarTitle:@"购买商品" tintColor:[UIColor whiteColor]];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop)];
    [self.view addSubview:scrollView];
    self.contentView = scrollView;
    
    ZABuyGoodsView *buyView = [ZABuyGoodsView showView];
    buyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 755);
    buyView.goodsModel = self.goodsModel;
    [self.contentView addSubview:buyView];
    self.contentView.contentSize = CGSizeMake(0, buyView.ly_height);
    buyView.callBack = ^(CGFloat viewH) {
        self.contentView.contentSize = CGSizeMake(0, viewH);
    };
}

@end
