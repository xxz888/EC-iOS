//
//  MCWelcomeController.m
//  MCOEM
//
//  Created by wza on 2020/3/11.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCGuidViewController.h"

@interface MCGuidViewController ()

@end

@implementation MCGuidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatScrollView];
}

- (void)creatScrollView {
    
    NSArray *imageArr = nil;
    
    imageArr = @[@"welcome_0", @"welcome_1", @"welcome_2",@"welcome_3"];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * imageArr.count, SCREEN_HEIGHT);
    for (int i = 0; i < imageArr.count; i++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageV.image = [UIImage mc_imageNamed:imageArr[i]];
        
        if (i == imageArr.count - 1) {
            imageV.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipToHomeVC)];
            [imageV addGestureRecognizer:tap];
            
            // 添加立即进入按钮
            UIButton *enterButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            enterButton.frame = CGRectMake((imageV.qmui_width - 200)/2, imageV.qmui_height-TabBarHeight-42, 200, 42);
            enterButton.titleLabel.font = [UIFont systemFontOfSize:18];
            enterButton.layer.cornerRadius = 5;
            enterButton.layer.masksToBounds = YES;
            enterButton.backgroundColor = [UIColor clearColor];
            enterButton.layer.borderWidth =2;
            enterButton.layer.borderColor = MCModelStore.shared.brandConfiguration.color_main.CGColor;
            
            [enterButton setTitle:@"立即体验" forState:(UIControlStateNormal)];
            [enterButton setTitleColor:MCModelStore.shared.brandConfiguration.color_main forState:(UIControlStateNormal)];
            [enterButton addTarget:self action:@selector(skipToHomeVC) forControlEvents:(UIControlEventTouchUpInside)];
            [imageV addSubview:enterButton];
        }
        
        [scrollView addSubview:imageV];
    }
    [self.view addSubview:scrollView];
}

- (void)skipToHomeVC {
    MCModelStore.shared.userDefaults.not_first_launch = YES;
    [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_user_signupin];
}


@end
