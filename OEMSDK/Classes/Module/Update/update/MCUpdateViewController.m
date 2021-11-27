//
//  MCUpdateViewController.m
//  MCOEM
//
//  Created by wza on 2020/4/22.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCUpdateViewController.h"
#import <iCarousel/iCarousel.h>
#import "MCProductModel.h"
#import "MCProductView.h"
#import "MCFeilvCell.h"
#import "MCFeilvModel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MCFeilvListView.h"

#define PAGE_HEIGHT 150
#define PAGE_OFFSET 60.0
@interface MCUpdateViewController ()<iCarouselDelegate, iCarouselDataSource>

@property(nonatomic, strong) QMUIFillButton *updateButton;
@property(nonatomic, strong) iCarousel *productPage;
@property(nonatomic, strong) NSMutableArray<MCProductModel *> *dataSource;
@property(nonatomic, strong) UIScrollView *backScroll;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) QMUILabel *productNameLab;
@property(nonatomic, strong) MCFeilvListView *listView;

@end

@implementation MCUpdateViewController
- (NSMutableArray<MCProductModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (MCFeilvListView *)listView {
    if (!_listView) {
        CGFloat height = SCREEN_HEIGHT-NavigationContentTop-self.topView.qmui_bottom-50*MCSCALE-(self.hidesBottomBarWhenPushed?0:TabBarHeight);
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
- (QMUIFillButton *)updateButton {
    if (!_updateButton) {
        _updateButton = [[QMUIFillButton alloc] initWithFillColor:MAINCOLOR titleTextColor:UIColorWhite];
        _updateButton.highlightedBackgroundColor = [_updateButton.fillColor qmui_colorWithAlphaAddedToWhite:0.5];
        [_updateButton setTitle:@"一键升级" forState:UIControlStateNormal];
        [_updateButton addTarget:self action:@selector(updateTouched:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat y = SCREEN_HEIGHT-50*MCSCALE-(self.hidesBottomBarWhenPushed?0:TabBarHeight);
        _updateButton.frame = CGRectMake(0, y, SCREEN_WIDTH, 50*MCSCALE);
        _updateButton.cornerRadius = 0;
    }
    return _updateButton;
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
    [self setNavigationBarTitle:@"产品升级" tintColor:nil];
    self.view.clipsToBounds = YES;
    [self.view addSubview:self.backScroll];
    [self.backScroll addSubview:self.topView];
    [self.backScroll addSubview:self.listView];
    [self.view addSubview:self.updateButton];
    [self requestProducts];
    
}

#pragma mark - Actions
- (void)refreshAction {
    [self requestProducts];
}
- (void)updateTouched:(QMUIFillButton *)sender {
    MCProductModel *model = self.dataSource[self.productPage.currentItemIndex];
    if (model.isBuy.intValue == 1) {    //已经购买
        [MCToast showMessage:@"您已购买，无需再次购买"];
    } else if (model.trueFalseBuy.intValue == 0 || model.trueFalseBuy.intValue == 2) {  //在线购买
        [MCChoosePayment popAlertBeforeShowWithAmount:model.money.doubleValue productId:model.ID productName:model.name couponId:nil];
    } else if (model.trueFalseBuy.intValue == 1 || model.trueFalseBuy.intValue == 3) {  //联系客服
        [MCServiceStore callBrand];
    } else {
        [MCToast showMessage:@"暂时无法购买，请联系客服或稍后再试"];
    }
}
- (void)requestProducts {
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_GET:[NSString stringWithFormat:@"/user/app/thirdlevel/prod/brand/%@",SharedBrandInfo.ID] parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        
        [weakSelf.backScroll.mj_header endRefreshing];
        
        NSArray *tempA = [[[MCProductModel mj_objectArrayWithKeyValuesArray:resp.result] reverseObjectEnumerator] allObjects];
        
        if (SharedUserInfo.brandStatus.boolValue) { //贴牌商
            weakSelf.dataSource = [NSMutableArray arrayWithArray:tempA];
        } else {
            [weakSelf.dataSource removeAllObjects];
            for (MCProductModel *model in tempA) {
                if (model.trueFalseBuy.intValue != 4) {
                    [weakSelf.dataSource addObject:model];
                }
            }
        }
        if (weakSelf.dataSource.count) {
            [weakSelf requestFeilvWithProductID:weakSelf.dataSource[0].ID];
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
- (void)requestFeilvWithProductID:(NSString *)productId {
    [MBProgressHUD showHUDAddedTo:self.listView animated:YES];
    NSDictionary *param = @{@"thirdLevelId":productId};
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_POST:@"/user/app/thirdlevel/rate/query/thirdlevelid/" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        [MBProgressHUD hideHUDForView:weakSelf.listView animated:YES];
        NSArray *tempArr = [MCFeilvModel mj_objectArrayWithKeyValuesArray:resp.result];
        NSMutableArray *tempHuankuan = [NSMutableArray new];
        NSMutableArray *tempShoukuan = [NSMutableArray new];
        for (MCFeilvModel *model in tempArr) {
            if ([model.subName isEqualToString:@"支付宝"] || [model.subName isEqualToString:@"微信"]) {
                continue;
            }
            if ([model.subName containsString:@"还款"]) {
                [tempHuankuan addObject:model];
            } else if (model.status.intValue == 1 || model.channelNo.intValue == 1 || model.channelNo.intValue == 2 || model.channelNo.intValue == 5) {
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
    pv.productNameLab.text = model.name;
    pv.priceLab.text = [NSString stringWithFormat:@"￥%.2f",model.money.floatValue];
    pv.currentGradeLab.text = [NSString stringWithFormat:@"您当前是%@",SharedUserInfo.gradeName];
    NSString *str = [NSString stringWithFormat:@"共%ld个产品",self.dataSource.count];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:pv.currentGradeLab.textColor range:[str rangeOfString:[NSString stringWithFormat:@"%ld",self.dataSource.count]]];
    pv.numLab.attributedText = attr;
    pv.gradeImgView.image = [UIImage mc_imageNamed:[NSString stringWithFormat:@"mcgrade_%d",model.grade.intValue]];
    return view;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    NSInteger index = carousel.currentItemIndex;
    MCLog(@"%ld",(long)index);
    MCProductModel * model = self.dataSource[index];
    
    if (model.isBuy.intValue == 0) {
        self.updateButton.fillColor = MAINCOLOR;
    } else {
        self.updateButton.fillColor = UIColorGrayLighten;
    }
    
    self.productNameLab.text = model.name;
    [self requestFeilvWithProductID:model.ID];
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

//循环滚动
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    
    if (option == iCarouselOptionWrap) {
        return YES;
    }

    return value;
}


@end
