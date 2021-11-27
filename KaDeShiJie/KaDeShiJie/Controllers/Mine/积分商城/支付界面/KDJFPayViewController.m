//
//  KDJFPayViewController.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/8.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFPayViewController.h"
#import "KDJFOrderDetailViewController.h"
@interface KDJFPayViewController ()

@end

@implementation KDJFPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"支付" backgroundImage:[UIImage qmui_imageWithColor:UIColor.mainColor]];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];

    self.wxBtn.selected = YES;
    self.zfbBtn.selected = NO;
    self.priceLbl.text = [NSString stringWithFormat:@"￥ %@",self.goodDic[@"priceMoney"]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)zhifuAction:(id)sender {
    kWeakSelf(self);
    [self.sessionManager mc_Post_QingQiuTi:@"facade/app/coin/order/add" parameters:@{@"gid":self.goodDic[@"id"],@"count":@"1",@"payType":self.wxBtn.selected ? @"1002" : @"2002"} ok:^(MCNetResponse * _Nonnull resp) {
        MCWebViewController *web = [[MCWebViewController alloc] init];
        web.title = self.wxBtn.selected ? @"微信支付" : @"支付宝支付";
        web.urlString = resp.result[@"payUrl"];
        [MCLATESTCONTROLLER.navigationController qmui_pushViewController:web animated:YES completion:^{
//            KDJFOrderDetailViewController * vc = [[KDJFOrderDetailViewController alloc]init];
//            [weakself.navigationController pushViewController:vc animated:YES];
        }];
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
    } failure:^(NSError * _Nonnull error) {
        [MCLoading hidden];
    }];
}
- (IBAction)zfbAction:(id)sender {
    if (!self.zfbBtn.selected) {
        self.wxBtn.selected = NO;
        self.zfbBtn.selected = YES;
    }
   
}

- (IBAction)wxAction:(id)sender {
    if (!self.wxBtn.selected) {
        self.wxBtn.selected = YES;
        self.zfbBtn.selected = NO;
    }

}
@end
