//
//  MCDiyController.m
//  Pods
//
//  Created by wza on 2020/7/4.
//

#import "MCDiyController.h"
#import <OEMSDK/OEMSDK.h>
#import <MBProgressHUD.h>
// 竖条顶部高度
#define kTitleCustomTopSpaceHeight   10
// 账户安全顶部高度
#define kSafeTopSpaceHeight          30


@interface MCDiyController ()<QMUITableViewDelegate,QMUITableViewDataSource>

/** 主功能区 */
@property(nonatomic,readwrite,strong)  MCCustomMenuView *mainMenuView;
/** 副功能区 */
@property(nonatomic,readwrite,strong)  MCCustomMenuView *viceMenuView;
/** 标题和竖条 */
@property(nonatomic,readwrite,strong)  MCTitleCustomView *titleCustomView;
/** 广告位 */
@property(nonatomic,readwrite,strong)  MCBannerView *adView;
/** 跑马灯 */
@property(nonatomic,readwrite,strong)  MCRunLightView *runLightView;
/** 保险 */
@property(nonatomic,readwrite,strong)  MCSafeCustomView *safeCustomView;
/** 资讯 */
@property(nonatomic,readwrite,strong)  MCNewsView   *newsView;

/*******************************分类***************************************/
/** 主功能区整体视图 */
@property(nonatomic,readwrite,strong)  UIView *mc_mainview;
/** 副功能区整体视图 */
@property(nonatomic,readwrite,strong)  UIView *mc_viceview;
/** 广告整体视图 */
@property(nonatomic,readwrite,strong)  UIView *mc_adview;
/** 跑马灯视图 */
@property(nonatomic,readwrite,strong)  UIView *mc_runlighview;
/** 保险视图 */
@property(nonatomic,readwrite,strong)  UIView *mc_safeview;
/** 资讯视图 */
@property(nonatomic,readwrite,strong)  UIView *mc_newsview;
/** 模块视图数据源 */
@property(nonatomic,readwrite,strong)  NSMutableArray *moduleDataSource;

@end

@implementation MCDiyController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    
   
    
    
    [self  setCustomView];
    [self  requestData];
    [self setupNav];

}

- (void)setupNav {
    
    self.mc_titleview.title = BCFI.brand_name;
    self.navigationItem.titleView = self.mc_titleview;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 60, 30);
    [button setTitle:@"客服" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    UIImage *img = [[UIImage mc_imageNamed:@"za_home_btn_kf_icon"] imageWithColor:BCFI.color_main];
    [button setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [button addTarget:self action:@selector(onRightTouched) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(0, 0, 60, 30);
    [button1 setTitle:@"礼包" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    UIImage *img1 = [[UIImage mc_imageNamed:@"za_mine_btn_upgrade_icon"] imageWithColor:BCFI.color_main];;
    [button1 setImage:[img1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    button1.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [button1 addTarget:self action:@selector(onLeftTouched) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
}

- (void)onRightTouched {
    [MCPagingStore pagingURL:rt_setting_service];
}
- (void)onLeftTouched
{
    [MCPagingStore pagingURL:rt_update_list];
}
#pragma mark - Public Methods


#pragma mark - Private Methods

/**
 * 更新视图高度.
 */
- (void) updataViewHeight:(UIView*) supView viewHeight:(CGFloat) height{
    supView.frame = CGRectMake(0, 0,supView.width, height);
}

#pragma mark - Network Methods
- (void) requestData{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:BCFI.brand_id forKey:@"brandId"];
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_POST:@"/user/app/select/topup/home/BrandMiddle/" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        NSArray* tempArray = @[weakSelf.mc_adview,weakSelf.mc_mainview,weakSelf.mc_runlighview,weakSelf.mc_viceview,weakSelf.mc_newsview,weakSelf.mc_safeview];
        
        NSArray* result = resp.result;
        for (NSInteger i = 0; i < result.count; i++) {
            NSDictionary* innerDict = result[i];
            NSString* status = [NSString stringWithFormat:@"%@",innerDict[@"status"]];
            NSUInteger locationName = [[NSString stringWithFormat:@"%@",innerDict[@"accountDetails"]] integerValue];
            UIView* tempView = tempArray[locationName];
            if ([status isEqualToString:@"1"]) {// 上架
                tempView.tag = i;
                [weakSelf.moduleDataSource replaceObjectAtIndex:i withObject:tempView];
            }else{
                [weakSelf.moduleDataSource replaceObjectAtIndex:locationName withObject:[[UIView alloc]initWithFrame:CGRectZero]];
            }
            if (locationName == 5) {// 安全区
                [weakSelf.safeCustomView updataWithIconeUrl:innerDict[@"messageBar"]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hiddHud];
            [weakSelf.mc_tableview reloadData];
        });
    }];
    
}
#pragma mark - 隐藏默认的菊花
/**
 * 暂时这样处理 待优化
 */
- (void)hiddHud{
    MCAppDelegate* delegate = ((MCAppDelegate*)[UIApplication sharedApplication].delegate);
    for (id view in delegate.window.subviews) {
        if ([view isKindOfClass:[MBProgressHUD class]]) {
            MBProgressHUD* hud = (MBProgressHUD*)view;
            [hud hideAnimated:YES];
            NSLog(@"aaa");
        }
    }
}

/**
 * 只需要布局就行
 */
- (void)setCustomView {
    __weak typeof(self) weakSelf = self;
    self.adView.resetHeightBlock = ^(CGFloat h) {
          __strong __typeof(self) strongSelf = weakSelf;
          //更新数据
          [strongSelf updataViewHeight:strongSelf.mc_adview viewHeight:h];
          
          strongSelf.adView.ly_height = h;
          [UIView performWithoutAnimation:^{
              NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:weakSelf.mc_adview.tag];
              [weakSelf.self.mc_tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
          }];
      };
    
    self.mainMenuView.menuViewHeight = ^(CGFloat menuViewHeight) {
        __strong __typeof(self) strongSelf = weakSelf;
        //更新数据
        [strongSelf updataViewHeight:strongSelf.mc_mainview viewHeight:menuViewHeight];
        NSLog(@"strongSelf.mc_mainview.tag---%ld",weakSelf.mc_mainview.tag);
        
        [UIView performWithoutAnimation:^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:weakSelf.mc_mainview.tag];
            [weakSelf.self.mc_tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    };

    self.viceMenuView.menuViewHeight = ^(CGFloat menuViewHeight) {
        __strong __typeof(self) strongSelf = weakSelf;
        [strongSelf updataViewHeight:strongSelf.mc_viceview viewHeight:(self.titleCustomView.height+menuViewHeight+kTitleCustomTopSpaceHeight)];
        NSLog(@"strongSelf.mc_viceview.tag---%ld",strongSelf.mc_viceview.tag);
        [UIView performWithoutAnimation:^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:strongSelf.mc_viceview.tag];
            [strongSelf.self.mc_tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    };
    
    self.newsView.height = ^(CGFloat height) {
        __strong __typeof(self) strongSelf = weakSelf;
        [strongSelf updataViewHeight:strongSelf.mc_newsview viewHeight:height];
        NSLog(@"height---%f",height);
        [UIView performWithoutAnimation:^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:strongSelf.mc_newsview.tag];
            [strongSelf.self.mc_tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    };
 
}
#pragma mark - Protocol Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.moduleDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIView* subView = self.moduleDataSource[indexPath.section];
    return subView.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *cellID = @"ReusableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellID];
    }
    [cell.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (self.moduleDataSource.count > 0) {
        UIView* subView = self.moduleDataSource[indexPath.section];
        [cell addSubview:subView];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

#pragma mark - Action Methods

#pragma mark - Setter And Getter Method
- (UIView*) mc_mainview {
    if (nil == _mc_mainview) {
        _mc_mainview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,0)];
        [_mc_mainview addSubview:self.mainMenuView];
//        [self updataViewHeight:_mc_mainview viewHeight:self.mainMenuView.height];
    }
    return _mc_mainview;
}

- (UIView*) mc_viceview{
    if (nil == _mc_viceview) {
        _mc_viceview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,0)];
        _mc_viceview.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        [_mc_viceview addSubview:self.titleCustomView];
        [_mc_viceview addSubview:self.viceMenuView];
        [self updataViewHeight:_mc_viceview viewHeight:(self.viceMenuView.height+kTitleCustomTopSpaceHeight)];
    }
    return _mc_viceview;
}

- (UIView*) mc_adview {
    if (nil == _mc_adview) {
        _mc_adview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,100)];
//        _mc_adview.backgroundColor = [UIColor mainColor];
        [_mc_adview addSubview:self.adView];
        [self updataViewHeight:_mc_adview viewHeight:(self.adView.height + 20)];
    }
    return _mc_adview;
}

- (UIView*) mc_runlighview {
    if (nil == _mc_runlighview) {
        _mc_runlighview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,100)];
        [_mc_runlighview addSubview:self.runLightView];
        [self updataViewHeight:_mc_runlighview viewHeight:self.runLightView.height];
    }
    return _mc_runlighview;
}

- (UIView*) mc_safeview {
    if (nil == _mc_safeview) {
        
        _mc_safeview = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH,100)];
        _mc_safeview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_mc_safeview addSubview:self.safeCustomView];
        [self updataViewHeight:_mc_safeview viewHeight:self.safeCustomView.height+kSafeTopSpaceHeight*4];
    }
    return _mc_safeview;
}

- (UIView*) mc_newsview {
    if (nil == _mc_newsview) {
        _mc_newsview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,0)];
        _mc_newsview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_mc_newsview addSubview:self.newsView];
        [self updataViewHeight:_mc_newsview viewHeight:49 + 93 * 3 + 15 + 10];
    }
    return _mc_newsview;
}

- (MCCustomMenuView*) mainMenuView {
    if (nil == _mainMenuView) {
        _mainMenuView = [[MCCustomMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,80) dataType:MCCustomMenuViewTypeMain];
        _mainMenuView.itemColor = [UIColor clearColor];
        _mainMenuView.iconeWidth = 54;
        _mainMenuView.iconeHeight = 292 - NavigationContentTop;
    }
    return _mainMenuView;
}
- (MCCustomMenuView*) viceMenuView {
    if (nil == _viceMenuView) {
        _viceMenuView = [[MCCustomMenuView alloc] initWithFrame:CGRectMake(0, kTitleCustomTopSpaceHeight,SCREEN_WIDTH,190) dataType:MCCustomMenuViewTypeVice];
    }
    return _viceMenuView;
}
- (MCBannerView*) adView {
    if (nil == _adView) {
        _adView = [[MCBannerView alloc] initWithFrame:CGRectMake(16, 10, SCREEN_WIDTH-32, 200) bannerType:1];
    }
    return _adView;
}

- (MCRunLightView*) runLightView {
    if (nil == _runLightView) {
        _runLightView = [[MCRunLightView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,40)];
        _runLightView.backgroundColor = [UIColor whiteColor];
    }
    return _runLightView;
}

//- (MCTitleCustomView*) titleCustomView {
//    if (nil == _titleCustomView) {
//        _titleCustomView = [[MCTitleCustomView alloc] initWithFrame:CGRectMake(0,kTitleCustomTopSpaceHeight,SCREEN_WIDTH ,21)];
//        _titleCustomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        _titleCustomView.titleName.text = @"欢乐付服务";
//    }
//    return _titleCustomView;
//}

- (MCSafeCustomView*) safeCustomView {
    if (nil == _safeCustomView) {
        _safeCustomView = [[MCSafeCustomView alloc] initWithFrame:CGRectMake(0,kSafeTopSpaceHeight,SCREEN_WIDTH ,21)];
        _safeCustomView.backgroundColor = [UIColor clearColor];
    }
    return _safeCustomView;
}

- (MCNewsView*) newsView {
    if (nil == _newsView) {
        _newsView = [[MCNewsView alloc] initWithFrame:CGRectMake(10,0,SCREEN_WIDTH-20,100)];
        _newsView.backgroundColor = [UIColor clearColor];
    }
    return _newsView;
}

- (NSMutableArray*) moduleDataSource {
    if (nil == _moduleDataSource) {
        _moduleDataSource = @[[[UIView alloc]initWithFrame:CGRectZero],
        [[UIView alloc]initWithFrame:CGRectZero],
        [[UIView alloc]initWithFrame:CGRectZero],
        [[UIView alloc]initWithFrame:CGRectZero],
        [[UIView alloc]initWithFrame:CGRectZero],
        [[UIView alloc]initWithFrame:CGRectZero]].mutableCopy;
    }
    return _moduleDataSource;
}

@end
