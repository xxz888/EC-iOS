//
//  MCShequController.m
//  MCOEM
//
//  Created by wza on 2020/5/12.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCShequController.h"

@interface MCShequController ()
@property (weak, nonatomic) IBOutlet UIView *vvv;

@end

@implementation MCShequController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"信用社区" tintColor:nil];
    self.view.backgroundColor = UIColorForBackground;
    self.vvv.backgroundColor = MAINCOLOR;
    for (int i=0; i<8; i++) {
        UIView *bg = [self.view viewWithTag:1000+i];
        if (bg) {
            bg.layer.cornerRadius = 5;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBgTouched:)];
            [bg addGestureRecognizer:tap];
         }
    }
}
- (void)onBgTouched:(UITapGestureRecognizer *)tap {
    NSArray *temp = @[@"办卡进度查询",@"大数据查询",@"公积金查询",@"学信网查询",@"信用查询",@"养卡攻略",@"社保查询",@"卡保险"];
    [MCPagingStore pushWebWithTitle:temp[tap.view.tag-1000] classification:@"功能跳转"];
}


@end
