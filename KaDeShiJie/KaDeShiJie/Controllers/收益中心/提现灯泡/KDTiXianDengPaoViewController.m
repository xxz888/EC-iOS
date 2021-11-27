//
//  KDTiXianDengPaoViewController.m
//  KaDeShiJie
//
//  Created by apple on 2021/5/8.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDTiXianDengPaoViewController.h"

@interface KDTiXianDengPaoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLbl;

@end

@implementation KDTiXianDengPaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"提现" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    if (self.count == 0) {
        self.tipLbl.text = @"您尚未达到提现标准,直推激活8人后即可提现";
    }else{
        NSInteger chaCount = 8 - self.count;
        for (int i = 1; i < 11; i++) {
            UIImageView * imv = [self.view viewWithTag:10 + i];
            imv.image = [UIImage imageNamed:i <= self.count ? @"kd_tixian_dengpao_select":@"kd_tixian_dengpao_nomal"];
        }
        self.tipLbl.text = [NSString stringWithFormat:@"恭喜您已成功直推激活%ld人，还差%ld人即可提现。",self.count,chaCount];
    }

    
}
@end
