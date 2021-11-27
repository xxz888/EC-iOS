//
//  MCVipViewController.m
//  OEMSDK-OEMSDK
//
//  Created by SS001 on 2020/7/21.
//

#import "MCVipViewController.h"
#import "ZAShopsModel.h"
#import "ZAGoodsModel.h"
#import "ZABuyViewController.h"
#import "ZAOrderViewController.h"

@interface MCVipViewController ()<QMUITableViewDataSource, QMUITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *goodsArray;
@end

@implementation MCVipViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)goodsArray
{
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:@"礼包" tintColor:[UIColor mainColor]];
    
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    QMUIButton *rightBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"订单" forState:UIControlStateNormal];
    rightBtn.spacingBetweenImageAndTitle = 5;
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage mc_imageNamed:@"icon_ak_bill"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = LYFont(15);
    [rightBtn addTarget:self action:@selector(orderAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self initData];
    [self initGoodsData];
}

- (void)orderAction
{
    ZAOrderViewController *orderVC = [[ZAOrderViewController alloc] init];
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    head.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return head;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell_vip";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 120)];
    bgImg.layer.cornerRadius = 10;
    bgImg.layer.masksToBounds = YES;
    [cell.contentView addSubview:bgImg];
    
    ZAShopsModel *model = self.dataArray[indexPath.section];
    [bgImg sd_setImageWithURL:[NSURL URLWithString:model.lowSource]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZAShopsModel *shopModel = self.dataArray[indexPath.section];
    ZAGoodsModel *goodsModel = [ZAGoodsModel new];
    for (ZAGoodsModel *model in self.goodsArray) {
        if (model.grade == [shopModel.onOff integerValue]) {
            model.remark = shopModel.lowSource;
            goodsModel = model;
            model.name = shopModel.title;
            break;
        }
    }
    
    ZABuyViewController *buyVC = [[ZABuyViewController alloc] init];
    buyVC.goodsModel = goodsModel;
    [self.navigationController pushViewController:buyVC animated:YES];
}

#pragma mark - 数据请求
- (void)initData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"0" forKey:@"page"];
    [params setValue:@"100" forKey:@"size"];
    [params setValue:@"会员商城" forKey:@"classifiCation"];
    [params setValue:MCModelStore.shared.brandConfiguration.brand_id forKey:@"brandId"];
    [self.sessionManager mc_POST:@"/user/app/news/getnewsby/brandidandclassification/andpage" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        self.dataArray = [ZAShopsModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]];
        [self.mc_tableview reloadData];
    }];
    
}
- (void)initGoodsData
{
    NSString *url = [NSString stringWithFormat:@"/user/app/thirdlevel/prod/brand/%@", MCModelStore.shared.brandConfiguration.brand_id];
    [self.sessionManager mc_GET:url parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        self.goodsArray = [ZAGoodsModel mj_objectArrayWithKeyValuesArray:resp.result];
        NSLog(@"%@",  resp.result);
    }];
    
}

@end
