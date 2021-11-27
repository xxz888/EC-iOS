//
//  MCCardManagerController1.m
//  MCOEM
//
//  Created by wza on 2020/4/24.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCCardManagerController1.h"
#import "MCBankCardCell.h"
#import "MCBankCardModel.h"
#import "MCWalletView.h"
#import "KDCommonAlert.h"

@interface MCCardManagerController1 ()<MCSegementViewDelegate, MCWalletViewDelegate>

@property(nonatomic, strong) MCSegementView *segView;
@property(nonatomic, strong) QMUIButton *addButton;

@property(nonatomic, strong) NSMutableArray<MCBankCardModel *> *daijikas;
@property(nonatomic, strong) NSMutableArray<MCBankCardModel *> *jiejikas;

@property(nonatomic, assign) NSInteger currentIndex;

@property(nonatomic, strong) MCWalletView *walletView;

@end

@implementation MCCardManagerController1
- (MCWalletView *)walletView {
    if (!_walletView) {
        _walletView = [[MCWalletView alloc] initWithFrame:CGRectMake(0, NavigationContentTop+self.segView.qmui_height+10, SCREEN_WIDTH, SCREEN_HEIGHT-self.segView.qmui_bottom-self.addButton.qmui_height)];
        _walletView.delegate = self;
    }
    return _walletView;
}
- (NSMutableArray<MCBankCardModel *> *)daijikas {
    if (!_daijikas) {
        _daijikas = [NSMutableArray new];
    }
    return _daijikas;
}
- (NSMutableArray<MCBankCardModel *> *)jiejikas {
    if (!_jiejikas) {
        _jiejikas = [NSMutableArray new];
    }
    return _jiejikas;
}

- (QMUIButton *)addButton {
    if (!_addButton) {
        _addButton = [[QMUIButton alloc] qmui_initWithImage:[UIImage mc_imageNamed:@"one_bankcard_add"] title:@"添加银行卡"];
        CGFloat height = 50*MCSCALE;
        _addButton.frame = CGRectMake(0, SCREEN_HEIGHT-height, SCREEN_WIDTH, height);
        [_addButton setTitleColor:UIColorGray forState:UIControlStateNormal];
        _addButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_addButton addTarget:self action:@selector(addButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}
- (MCSegementView *)segView {
    if (!_segView) {
        _segView = [[MCSegementView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, 45)];
        _segView.titles = @[@"信用卡", @"储蓄卡"];
        _segView.delegate = self;
    }
    return _segView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"银行卡管理" tintColor:nil];
    
    [self.view addSubview:self.segView];
    [self.view addSubview:self.walletView];
    [self.view addSubview:self.addButton];
    
    [self requestCards];
}



#pragma mark - Actions
- (void)requestCards {
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_GET:[NSString stringWithFormat:@"/user/app/bank/query/userid/%@",TOKEN] parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        //MCLog(@"%@",resp.result);
        NSArray *temArr = [MCBankCardModel mj_objectArrayWithKeyValuesArray:resp.result];
        [weakSelf.daijikas removeAllObjects];
        [weakSelf.jiejikas removeAllObjects];
        for (MCBankCardModel *model in temArr) {
            if ([model.nature containsString:@"借"]) {
                [weakSelf.jiejikas addObject:model];
            }
            if ([model.nature containsString:@"贷"]) {
                [weakSelf.daijikas addObject:model];
            }
        }
        if (weakSelf.currentIndex == 0) {
            weakSelf.walletView.dataSource = weakSelf.jiejikas;
        } else {
            weakSelf.walletView.dataSource = weakSelf.daijikas;
        }
    }];
}
- (void)addButtonTouched:(QMUIButton *)sender {
    MCBankCardType type = (self.currentIndex == 0)?MCBankCardTypeXinyongka:MCBankCardTypeChuxuka;
    [MCPagingStore pagingURL:rt_card_edit withUerinfo:@{@"type":@(type)}];
}

#pragma mark - MCSegementViewDelegate

- (void)segementViewDidSeletedIndex:(NSInteger)index buttonTitle:(NSString *)title {
    
    [self.addButton setTitle:[NSString stringWithFormat:@"添加%@",title] forState:UIControlStateNormal];
    self.currentIndex= index;
    [self requestCards];
}
#pragma mark - MCWalletViewDelegate

- (void)walletViewDidSelectedAction:(MCBankCardCellActionType)type model:(MCBankCardModel *)model {
    
    if (type == MCBankCardCellActionDefault) {
        
    } else if (type == MCBankCardCellActionModify) {
        MCBankCardType cardType = (self.currentIndex == 0)?MCBankCardTypeXinyongka:MCBankCardTypeChuxuka;
        [MCPagingStore pagingURL:rt_card_edit withUerinfo:@{@"type":@(cardType), @"model":model}];
    } else if (type == MCBankCardCellActionDelete) {
        
        KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
        [commonAlert initKDCommonAlertContent:@"确定要解绑此银行卡吗？"  isShowClose:NO];
        commonAlert.rightActionBlock = ^{
            __weak __typeof(self)weakSelf = self;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/bank/del/%@",TOKEN] parameters:@{@"cardno":model.cardNo,@"type":model.type} ok:^(MCNetResponse * _Nonnull resp) {
                    [weakSelf requestCards];
                }];
                 });
       
        };
        
        
//        QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要解绑此银行卡吗？" preferredStyle:QMUIAlertControllerStyleAlert];
//        [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
//        [alert addAction:[QMUIAlertAction actionWithTitle:@"解绑" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
//            __weak __typeof(self)weakSelf = self;
//            [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/bank/del/%@",TOKEN] parameters:@{@"cardno":model.cardNo,@"type":model.type} ok:^(MCNetResponse * _Nonnull resp) {
//                [weakSelf requestCards];
//            }];
//        }]];
//        [alert showWithAnimated:YES];
        
    }
}

@end
