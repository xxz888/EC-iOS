//
//  MCAboutViewController.m
//  MCOEM
//
//  Created by wza on 2020/4/16.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCAboutViewController.h"
#import "MCAboutHeader.h"

@interface MCAboutViewController ()

@end

@implementation MCAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBarTitle:@"关于我们" tintColor:UIColor.whiteColor];
    
    self.mc_tableview.tableHeaderView = [MCAboutHeader newFromNib];
    self.mc_tableview.mj_header = nil;
}



@end
