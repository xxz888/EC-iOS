//
//  KDJFShopDetailViewController.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/8.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFShopDetailViewController.h"
#import "KDJFShopDetailHeaderView.h"
#import "KDJFShopDetailTableViewCell.h"
#import "KDConfirmViewController.h"

@interface KDJFShopDetailViewController ()<QMUITableViewDataSource, QMUITableViewDelegate>
@property (nonatomic, strong) KDJFShopDetailHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UIView * footView;

@end

@implementation KDJFShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setNavigationBarTitle:@"商品详情" backgroundImage:[UIImage qmui_imageWithColor:UIColor.mainColor]];


    self.mc_tableview.backgroundColor = [UIColor whiteColor];
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
//    self.mc_tableview.rowHeight = UITableViewAutomaticDimension; //
//    self.mc_tableview.estimatedRowHeight = 100;
    __weak typeof(self) weakSelf = self;
    [self.view addSubview:self.footView];
//    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        [weakSelf.mc_tableview.mj_header endRefreshing];
//    }];

    [self getDetailData];
    
    
    [self.headerView.detailImv sd_setImageWithURL:self.goodDic[@"primaryMessage"]];
    self.headerView.detailTitle.text = self.goodDic[@"name"];
    self.headerView.detailPrice.text = [NSString stringWithFormat:@"%@积分+%@元",self.goodDic[@"priceCoin"],self.goodDic[@"priceMoney"]];
    self.headerView.detailKuCun.text = [NSString stringWithFormat:@"库存:%@",self.goodDic[@"stock"]];

    self.headerView.detailTitle1.text = self.goodDic[@"name"];
}
- (KDJFShopDetailHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[KDJFShopDetailHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 323);

    }


    return _headerView;
}
-(UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 70 , KScreenWidth, 70)];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 5 , KScreenWidth-20, 33);
        button.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [button setTitleColor:KWhiteColor forState:0];
        [button setBackgroundColor:UIColor.mainColor];
        [button setTitle:@"购买" forState:0];
        ViewRadius(button, 5);
        [_footView addSubview:button];
        
        [button addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _footView;
}
-(void)buyAction:(UIButton *)btn{
    KDConfirmViewController * vc = [[KDConfirmViewController alloc]init];
    vc.goodDic = [NSDictionary dictionaryWithDictionary:self.goodDic];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)getDetailData{
    kWeakSelf(self);
    [[MCSessionManager shareManager] mc_GET:[NSString stringWithFormat:@"facade/app/coin/goods/detail"] parameters:@{@"gid":self.goodDic[@"id"]} ok:^(MCNetResponse * _Nonnull resp) {
        weakself.dataArray  = [[NSMutableArray alloc]initWithArray:resp.result];
        [weakself.mc_tableview reloadData];
        
        weakself.mc_tableview.tableHeaderView = weakself.headerView;

    }];
}
- (void)layoutTableView
{
    self.mc_tableview.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop - 80 );
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 先从缓存中查找图片
       UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey: self.dataArray[indexPath.row][@"path"]];
       
       // 没有找到已下载的图片就使用默认的占位图，当然高度也是默认的高度了，除了高度不固定的文字部分。
       if (!image) {
           image = [UIImage imageNamed:@""];
       }
    
       //手动计算cell
       CGFloat imgHeight = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
    CGFloat h = imgHeight ? imgHeight : 100;
    return h;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDJFShopDetailTableViewCell *cell = [KDJFShopDetailTableViewCell cellWithTableView:tableView];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(KDJFShopDetailTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSString *imgURL = self.dataArray[indexPath.row][@"path"];
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
    
    if ( !cachedImage ) {
        [self downloadImage:self.dataArray[indexPath.row][@"path"] forIndexPath:indexPath];

    } else {
        cell.detailImv.image = cachedImage;
    }
}
 
- (void)downloadImage:(NSString *)imageURL forIndexPath:(NSIndexPath *)indexPath {
    // 利用 SDWebImage 框架提供的功能下载图片
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL toDisk:YES completion:^{
            [self.mc_tableview reloadData];

        }];
    }];
}

@end
