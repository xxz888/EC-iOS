//
//  KDHomeHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/5.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDHomeHeaderView.h"
#import "KDMsgViewCell.h"
#import "KDProvisionsViewController.h"
#import "KDTopDelegateViewController.h"
#import "KDCreditManagerViewController.h"
#import "KDEarnCenterViewController.h"
#import "KDGatheringViewController.h"
#import <MCMessageModel.h>
#import "KDDirectRefundViewController.h"

#import <OEMSDK/MCWebViewController.h>
#import "KDWebContainer.h"
#import "KDCreditModel.h"
#import "KDKongKaViewController.h"
#import "KDHomeXinYongKaViewController.h"
@interface KDHomeHeaderView ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIStackView *topView;
@property (weak, nonatomic) IBOutlet UIStackView *centerView;
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UIView *msgContentView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHigCons;
@property (weak, nonatomic) IBOutlet MCBannerView *bannerView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SDCycleScrollView *cyView;
@end

@implementation KDHomeHeaderView

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    for (QMUIButton *btn in self.topView.subviews) {
        btn.imagePosition = QMUIButtonImagePositionTop;
    }
    
    NSArray *titleArray = @[@"顶级代理", @"信用管理", @"收益中心", @"信用卡办卡"];
    for (int i = 0; i < 4; i++) {
        QMUIButton *btn = [self.centerView viewWithTag: 200 + i];
        btn.imagePosition = QMUIButtonImagePositionTop;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"kd_home_bottom_%d", i]] forState:UIControlStateNormal];
    }
    
    self.contentView.layer.cornerRadius = 30;
    self.msgContentView.layer.cornerRadius = 10;
    self.lineView.layer.cornerRadius = 2.3;
    __weak typeof(self) weakSelf = self;
    self.bannerView.resetHeightBlock = ^(CGFloat h) {
        weakSelf.bannerHigCons.constant = h;
        if (self.callBack) {
            self.callBack(661 - 128 + h);
        }
    };
    
    SDCycleScrollView *cyView = [[SDCycleScrollView alloc] initWithFrame:self.msgView.bounds];
    cyView.delegate = self;
    cyView.backgroundColor = [UIColor clearColor];
    cyView.showPageControl = NO;
    cyView.clipsToBounds = YES;
    [cyView disableScrollGesture];
//    cyView.imageURLStringsGroup = self.dataArray;
    cyView.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.msgView addSubview:cyView];
    self.cyView = cyView;
    [self getMessage];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDHomeHeaderView" owner:nil options:nil] firstObject];
    }
    return self;
}
- (IBAction)btnAction:(QMUIButton *)sender {
    if (sender.tag == 100 || sender.tag == 101 || sender.tag == 102) {
            switch (sender.tag) {
                case 100:
                {
                    
                    
//                    原生信用卡还款界面
                    KDDirectRefundViewController * vc = [[KDDirectRefundViewController alloc]init];
                    vc.navTitle = @"信用卡还款";
                    //订单类型（2为还款记录、3为空卡记录）
                    vc.orderType = @"2";
                    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 101:
                {
                    //------原生信用卡还款界面
                    KDKongKaViewController * vc = [[KDKongKaViewController alloc]init];
                    vc.navTitle = @"空卡还款";
                    //订单类型（2为还款记录、3为空卡记录）
                    vc.orderType = @"3";
                    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 102:
                    [MCLATESTCONTROLLER.navigationController pushViewController:[KDGatheringViewController new] animated:YES];
                    break;
                default:
                    break;
        }
      
  
    }else{
        switch (sender.tag) {
            case 200: // 顶级代理
                [MCLATESTCONTROLLER.navigationController pushViewController:[KDTopDelegateViewController new] animated:YES];
                break;
            case 201: // 信用管理
                [MCLATESTCONTROLLER.navigationController pushViewController:[KDCreditManagerViewController new] animated:YES];
                break;
            case 202: // 收益中心
                [MCLATESTCONTROLLER.navigationController pushViewController:[KDEarnCenterViewController new] animated:YES];
                break;
            case 203:
//                [MCToast showMessage:@"网申渠道更新"];
//                [MCPagingStore pushWebWithTitle:@"信用卡办卡" classification:@"功能跳转"];
                [MCLATESTCONTROLLER.navigationController pushViewController:[KDHomeXinYongKaViewController new] animated:YES];

                
                break;
            case 204:
                
                break;
            case 205:
                
                break;
            case 206: // 备付金
                [MCLATESTCONTROLLER.navigationController pushViewController:[KDProvisionsViewController new] animated:YES];
                break;
            case 207:
                
                break;
                
            default:
                break;
        }
    }

   
}

#pragma mark - SDCycleScrollViewDelegate
- (UINib *)customCollectionViewCellNibForCycleScrollView:(SDCycleScrollView *)view
{
    UINib *nib = [UINib nibWithNibName:@"KDMsgViewCell" bundle:[NSBundle mainBundle]];
    return nib;
}
- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view
{
    MCMessageModel *model = self.dataArray[index];
    KDMsgViewCell *myCell = (KDMsgViewCell *)cell;
    myCell.topLabel.text = [NSString stringWithFormat:@"%@%@", model.title, model.createTime];
    myCell.centerLabel.text = model.content;
    
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    [MCPagingStore pagingURL:rt_notice_list];
}
- (void)getMessage {
    [MCLATESTCONTROLLER.sessionManager mc_GET:[NSString stringWithFormat:@"/user/app/jpush/history/brand/%@",TOKEN] parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        for (NSDictionary *dic in resp.result[@"content"]) {
            if (![dic[@"btype"] isEqualToString:@"androidVersion"]) { // 过滤安卓消息
                self.dataArray = [MCMessageModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]];
//                self.dataArray = [NSMutableArray arrayWithArray:@[@"1", @"2", @"3", @"4", @"5", @"6"]];
                self.cyView.localizationImageNamesGroup = self.dataArray;
                break;
            }
        }
    }];
}

- (void)pushTopDelegateVC
{
    [MCLATESTCONTROLLER.sessionManager mc_POST:@"/transactionclear/app/standard/extension/user/query" parameters:@{@"userId":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull resp) {
        NSDictionary *dict = resp.result;
        if (dict.allKeys != 0) {
            NSInteger grade = [dict[@"promotionLevelId"] intValue];
            if (grade < 3) {
                [MCToast showMessage:@"您当前不是顶级代理，无法进入"];
            } else {
                [MCLATESTCONTROLLER.navigationController pushViewController:[KDTopDelegateViewController new] animated:YES];
            }
        } else {
            [MCToast showMessage:@"您当前不是顶级代理，无法进入"];
        }
    }];
}
@end
