//
//  QZGShareImageVC.m
//  Project
//
//  Created by chenwei on 2019/11/28.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCShareSingleViewController.h"


@interface MCShareSingleViewController ()

@property(nonatomic, strong) UIImage *originalImg;  //原图

@property(nonatomic, strong) UIImage *processedImg;  //处理好图

@end

@implementation MCShareSingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"我的二维码" tintColor:UIColor.whiteColor];
    self.mc_tableview.mj_header = nil;
    
    self.mc_tableview.tableHeaderView = [[UIImageView alloc] initWithImage:self.originalImg];
    [self creatView];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:@"分享" target:self action:@selector(shareTouched:)];
}
- (void)shareTouched:(UIBarButtonItem *)sender {
    [MCShareStore shareIOS:self.processedImg];
}
- (void)creatView {
    [MCLoading show];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIImage *imgWithQr = [MCImageStore creatShareImageWithImage:self.originalImg];
        self.processedImg = imgWithQr;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mc_tableview.tableHeaderView = [[UIImageView alloc] initWithImage:imgWithQr];
            [MCLoading hidden];
        });
        
    });
}


- (UIImage *)originalImg {
    if (!_originalImg) {
        NSString *name = nil;
//        if (SharedConfig.module_sharesingle.intValue == 0) {
//            name = @"share_qr_code_img";
//        }
//        if (SharedConfig.module_sharesingle.intValue == 1) {
            name = @"share_qr_code_img_blue";
//        }
        _originalImg = [[UIImage mc_imageNamed:name] qmui_imageResizedInLimitedSize:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX)];
    }
    return _originalImg;
}

@end
