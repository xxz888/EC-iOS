//
//  KDShareSingleVC.m
//  KaDeShiJie
//
//  Created by wza on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDShareSingleVC.h"
#import "KDShareSingleHeader.h"
#import <OEMSDK/WMDragView.h>

@interface KDShareSingleVC ()

@property(nonatomic, strong) KDShareSingleHeader *header;

@property(nonatomic, strong) WMDragView *dragView;

@end

@implementation KDShareSingleVC

- (WMDragView *)dragView {
    if (!_dragView) {
        _dragView = [[WMDragView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44 - 13.5, SCREEN_HEIGHT - TabBarHeight - 10 - 44, 44, 44)];
        _dragView.imageView.image = [UIImage imageNamed:@"share_single_drag"];
        _dragView.isKeepBounds = YES;
        _dragView.backgroundColor = UIColor.clearColor;
        __weak __typeof(self)weakSelf = self;
        _dragView.clickDragViewBlock = ^(WMDragView *dragView) {
            UIImage *img = weakSelf.header.imgView.image;
            if (img) {
                [MCShareStore saveToAlbum:img];
            }
        };
    }
    return _dragView;
}

- (KDShareSingleHeader *)header {
    if (!_header) {
        UIImage *img = [UIImage imageNamed:@"share_single_img"];
        CGFloat hig = img.size.height * SCREEN_WIDTH / img.size.width;
        _header = [[NSBundle mainBundle] loadNibNamed:@"KDShareSingleHeader" owner:nil options:nil].lastObject;
        _header.frame = CGRectMake(0, 0, SCREEN_WIDTH, hig);
    }
    return _header;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:@"推广二维码" tintColor:nil];
    
    QMUIButton *rightBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"分享" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor qmui_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = UIFontBoldMake(13);
    [rightBtn setImage:[UIImage imageNamed:@"share_single_share"] forState:UIControlStateNormal];
    rightBtn.imagePosition = QMUIButtonImagePositionLeft;
    rightBtn.spacingBetweenImageAndTitle = 4;
    [rightBtn addTarget:self action:@selector(shareTouched) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.mc_tableview.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop);
    self.mc_tableview.tableHeaderView = self.header;
//    self.header.imgView.image = [MCImageStore creatShareImageWithImage:[UIImage imageNamed:@"share_single_img"]];
    [self.view addSubview:self.dragView];
}
- (void)layoutTableView {
    self.mc_tableview.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop);
}

- (void)shareTouched {
    [self.header snapshotScreenInView:self.header.imgView];
    UIImage *shareImg = [self.header snapshotScreenInView:self.header.imgView];
    [MCShareStore shareIOS:shareImg];
}
@end
