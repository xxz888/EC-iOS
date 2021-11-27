//
//  MCShareManyViewController.m
//  MCOEM
//
//  Created by wza on 2020/4/17.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCShareManyViewController.h"
#import <iCarousel/iCarousel.h>
#import "MCPosterModel.h"
#import "MCPosterHeader.h"


#define PAGE_OFFSET 50.0

@interface MCShareManyViewController ()<iCarouselDelegate,iCarouselDataSource>

@property(nonatomic, copy) NSArray<MCPosterModel *> *dataSource;
@property(nonatomic, strong) MCPosterHeader *header;

@end

@implementation MCShareManyViewController

- (MCPosterHeader *)header {
    if (!_header) {
        _header = [MCPosterHeader newFromNib];
    }
    return _header;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBarTitle:@"分享" tintColor:UIColor.whiteColor];
    
    self.mc_tableview.tableHeaderView = self.header;
    
    self.header.qmui_height = self.qmui_prefersStatusBarHidden ? SCREEN_HEIGHT-NavigationContentTop : SCREEN_HEIGHT-NavigationContentTop-TabBarHeight;
    
    [self setupPageView];
    [self setupShareButtons];
    [self requestPosters];
    
    self.view.clipsToBounds = YES;
}
- (void)setupShareButtons {
    for (int i=1000; i<1004; i++) {
        UIStackView *ss = [self.header viewWithTag:i];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onShareButtonTouched:)];
        [ss addGestureRecognizer:tap];
    }
}
- (void)setupPageView {
    self.header.pageView.type = iCarouselTypeCustom;
    self.header.pageView.pagingEnabled = YES;
    self.header.pageView.delegate = self;
    self.header.pageView.dataSource = self;
    self.header.pageView.bounces = NO;
}
- (void)requestPosters {
    
    __weak __typeof(self)weakSelf = self;
    
    [self.sessionManager mc_POST:@"/user/app/qrcodepicture/getqrcodepictureby/brandid" parameters:@{@"brandId":SharedConfig.brand_id} ok:^(MCNetResponse * _Nonnull resp) {
        weakSelf.dataSource = [MCPosterModel mj_objectArrayWithKeyValuesArray:resp.result];
        [weakSelf.header.pageView reloadData];
    }];
}

- (void)onShareButtonTouched:(UITapGestureRecognizer *)tap {
    NSInteger tag = tap.view.tag;
    UIImageView *imgView = (UIImageView *)self.header.pageView.currentItemView;
    UIImage *img = [imgView.image qmui_imageResizedInLimitedSize:CGSizeMake(self.header.pageView.qmui_width, CGFLOAT_MAX)];
    if (tag == 1000) {  //微信
        [MCShareStore shareToWeChatSession:img];
    }
    if (tag == 1001) {  //朋友圈
        [MCShareStore shareToWeChatTimeLine:img];
    }
    if (tag == 1002) {  //QQ
        [MCShareStore shareToQQ:img];
    }
    if (tag == 1003) {  //保存相册
        [MCShareStore saveToAlbum:img];
    }
}
#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.dataSource.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    return [self fetchCurrentViewWithView:self.header.pageView reusingView:view index:index];
    
}
- (UIView*) fetchCurrentViewWithView:(iCarousel*)carousel
                         reusingView:(UIView *)view
                               index:(NSInteger)index{
    if (view == nil) {
        CGSize size = carousel.bounds.size;
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0,carousel.frame.origin.y , SCREEN_WIDTH - 2*PAGE_OFFSET, size.height)];
    }
    MCPosterModel *m = self.dataSource[index];
    UIImageView *imgView = (UIImageView *)view;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:m.qrcodeUrl] placeholderImage:[UIImage mc_imageNamed:@"lx_share_salary_bg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            imgView.image = [MCImageStore creatShareImageWithImage:image];
        }
    }];
    
    return view;
}
#pragma mark - iCarouselDelegate

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
    return CATransform3DTranslate(transform, offset * self.header.pageView.itemWidth * 1.2, 0.0, 0.0);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    
    if (option == iCarouselOptionWrap) {
        return YES;
    }

    return value;
}
@end
