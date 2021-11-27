//
//  MCPopShareController.m
//  Project
//
//  Created by Li Ping on 2019/6/5.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCPopShareController.h"

@interface MCPopShareController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet UILabel *brandLab;
@property (weak, nonatomic) IBOutlet UILabel *slogLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrait;


@end

@implementation MCPopShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *phone = MCModelStore.shared.userInfo.phone;
    NSString *mainAddress = MCModelStore.shared.brandInfo.shareMainAddress;
    NSString *brandId = MCModelStore.shared.brandInfo.ID;
    NSString *url = [NSString stringWithFormat:@"%@?z=%@&brand_id=%@", mainAddress,phone,brandId];
    UIImage *image = [MCImageStore creatShareImageWithImage:[UIImage mc_imageNamed:@"mc_sharepop_bg"] shareUrlString:url];
    self.imgView.image = [MCImageStore creatImage:image cornerRadius:10];
    self.logoImgView.image  = [MCImageStore getAppIcon];
    self.logoImgView.layer.cornerRadius = 8;
    self.logoImgView.layer.masksToBounds = YES;
    
    self.brandLab.textColor = MAINCOLOR;
    self.slogLab.textColor = MAINCOLOR;
    self.brandLab.text = MCModelStore.shared.brandConfiguration.brand_name;
    self.brandLab.hidden = YES;
    if (IS_NOTCHED_SCREEN) {
        self.topConstrait.constant = 100;
    } else if (IS_55INCH_SCREEN ) {
        self.topConstrait.constant = 30;
    } else {
        self.topConstrait.constant = 20;
    }
    
}

//- (void)viewDidLayoutSubviews {
//    //计算图片实际开始显示的y
//    CGFloat ivR = self.imgView.bounds.size.width/self.imgView.bounds.size.height;
//    CGFloat iR = self.imgView.image.size.width/self.imgView.image.size.height;
//
//    CGFloat iY = 0.0;
//
//    if (ivR > iR) {
//        iY = 0.0;
//    } else {
//        iY = (self.imgView.bounds.size.height - self.imgView.image.size.height * self.imgView.bounds.size.width / self.imgView.image.size.width) / 2 ;
//    }
//
//    self.topConstrait.constant += iY;
//}



- (IBAction)bgTouched:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)shareTouched:(id)sender {
    
    CGFloat ivR = self.imgView.bounds.size.width/self.imgView.bounds.size.height;
    CGFloat iR = self.imgView.image.size.width/self.imgView.image.size.height;
    
    CGFloat iY = 0;
    CGFloat iX = 0;
    
    if (ivR > iR) {
        iY = 0;
        iX = (self.imgView.bounds.size.width - self.imgView.image.size.width * self.imgView.bounds.size.height / self.imgView.image.size.height) / 2;
    } else {
        
        iY = (self.imgView.bounds.size.height - self.imgView.image.size.height * self.imgView.bounds.size.width / self.imgView.image.size.width) / 2  ;
        iX = 0;
    }
    
    CGFloat x = self.imgView.frame.origin.x + iX;
    CGFloat y = self.imgView.frame.origin.y + iY;
    CGFloat w = self.imgView.frame.size.width - 2*iX;
    CGFloat h = self.imgView.frame.size.height - 2*iY;

    UIImage *shareimg = [MCImageStore screenShotWithFrame:CGRectMake(x, y, w, h)];
    [MCShareStore sharePlatform:shareimg];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

@end
