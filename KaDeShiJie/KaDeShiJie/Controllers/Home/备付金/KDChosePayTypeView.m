//
//  KDChosePayTypeView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDChosePayTypeView.h"
#import "KDChosePayTypeViewCell.h"


@interface KDChosePayTypeView ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<KDChosePayTypeModel *> *dataArray;
@end

@implementation KDChosePayTypeView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self requestCards];
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDChosePayTypeView" owner:nil options:nil] lastObject];
    }
    return self;
}

// 取消按钮
- (IBAction)cancenBtnAction:(id)sender {
    if (self.hideView) {
        self.hideView();
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDChosePayTypeViewCell *cell = [KDChosePayTypeViewCell cellWithTableView:tableView];
    KDChosePayTypeModel *model = self.dataArray[indexPath.row];
    cell.nameView.text = model.name;
    if (model.des.length != 0) {
        cell.desView.text = model.des;
    } else {
        cell.desView.hidden = YES;
    }
    cell.iconView.image = model.icon;
    cell.typeView.hidden = !model.select;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDChosePayTypeModel *model = self.dataArray[indexPath.row];
    if (model.type == 1) {
        MCCardManagerController *vc = [[MCCardManagerController alloc] init];
        vc.titleString = @"选择储蓄卡";
        [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
    } else {
        if (self.callBack) {
            self.callBack(model, model.name);
        }
    }
}
- (void)requestCards {
    __weak __typeof(self)weakSelf = self;
    [[MCSessionManager shareManager] mc_GET:[NSString stringWithFormat:@"/user/app/bank/query/userid/%@",TOKEN] parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *temArr = [MCBankCardModel mj_objectArrayWithKeyValuesArray:resp.result];
        for (MCBankCardModel *model in temArr) {
            if ([model.nature containsString:@"借"]) {
                KDChosePayTypeModel *typeModel = [[KDChosePayTypeModel alloc] init];
                NSString *cardNo = [model.cardNo substringFromIndex:model.cardNo.length - 4];
                typeModel.name = [NSString stringWithFormat:@"%@(%@)", model.bankName, cardNo];
                MCBankCardInfo *info = [MCBankStore getBankCellInfoWithName:model.bankName];
                typeModel.icon = info.logo;
                if ([self.bankName containsString:model.bankName]) {
                    typeModel.select = YES;
                } else {
                    typeModel.select = NO;
                }
                typeModel.type = 2;
                typeModel.des = @"";
                [self.dataArray addObject:typeModel];
            }
        }
        
        [[MCModelStore shared] getUserAccount:^(MCAccountModel * _Nonnull accountModel) {
            KDChosePayTypeModel *balanceModel = [[KDChosePayTypeModel alloc] init];
            balanceModel.name = [NSString stringWithFormat:@"账户余额(剩余:¥%.2f)", accountModel.balance.floatValue];
            balanceModel.des = [NSString stringWithFormat:@"最多可用%.2f元", accountModel.balance.floatValue];
            balanceModel.type = 0;
            if ([self.bankName containsString:@"账户余额"]) {
                balanceModel.select = YES;
            } else {
                balanceModel.select = NO;
            }
            balanceModel.icon = [UIImage imageNamed:@"kd_provisions_chose_balance"];
            [self.dataArray addObject:balanceModel];
            
            KDChosePayTypeModel *addModel = [[KDChosePayTypeModel alloc] init];
            addModel.name = @"添加银行卡付款";
            addModel.des = @"该交易仅支持储蓄卡";
            addModel.type = 1;
            if ([self.bankName isEqualToString:@"添加银行卡付款"]) {
                addModel.select = YES;
            } else {
                addModel.select = NO;
            }
            addModel.icon = [UIImage imageNamed:@"kd_provisions_chose_add"];
            [self.dataArray addObject:addModel];
            
            [weakSelf.tableView reloadData];
        }];
    }];
}
@end
