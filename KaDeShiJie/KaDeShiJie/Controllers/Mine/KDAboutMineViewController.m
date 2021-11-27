//
//  KDAboutMineViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/14.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDAboutMineViewController.h"

@interface KDAboutMineViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHigCons;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLbl;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation KDAboutMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:@"关于我们" tintColor:[UIColor whiteColor]];
    self.topImage.layer.cornerRadius = 10;
    
    self.versionLbl.text = [NSString stringWithFormat:@"v%@",SharedAppInfo.version];
//    [self getData];
}

- (void)getData {
    [[MCSessionManager shareManager] mc_POST:@"/user/app/add/querycirclefriendslibrary/make/information" parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *result = resp.result[@"content"];
        if (result.count != 0) {
//            NSDictionary *dict = [result firstObject];
//            self.contentLabel.text = dict[@"pictureContent"];
//            NSString *urlStr = dict[@"pictureLink"];
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
//            UIImage *img = [UIImage sd_imageWithData:data];
//            CGFloat hig = img.size.height * (SCREEN_WIDTH - 20) / img.size.width;
//            self.imageHigCons.constant = hig;
//            [self.topImage sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        } else {
            self.topImage.hidden = YES;
            self.contentLabel.hidden = YES;
        }
    }];
    
    self.contentLabel.text = @"      卡提乐是行业领先的信用卡还款、刷卡、办卡软件，空卡仅需留足手续费，或5%以上的可用余额，即可全额快速还款，每万元手续费低至75元，让您彻底远离逾期；刷卡10秒内到账，每万元手续费低至38元。银联授信，安全稳定；累积注册用户超过1000万，是千万用户的共同信赖。";
    //添加手势
    self.telLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCall:)];
    [self.telLabel addGestureRecognizer:tap];
    
//    self.telLabel.text = [NSString stringWithFormat:@"电话：%@",SharedBrandInfo.brandPhone];
}
-(void)clickCall:(id)tap{
    [MCServiceStore call:@"4006666085"];

}
@end
