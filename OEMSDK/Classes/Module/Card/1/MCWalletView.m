//
//  MCWalletView.m
//  MCOEM
//
//  Created by wza on 2020/6/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCWalletView.h"
#import "MCWalletLayout.h"


@interface MCWalletView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *collectionView;

/// 当前展开项，-1表示全部收拢
@property(nonatomic, assign) NSInteger expandIndexItem;


@end

@implementation MCWalletView

- (void)setDataSource:(NSArray<MCBankCardModel *> *)dataSource {
    _dataSource = dataSource;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 0)];
    [self.collectionView deleteSections:indexSet];
    self.expandIndexItem = -1;
    [self.collectionView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        MCWalletLayout *layout = [[MCWalletLayout alloc] init];
        _collectionView.collectionViewLayout = layout;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColorWhite;
        [_collectionView registerNib:[UINib nibWithNibName:@"MCWalletCollectionViewCell" bundle:[NSBundle OEMSDKBundle]] forCellWithReuseIdentifier:@"MCWalletCollectionViewCell"];
    }
    return _collectionView;
}


- (void)initConfig {
    
    [self addSubview:self.collectionView];
    
}

- (void)handleDefault:(MCBankCardModel *)model indexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self)weakSelf = self;
    [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/bank/default/%@",TOKEN] parameters:@{@"cardno":model.cardNo} ok:^(MCNetResponse * _Nonnull resp) {
        
        NSInteger deIndex = 0;
        for (int i=0; i<self.dataSource.count; i++) {
            MCBankCardModel *mm = weakSelf.dataSource[i];
            if (mm.idDef) {
                mm.idDef = NO;
                
                deIndex = i;
                break;
            }
        }
        model.idDef = YES;
        MCWalletCollectionViewCell *c1 = (MCWalletCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        if (c1) {
            c1.model = model;
        }
        MCWalletCollectionViewCell *c2 = (MCWalletCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:deIndex inSection:0]];
        if (c2) {
            c2.model = self.dataSource[deIndex];
        }
    }];
}

#pragma mark - collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MCWalletCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MCWalletCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    __weak __typeof(self)weakSelf = self;
    cell.block = ^(MCBankCardCellActionType type, MCBankCardModel * _Nonnull model) {
        if (type == MCBankCardCellActionDefault) {
            if (model.idDef) {
                [MCToast showMessage:@"已经是默认卡"];
            } else {
                [weakSelf handleDefault:model indexPath:indexPath];
            }
        } else if (type == MCBankCardCellActionModify) {
            [weakSelf.delegate walletViewDidSelectedAction:type model:model];
        } else if (type == MCBankCardCellActionDelete) {
            if (weakSelf.delegate) {
                [weakSelf.delegate walletViewDidSelectedAction:type model:model];
            }
        }
        
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MCLog(@"didSelectItemAtIndexPath:%ld",indexPath.row);
    MCWalletCollectionViewCell *cell = (MCWalletCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.expandIndexItem == -1) { //全部收拢状态
        cell.isExpand = YES;
        self.expandIndexItem = indexPath.row;
    } else {    //有展开项
        if (cell.isExpand) {    //展开项是当前,将要全部收拢
            cell.isExpand = NO;
            self.expandIndexItem = -1;
        } else {    //展开项不是当前，将要全部收拢
            cell.isExpand = NO;
            self.expandIndexItem = -1;
        }
    }
    cell.actionView.hidden = !cell.isExpand;
    [collectionView performBatchUpdates:^{
    } completion:^(BOOL finished) {
    }];
}

- (void)setExpandIndexItem:(NSInteger)expandIndexItem {
    //展示箭头的位置
    NSInteger index ;
    if (expandIndexItem == -1) {
        index = _expandIndexItem;
    } else {
        index = expandIndexItem;
    }
    
    
    MCWalletCollectionViewCell *currentCell = (MCWalletCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    
    MCWalletCollectionViewCell *nextCell = (MCWalletCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index+1 inSection:0]];
    if (nextCell) {
        nextCell.topImgView.hidden = !nextCell.topImgView.hidden;
    }
    
    
    
    
    _expandIndexItem = expandIndexItem;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    MCLog(@"反选:%ld",indexPath.row);
    MCWalletCollectionViewCell *cell = (MCWalletCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        //反选，全部收拢
        cell.isExpand = NO;
    }
}



@end
