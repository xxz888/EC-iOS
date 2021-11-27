//
//  MCUpdateViewController.m
//  MCOEM
//
//  Created by wza on 2020/4/22.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCMyRateController.h"
#import <iCarousel/iCarousel.h>
#import "MCProductModel.h"
#import "MCProductView.h"
#import "MCFeilvCell.h"
#import "MCFeilvModel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MCFeilvListView.h"

#define PAGE_HEIGHT 150
#define PAGE_OFFSET 60.0
@interface MCMyRateController ()<iCarouselDelegate, iCarouselDataSource>

@property(nonatomic, strong) iCarousel *productPage;
@property(nonatomic, strong) NSMutableArray<MCProductModel *> *dataSource;
@property(nonatomic, strong) UIScrollView *backScroll;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) QMUILabel *productNameLab;
@property(nonatomic, strong) MCFeilvListView *listView;

@end

@implementation MCMyRateController
- (NSMutableArray<MCProductModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (MCFeilvListView *)listView {
    if (!_listView) {
        CGFloat height = SCREEN_HEIGHT-NavigationContentTop-self.topView.qmui_bottom-(self.hidesBottomBarWhenPushed?0:TabBarHeight);
        _listView = [[MCFeilvListView alloc] initWithFrame:CGRectMake(0, self.topView.qmui_bottom, SCREEN_WIDTH, height)];
    }
    return _listView;
}

- (QMUILabel *)productNameLab {
    if (!_productNameLab) {
        _productNameLab = [[QMUILabel alloc] initWithFrame:CGRectMake(0, self.productPage.bottom+20, SCREEN_WIDTH, 50)];
        _productNameLab.font = UIFontBoldMake(20);
        _productNameLab.textColor = UIColorBlack;
        _productNameLab.text = @"";
        _productNameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _productNameLab;
}
- (UIView *)topView {
    if (!_topView) {
        _topView  =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, PAGE_HEIGHT*MCSCALE+100)];
        [_topView addSubview:self.productPage];
        [_topView addSubview:self.productNameLab];
    }
    return _topView;
}

- (UIScrollView *)backScroll {
    if (!_backScroll) {
        CGFloat height = self.topView.qmui_height+self.listView.qmui_height;
        _backScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, height)];
        _backScroll.contentSize = _backScroll.size;
        _backScroll.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
        _backScroll.showsVerticalScrollIndicator = NO;
    }
    return _backScroll;
}

- (iCarousel *)productPage {
    if (!_productPage) {
        _productPage = [[iCarousel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, PAGE_HEIGHT*MCSCALE)];
        _productPage.type = iCarouselTypeCustom;
        _productPage.pagingEnabled = YES;
        _productPage.delegate = self;
        _productPage.dataSource = self;
        _productPage.bounces = NO;
        _productPage.backgroundColor = UIColorWhite;
    }
    return _productPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"我的费率" tintColor:nil];
    self.view.clipsToBounds = YES;
    [self.view addSubview:self.backScroll];
    [self.backScroll addSubview:self.topView];
    [self.backScroll addSubview:self.listView];
    [self requestProducts];
    
}


#pragma mark - Actions
- (void)refreshAction {
    [self requestProducts];
}
- (void)updateTouched:(QMUIFillButton *)sender {
    
}

/// 获取产品
- (void)requestProducts {
    
    __weak __typeof(self)weakSelf = self;
    [self requestFeilvWithUserID:SharedUserInfo.userid];
    [self.sessionManager mc_POST:[NSString stringWithFormat:@"/user/app/usersys/query/%@",TOKEN] parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        
        [weakSelf.backScroll.mj_header endRefreshing];
        
        NSArray *tempA = [MCProductModel mj_objectArrayWithKeyValuesArray:[resp.result objectForKey:@"thirdLevelDistribution"]];
        
        for (MCProductModel *model in tempA) {
            if (model.grade.intValue == SharedUserInfo.grade.intValue) {
                [weakSelf.dataSource removeAllObjects];
                [weakSelf.dataSource addObject:model];
                break;
            }
        }
        [weakSelf.productPage reloadData];
    } other:^(MCNetResponse * _Nonnull resp) {
        [weakSelf.backScroll.mj_header endRefreshing];
        [MCToast showMessage:resp.messege];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.backScroll.mj_header endRefreshing];
        [MCToast showMessage:error.localizedFailureReason];
    }];
}

/// 获取产品的费率
- (void)requestFeilvWithUserID:(NSString *)userId {
    [MBProgressHUD showHUDAddedTo:self.listView animated:YES];
    NSDictionary *param = @{@"user_id":userId};
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_POST:@"/user/app/channel/query/all/brandid" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        [MBProgressHUD hideHUDForView:weakSelf.listView animated:YES];
        weakSelf.productNameLab.text = @"当前费率";
        NSArray *tempArr = [MCFeilvModel mj_objectArrayWithKeyValuesArray:resp.result];
        NSMutableArray *tempHuankuan = [NSMutableArray new];
        NSMutableArray *tempShoukuan = [NSMutableArray new];
        for (MCFeilvModel *model in tempArr) {
            if ([model.subName isEqualToString:@"支付宝"] || [model.subName isEqualToString:@"微信"]) {
                continue;
            }
            if ([model.subName isEqualToString:@"还款"]) {
                [tempHuankuan addObject:model];
            } else if (model.status.intValue == 1 /*|| model.channelNo.intValue == 1 || model.channelNo.intValue == 2 || model.channelNo.intValue == 5*/) {
                [tempShoukuan addObject:model];
            }
        }
        NSMutableArray *tempMut = [[NSMutableArray alloc] initWithArray:@[tempHuankuan, tempShoukuan]];
        weakSelf.listView.feilvDataSource = tempMut;
    } other:^(MCNetResponse * _Nonnull resp) {
        [MBProgressHUD hideHUDForView:weakSelf.listView animated:YES];
        [MCToast showMessage:resp.messege];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.listView animated:YES];
        [MCToast showMessage:[NSString stringWithFormat:@"%ld\n%@",(long)error.code,error.localizedFailureReason]];
    }];
}
#pragma mark - iCarousel
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.dataSource.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    return [self fetchCurrentViewWithView:self.productPage reusingView:view index:index];
    
}
- (UIView*) fetchCurrentViewWithView:(iCarousel*)carousel
                         reusingView:(UIView *)view
                               index:(NSInteger)index{
    if (view == nil) {
        CGSize size = carousel.bounds.size;
        view = [MCProductView newFromNib];
        view.frame = CGRectMake(0,carousel.frame.origin.y , SCREEN_WIDTH - 2*PAGE_OFFSET, size.height);
    }
    MCProductModel *model = self.dataSource[index];
    MCProductView *pv = (MCProductView *)view;
    pv.type = MCProductViewTypeMyRate;
    pv.productNameLab.text = model.name;
    pv.priceLab.text = [NSString stringWithFormat:@"￥%.2f",model.money.floatValue];
    pv.currentGradeLab.text = [NSString stringWithFormat:@"%@",SharedUserInfo.gradeName];
    pv.numLab.text = SharedConfig.brand_name;
    pv.gradeImgView.image = [UIImage mc_imageNamed:[NSString stringWithFormat:@"mcgrade_%d",model.grade.intValue]];
    return view;
}


- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.85f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    return CATransform3DTranslate(transform, offset * self.productPage.itemWidth * 1.2, 0.0, 0.0);
}




@end
