//
//  QZGShareImageVC.m
//  Project
//
//  Created by chenwei on 2019/11/28.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCShareSingleImgViewController.h"


@interface MCShareSingleImgViewController ()
@property(nonatomic,strong)UIImageView *BGimage;
@property(nonatomic,strong)UIImage *shareimg;

@property(nonatomic, strong) UIImage *bgImg;

@end

@implementation MCShareSingleImgViewController

- (instancetype)initWithImageType:(MCShareSingleImageType)type {
    self = [super init];
    if (self) {
        if (type == MCShareSingleImageRed) {
            self.bgImg = [UIImage mc_imageNamed:@"share_single_img_red"];
        } else if (type == MCShareSingleImageBlue) {
            self.bgImg = [UIImage mc_imageNamed:@"share_single_img_blue"];
        } else if (type == MCShareSingleImageBlack) {
            self.bgImg = [UIImage mc_imageNamed:@"share_single_img_black"];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"分享赚钱" tintColor:UIColor.whiteColor];
    [self addSubView];
}

-(void)addSubView{
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareIOS)];
    
    UIImage *image=self.bgImg;
    
    self.BGimage.frame=CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_WIDTH/image.size.width*image.size.height);
    
    UIImageView *logoImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoImage.backgroundColor = [UIColor clearColor];
    logoImage.layer.cornerRadius = 8;
    logoImage.layer.masksToBounds = YES;
    [self.BGimage addSubview:logoImage];
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.BGimage.mas_centerX);
        make.top.equalTo(self.BGimage.mas_top).offset(40);
        make.size.mas_equalTo(CGSizeMake(59, 59));
    }];
    
    UILabel *appName= [[UILabel alloc] init];
    appName.text = SharedConfig.brand_name;
    appName.textColor = [UIColor whiteColor];
    appName.font = LYFont(14);
    appName.textAlignment = 1;
    [self.BGimage addSubview:appName];
    [appName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.BGimage.mas_centerX);
        make.top.equalTo(logoImage.mas_bottom).offset(9);
        make.height.mas_equalTo(20);
    }];
    
    UIView *leftLine=[[UIView alloc]init];
    leftLine.backgroundColor=UIColor.whiteColor;
    [self.BGimage addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(appName.mas_left).offset(-8);
        make.centerY.equalTo(appName.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(17, 1.5));
    }];
    
    UIView *rightLine=[[UIView alloc]init];
    rightLine.backgroundColor=UIColor.whiteColor;
    [self.BGimage addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(appName.mas_right).offset(8);
        make.centerY.equalTo(appName.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(17, 1.5));
    }];
    
    
    self.mc_tableview=[[UITableView alloc]init];
    self.mc_tableview.tableHeaderView=self.BGimage;
    [self.view addSubview:self.mc_tableview];
    [self.mc_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.BGimage.image = [MCImageStore creatShareImageWithImage:image];
    
    [self.view layoutIfNeeded];
    
    self.shareimg = [self snapshotScreenInView:self.BGimage];
}

-(UIImageView *)BGimage{
    if(!_BGimage){
        _BGimage=[[UIImageView alloc]init];
    }
    return _BGimage;
}

- (void)shareIOS
{
    //分享的图片
    UIImage *imageToShare = self.shareimg;
    
    [MCShareStore shareIOS:imageToShare];
    
}

#pragma mark 截图
- (UIImage *)snapshotScreenInView:(UIView *)view
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(view.bounds.size);
    }
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



@end
