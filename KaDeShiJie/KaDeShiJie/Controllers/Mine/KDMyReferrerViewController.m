//
//  KDMyReferrerViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDMyReferrerViewController.h"

@interface KDMyReferrerViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *bottomPhoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *topPhoneLabel;
@end

@implementation KDMyReferrerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topView.layer.cornerRadius = 10;
    
    // 导航条
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    [self setNavigationBarHidden];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage mc_imageNamed:@"nav_left_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, StatusBarHeightConstant, 44, 44);
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = @"我的推荐人";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    if (MCModelStore.shared.preUserPhone.length == 11) {
        NSLog(@"%@",MCModelStore.shared.preUserPhone);
        NSString *pre = [MCModelStore.shared.preUserPhone substringToIndex:3];
        NSString *suf = [MCModelStore.shared.preUserPhone substringFromIndex:MCModelStore.shared.preUserPhone.length - 4];
        self.topPhoneLabel.text = [NSString stringWithFormat:@"直接推荐人:%@****%@",pre,suf];
        self.bottomPhoneLabel.text = [NSString stringWithFormat:@"手机:%@****%@",pre,suf];
    } else {
        self.topPhoneLabel.text = @"没有直接推荐人";
        self.bottomPhoneLabel.text = @"没有手机";
    }
    
    
}
- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickPhoneAction:(id)sender {
    if (MCModelStore.shared.preUserPhone.length == 11) {
        [MCServiceStore call:MCModelStore.shared.preUserPhone];
    } else {
        [MCToast showMessage:@"没有推荐人"];
    }
}
@end
