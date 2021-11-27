//
//  KDJFShopHeaderCollectionReusableView.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/8.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFShopHeaderCollectionReusableView.h"
#import "KDJFChangeViewController.h"

@interface KDJFShopHeaderCollectionReusableView()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cyView;
@end
@implementation KDJFShopHeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    ViewRadius(self.personImv, 15);
    SDCycleScrollView *cyView = [[SDCycleScrollView alloc] initWithFrame:self.lunboView.bounds];
    cyView.delegate = self;
    cyView.backgroundColor = [UIColor clearColor];
    cyView.showPageControl = YES;
    cyView.clipsToBounds = YES;
    [cyView disableScrollGesture];
    cyView.imageURLStringsGroup = @[@"http://rongcloud-web.qiniudn.com/docs_demo_rongcloud_logo.png",@"http://www.baidu.com/img/bdlogo.png"];
    cyView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.lunboView addSubview:cyView];
    self.cyView = cyView;
    
    [self.personImv sd_setImageWithURL:[NSURL URLWithString:SharedUserInfo.headImvUrl]];
    self.personTitle.text = SharedUserInfo.realname;
    [self requestJiFenData];
    //添加手势
    self.jifenView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickNoAdressAction:)];
    [self.jifenView addGestureRecognizer:tap];
}
-(void)clickNoAdressAction:(id)tap{
    [MCLATESTCONTROLLER.navigationController pushViewController:[KDJFChangeViewController new] animated:YES];

}
//查询积分
-(void)requestJiFenData{
    kWeakSelf(self);
    
    [MCLATESTCONTROLLER.sessionManager mc_Post_QingQiuTi:@"user/app/coin/get" parameters:@{} ok:^(MCNetResponse * _Nonnull resp) {
        weakself.jifenLbl.text = [NSString stringWithFormat:@"%@",resp.result];
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
    } failure:^(NSError * _Nonnull error) {
        [MCLoading hidden];
    }];
}
@end
