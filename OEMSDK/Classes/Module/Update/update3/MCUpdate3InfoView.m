//
//  MCUpdate3InfoView.m
//  Pods
//
//  Created by wza on 2020/7/31.
//

#import "MCUpdate3InfoView.h"
#import "MCFeilvModel.h"
#import "MCUpdate3FeilvCell.h"

@interface MCUpdate3InfoView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@property (weak, nonatomic) IBOutlet UILabel *proDescLab;
@property (weak, nonatomic) IBOutlet UILabel *feilvDescLab;

@property (weak, nonatomic) IBOutlet UITableView *feilvTab;

@property(nonatomic, strong) NSMutableArray<NSMutableArray<MCFeilvModel *> *> *dataSource;

//@property(nonatomic, strong) NSMutableArray<MCFeilvModel *> *hkSource;
//@property(nonatomic, strong) NSMutableArray<MCFeilvModel *> *sySource;


@end


@implementation MCUpdate3InfoView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lab1.textColor = MAINCOLOR;
    self.lab2.textColor = MAINCOLOR;
    self.lab3.textColor = MAINCOLOR;
    
    if (self.button1.imageView.image) {
        [self.button1 setImage:[self.button1.imageView.image imageWithColor:MAINCOLOR] forState:UIControlStateNormal];
    }
    if (self.button2.imageView.image) {
        [self.button2 setImage:[self.button2.imageView.image imageWithColor:MAINCOLOR] forState:UIControlStateNormal];
    }
    
    [self setupTable];
    
}
- (void)setProductModel:(MCProductModel *)productModel {
    _productModel = productModel;
    [self requestFeilvWithProductID:productModel.ID];
    
    self.proDescLab.text = productModel.upgradestate;
    self.feilvDescLab.text = productModel.earningsState.length < 6 ? @"暂无说明" : productModel.earningsState;
}

- (NSMutableArray<NSMutableArray<MCFeilvModel *> *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (void)setupTable {
    self.feilvTab.dataSource = self;
    self.feilvTab.delegate = self;
    self.feilvTab.rowHeight = 25.f;
    self.feilvTab.scrollEnabled = NO;
    self.feilvTab.separatorStyle = UITableViewCellSeparatorStyleNone;
}



- (void)requestFeilvWithProductID:(NSString *)productId {
    
    NSDictionary *param = @{@"thirdLevelId":productId};
    __weak __typeof(self)weakSelf = self;
    [MCLATESTCONTROLLER.sessionManager mc_POST:@"/user/app/thirdlevel/rate/query/thirdlevelid/" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.dataSource removeAllObjects];
        NSArray *tempArr = [MCFeilvModel mj_objectArrayWithKeyValuesArray:resp.result];
        NSMutableArray *tempHuankuan = [NSMutableArray new];
        NSMutableArray *tempShoukuan = [NSMutableArray new];
        for (MCFeilvModel *model in tempArr) {
            if ([model.subName containsString:@"还款"]) {
                [tempHuankuan addObject:model];
            } else if (model.status.intValue == 1 || model.channelNo.intValue == 1 || model.channelNo.intValue == 2 || model.channelNo.intValue == 5) {
                [tempShoukuan addObject:model];
            }
        }
        [weakSelf.dataSource addObject:tempHuankuan];
        [weakSelf.dataSource addObject:tempShoukuan];
        [weakSelf.feilvTab reloadData];
        
        weakSelf.qmui_height = weakSelf.feilvDescLab.qmui_bottom+100;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /// 最多展示3个
    if (self.dataSource.count == 0) {
        return 0;
    }
    NSInteger row = MAX(self.dataSource[0].count, self.dataSource[1].count);
    return row>3 ? 3 : row;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MCUpdate3FeilvCell *cell = [MCUpdate3FeilvCell cellWithTableView:tableView];
    
    if (self.dataSource[0].count > indexPath.row) {
        MCFeilvModel *model = self.dataSource[0][indexPath.row];
        cell.feilvLab1.text = [NSString stringWithFormat:@"%.2f%% %@(%@)",model.rate.floatValue*100,model.channelParams,model.name];
    } else {
        cell.feilvLab1.text = @"";
    }
    
    if (self.dataSource[1].count > indexPath.row) {
        MCFeilvModel *model = self.dataSource[1][indexPath.row];
        cell.feilvLab2.text = [NSString stringWithFormat:@"%.2f%% %@(%@)",model.rate.floatValue*100,model.channelParams,model.name];
    } else {
        cell.feilvLab2.text = @"";
    }
    
    return cell;
}
- (IBAction)showMore:(id)sender {
//    [MCPagingStore pagingURL:rt_rate_myrate];
}

- (IBAction)btn1Touched:(id)sender {
    [MCPagingStore pagingURL:rt_share_single];
}
- (IBAction)btn2Touched:(id)sender {
    [MCPagingStore pushWebWithTitle:@"收益导图" classification:@"功能跳转"];
}

@end
