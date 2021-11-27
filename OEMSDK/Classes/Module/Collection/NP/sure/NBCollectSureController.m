//
//  NBCollectSureController.m
//  Project
//
//  Created by Li Ping on 2019/7/3.
//  Copyright © 2019 LY. All rights reserved.
//

#import "NBCollectSureController.h"
#import "NBCollectSureHeader.h"
#import "MCCashierChooseCard.h"
#import "MCChooseCardModel.h"
#import "KDCommonAlert.h"

@interface NBCollectSureController ()<CollectSureHeaderDelegate, MCCashierChooseCardDelegate>

//@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NBCollectSureHeader *headView;
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
//储蓄卡
@property (nonatomic, strong) MCChooseCardModel *bankCardModel;

@property(nonatomic, strong) MCCashierChooseCard *chooseCard;

@end

@implementation NBCollectSureController
#pragma mark - Getter & Setter
- (MCCashierChooseCard *)chooseCard {
    if (!_chooseCard) {
        _chooseCard = [[MCCashierChooseCard alloc] initWithType:MCCashierChooseCardChuxu];
        _chooseCard.delegate = self;
    }
    return _chooseCard;
}
- (void)setBankCardModel:(MCChooseCardModel *)bankCardModel {
    _bankCardModel = bankCardModel;
    if (bankCardModel.province == nil || bankCardModel.city == nil) {
        
        
        kWeakSelf(self);
        KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
        [commonAlert initKDCommonAlertContent:@"您的银行卡信息填写不完整，请补充完整"  isShowClose:NO];
        commonAlert.rightActionBlock = ^{
            MCBankCardModel *mm = [MCBankCardModel mj_objectWithKeyValues:bankCardModel.mj_keyValues];

             NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
             [info setObject:@"type" forKey:@(MCBankCardTypeXinyongka)];
             if (mm) {
                 [info setObject:mm forKey:@"model"];
             }
             [MCPagingStore pagingURL:rt_card_edit withUerinfo:info];
        };
        
        
//        [MCAlertStore showWithTittle:@"温馨提示" message:@"您的银行卡信息填写不完整，请补充完整" buttonTitles:@[@"我知道了", @"完善信息"] sureBlock:^{
//           MCBankCardModel *mm = [MCBankCardModel mj_objectWithKeyValues:bankCardModel.mj_keyValues];
//
//            NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
//            [info setObject:@"type" forKey:@(MCBankCardTypeXinyongka)];
//            if (mm) {
//                [info setObject:mm forKey:@"model"];
//            }
//            [MCPagingStore pagingURL:rt_card_edit withUerinfo:info];
//
//        }];
    }
}
#pragma mark - Life
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self fetchDefaultBankCard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
#pragma mark - Private
- (void)setupUI {
    [self setNavigationBarTitle:@"NP收款" tintColor:nil];
    
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop - TabBarHeight - 70)];
    [self.view addSubview:contentView];
    
    NBCollectSureHeader *head = [[[NSBundle OEMSDKBundle] loadNibNamed:@"NBCollectSureHeader" owner:nil options:nil] lastObject];
    head.delegate = self;
    [contentView addSubview:head];
    contentView.contentSize = CGSizeMake(0, head.ly_height);
    
    self.headView = head;
    head.findModel = self.findCardModel;
    
    self.lastBtn.layer.cornerRadius = 20;
    self.lastBtn.layer.masksToBounds = YES;
}
#pragma mark - Actions
- (IBAction)onSureTouched:(id)sender {
    [self requestDataForGathering];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

#pragma mark - CollectSureHeaderDelegate
- (void)collectSureHeaderAction:(NSInteger)tag
{
    switch (tag) {
        case 0:
        {
            [self.chooseCard show];
        }
            break;
        case 1:
        {
            if (self.bankCardModel != nil) {
                
                
                kWeakSelf(self);
                KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
                [commonAlert initKDCommonAlertContent:@"是否前去完善修改储蓄卡开户地信息"  isShowClose:NO];
                commonAlert.rightActionBlock = ^{
                    // 选择城市
                    MCBankCardModel *mm = [MCBankCardModel mj_objectWithKeyValues:self.bankCardModel.mj_keyValues];
                    
                    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
                    [info setObject:@(MCBankCardTypeXinyongka) forKey:@"type"];
                    if (mm) {
                        [info setObject:mm forKey:@"model"];
                    }
                    [MCPagingStore pagingURL:rt_card_edit withUerinfo:info];
                };
                
                
//                [MCAlertStore showWithTittle:@"温馨提示" message:@"是否前去完善修改储蓄卡开户地信息" buttonTitles:@[@"下次再说", @"前去完善"] sureBlock:^{
//                    // 选择城市
//                    MCBankCardModel *mm = [MCBankCardModel mj_objectWithKeyValues:self.bankCardModel.mj_keyValues];
//
//                    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
//                    [info setObject:@(MCBankCardTypeXinyongka) forKey:@"type"];
//                    if (mm) {
//                        [info setObject:mm forKey:@"model"];
//                    }
//                    [MCPagingStore pagingURL:rt_card_edit withUerinfo:info];
//
//                }];
            } else {
                
                kWeakSelf(self);
                KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
                [commonAlert initKDCommonAlertContent:@"您暂未在系统内添加银行卡信息，请前往添加!"  isShowClose:NO];
                commonAlert.rightActionBlock = ^{
                    [MCPagingStore pagingURL:rt_card_edit withUerinfo:@{@"type":@(MCBankCardTypeChuxuka)}];
                };
                
                
//                [MCAlertStore showWithTittle:@"温馨提示" message:@"您暂未在系统内添加银行卡信息，请前往添加!" buttonTitles:@[@"我知道了", @"添加银行卡"] sureBlock:^{
//                    [MCPagingStore pagingURL:rt_card_edit withUerinfo:@{@"type":@(MCBankCardTypeChuxuka)}];
//                }];
            }
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - MCCashierChooseCardDelegate
- (void)cashierChoose:(MCCashierChooseCard *)choose DidSelectedCard:(MCChooseCardModel *)cardInfo {
    self.bankCardModel = cardInfo;
}

#pragma mark - Request
///获取默认银行卡
- (void)fetchDefaultBankCard {
    
    NSDictionary *p2 = @{@"userId":SharedUserInfo.userid,
                         @"type":@"2",
                         @"nature":@"2",
                         @"isDefault":@"1"};
    __weak __typeof(self)weakSelf = self;
    [MCLATESTCONTROLLER.sessionManager mc_POST:@"/user/app/bank/query/byuseridandtype/andnature" parameters:p2 ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *temp = [MCChooseCardModel mj_objectArrayWithKeyValuesArray:resp.result];
        for (MCChooseCardModel *model in temp) {
            weakSelf.bankCardModel = model;
            break;
        }
    }];
}

- (void)requestDataForGathering {
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *gatheringDic = @{@"amount":self.findCardModel.money,
                                   @"orderDesc":self.findCardModel.channel.name,
                                   @"phone":SharedUserInfo.phone,
                                   @"channeTag":self.findCardModel.channelTag,
                                   @"bankCard":self.findCardModel.bankCard,
                                   @"brandId":SharedConfig.brand_id,
                                   @"userId":SharedUserInfo.userid,
                                   @"creditBankName":self.xykModel.bankName
                                   };
    
    [MCSessionManager.shareManager mc_POST:@"/facade/app/topup/new" parameters:gatheringDic ok:^(MCNetResponse * _Nonnull resp) {
        [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":resp.result, @"title":@"快捷支付"}];
    }];
}



@end
