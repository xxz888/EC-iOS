//
//  MCArticlesController.m
//  MCOEM
//
//  Created by wza on 2020/5/12.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCArticlesController.h"
#import "MCArticleModel.h"
#import "MCArticlesCell.h"

@interface MCArticlesController ()<QMUITableViewDelegate, QMUITableViewDataSource>
@property(nonatomic, copy) NSMutableArray<MCArticleModel *> *dataSource;
@property (nonatomic, assign) NSInteger page;

@end

@implementation MCArticlesController

- (NSMutableArray<MCArticleModel *> *)dataSource { 
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"分享素材" tintColor:nil];
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.ly_emptyView = [MCEmptyView emptyView];
    self.mc_tableview.separatorInset = UIEdgeInsetsZero;
    
    
    self.page = 0;
    __weak __typeof(self)weakSelf = self;
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 0;
        [weakSelf requestData:YES];
    }];
    self.mc_tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [weakSelf requestData:NO];
    }];
    [self requestData:YES];
    
    [self setupHeader];;
}

- (void)setupHeader {
    UIView *hv = [[UIView alloc] init];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    line1.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    [hv addSubview:line1];
    
    
    
    QMUILabel *headLab = [[QMUILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 20)];
    headLab.font = UIFontMake(13);
    headLab.textColor = [UIColor qmui_colorWithHexString:@"#666666"];
    headLab.text = @"图片中的二维码都是您本人的专属二维码，保存图片，复制文字即可分享至朋友圈，坚持每天分享朋友圈素材，有利于快速吸引潜在用户。";
    headLab.contentEdgeInsets = UIEdgeInsetsMake(9, 11, 9, 11);
    headLab.qmui_lineHeight = 20;
    headLab.numberOfLines = 0;
    headLab.backgroundColor = UIColor.whiteColor;
    [headLab sizeToFit];
    [hv addSubview:headLab];
    
    
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, headLab.bottom, SCREEN_WIDTH, 10)];
    line2.backgroundColor = line1.backgroundColor;
    [hv addSubview:line2];
    hv.frame = CGRectMake(0, 0, SCREEN_WIDTH, headLab.height+20);
    
    self.mc_tableview.tableHeaderView = hv;
    self.mc_tableview.rowHeight = UITableViewAutomaticDimension;
    
//    self.mc_tableview.qmui_cacheCellHeightByKeyAutomatically = YES;
}

- (void)requestData:(BOOL)cleanData {
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_POST:@"/user/app/imagetext/query/brandid" parameters:@{@"brand_id":SharedConfig.brand_id,@"page":@(self.page),@"size":@(20)
                                                                            
    } ok:^(MCNetResponse * _Nonnull resp) {
        
        if ([weakSelf.mc_tableview.mj_header isRefreshing]) {
            [weakSelf.mc_tableview.mj_header endRefreshing];
        }
        if ([weakSelf.mc_tableview.mj_footer isRefreshing]) {
            [weakSelf.mc_tableview.mj_footer endRefreshing];
        }
        if (cleanData) {
            [weakSelf.dataSource removeAllObjects];
        }
        //MCLog(@"%@",resp.result);
        NSArray *arr = [MCArticleModel mj_objectArrayWithKeyValuesArray:resp.result];
        
//        NSString * url =  @"http://192.168.10.32/v1.0/user/app/getQRcode?imageId=112";
//
//
//        MCArticleModel * model0 = arr[0];
//        NSMutableArray * imgUrl0 = [[NSMutableArray alloc]init];
//        [imgUrl0 addObject:url];
//        model0.img_url = imgUrl0;
//
//        MCArticleModel * model1 = arr[1];
//        NSMutableArray * imgUrl1 = [[NSMutableArray alloc]init];
//        while (imgUrl1.count < 2) {[imgUrl1 addObject:url];}
//        model1.img_url = imgUrl1;
//
//
//        MCArticleModel * model2 = arr[2];
//        NSMutableArray * imgUrl2 = [[NSMutableArray alloc]init];
//        while (imgUrl2.count < 3) {[imgUrl2 addObject:url];}
//        model2.img_url = imgUrl2;
//
//
//        MCArticleModel * model3 = arr[3];
//        NSMutableArray * imgUrl3 = [[NSMutableArray alloc]init];
//        while (imgUrl3.count < 4) {[imgUrl3 addObject:url];}
//        model3.img_url = imgUrl3;
//
//
//        MCArticleModel * model4 = arr[4];
//        NSMutableArray * imgUrl4 = [[NSMutableArray alloc]init];
//        while (imgUrl4.count < 5) {[imgUrl4 addObject:url];}
//        model4.img_url = imgUrl4;
//
//
//        MCArticleModel * model5 = arr[5];
//        NSMutableArray * imgUrl5 = [[NSMutableArray alloc]init];
//        while (imgUrl5.count < 6) {[imgUrl5 addObject:url];}
//        model5.img_url = imgUrl5;
//
//
//
//        MCArticleModel * model6 = arr[6];
//        NSMutableArray * imgUrl6 = [[NSMutableArray alloc]init];
//        while (imgUrl6.count < 7) {[imgUrl6 addObject:url];}
//        model6.img_url = imgUrl6;
//
//
//
//        MCArticleModel * model7 = arr[7];
//        NSMutableArray * imgUrl7 = [[NSMutableArray alloc]init];
//        while (imgUrl7.count < 8) {[imgUrl7 addObject:url];}
//        model7.img_url = imgUrl7;
//
//        MCArticleModel * model8 = arr[8];
//        NSMutableArray * imgUrl8 = [[NSMutableArray alloc]init];
//        while (imgUrl8.count < 9) {[imgUrl8 addObject:url];}
//        model8.img_url = imgUrl8;
        
        [weakSelf.dataSource addObjectsFromArray:arr];
        [weakSelf.mc_tableview reloadData];
        

    }];
}
#pragma mark - Tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MCArticlesCell cellWithTableview:tableView articleModel:self.dataSource[indexPath.row]];
}
//- (id<NSCopying>)qmui_tableView:(UITableView *)tableView cacheKeyForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [NSString stringWithFormat:@"%d",indexPath.row];
//}

@end
