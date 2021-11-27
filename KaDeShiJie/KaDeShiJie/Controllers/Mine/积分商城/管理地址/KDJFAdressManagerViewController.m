//
//  KDJFAdressManagerViewController.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/11.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFAdressManagerViewController.h"

@interface KDJFAdressManagerViewController ()

@end

@implementation KDJFAdressManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:self.whereCome ? @"新增地址" : @"编辑地址" backgroundImage:[UIImage qmui_imageWithColor:UIColor.mainColor]];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveAction:(id)sender {
    kWeakSelf(self);
    [self.sessionManager mc_Post_QingQiuTi:@"facade/app/coin/address/add" parameters:@{@"username":self.shouhuorenTf.text,
                                                                                       @"phone":@"王沛",
                                                                                       @"province":@"浙江省",
                                                                                       @"city":@"杭州市",
                                                                                       @"district":@"西湖区",
                                                                                       @"detail":@"发展大厦12楼",
                                                                                       @"zipcode":@""
                                                                                       
    } ok:^(MCNetResponse * _Nonnull resp) {
        [weakself.navigationController popViewControllerAnimated:YES];
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
    } failure:^(NSError * _Nonnull error) {
        [MCLoading hidden];
    }];
}
@end
