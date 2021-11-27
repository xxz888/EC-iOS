//
//  MCBannerView.m
//  MCOEM
//
//  Created by SS001 on 2020/3/30.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBannerView.h"
#import <CoreLocation/CoreLocation.h>
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface MCBannerView ()<SDCycleScrollViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray <NSDictionary *> *infos;
@property (nonatomic, strong) SDCycleScrollView *banner;
@property (nonatomic, strong) CLLocationManager *locationManager;//设置manager
@property (nonatomic, assign) BOOL isFetch;

@end

@implementation MCBannerView
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
    }
    return _locationManager;
}

- (instancetype)initWithFrame:(CGRect)frame bannerType:(NSInteger)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.bannerType = type;
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadImg) name:@"reloadBannerImage" object:nil];
}


- (void)setup {
     [self addSubview:self.banner];
    
    switch (self.bannerType) {
        case 0:
        {
            if (SharedConfig.is_location_banner) {
                [self.locationManager startUpdatingLocation];
            } else {
                [self fetchBanners:nil];
            }
        }
            break;
        case 1:
        {
            if (SharedConfig.is_location_banner) {
                [self.locationManager startUpdatingLocation];
            } else {
                [self fetchBanners:nil];
            }
        }
            break;
        case 2:
            [self addSubview:[self creatBannerWithText1:@"在“支付变革”时代" text2:@"给消费者更多选择" imageName:@"mc_banner_team"]];
            break;
        case 3:
            [self addSubview:[self creatBannerWithText1:SharedConfig.brand_name text2:@"视频教程" imageName:@"mc_banner_video"]];
            break;
        default:
            break;
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.banner.frame = self.bounds;
}
- (UIView *)creatBannerWithText1:(NSString *)text1 text2:(NSString *)text2 imageName:(NSString *)imgname {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = MAINCOLOR;
    
    UIImage *img = [UIImage mc_imageNamed:imgname];
    CGFloat imgR = img.size.width / img.size.height;
    CGFloat imgH = view.frame.size.height * 2/3;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - imgH*imgR, (view.ly_height-imgH)/2, imgH*imgR, imgH)];
    [view addSubview:imgV];
    imgV.image = img;

    CGFloat viewH = 30;
    CGFloat viewY = (view.size.height - viewH) * 0.5;
    UILabel * lab1 = [[UILabel alloc] initWithFrame:CGRectMake(20, viewY, 250, viewH)];
    lab1.text = text1;
    lab1.textColor = [UIColor whiteColor];
    [lab1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:26]];
    [view addSubview:lab1];
    
    
    
    UILabel * lab2 = [[UILabel alloc] initWithFrame:CGRectMake(20, viewY + 30, 250, viewH)];
    lab2.text = text2;
    lab2.textColor = [UIColor whiteColor];
    [lab2 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22]];
    [view addSubview:lab2];
    
    return view;
}

- (void)fetchBanners:(NSString *)city {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:SharedConfig.brand_id forKey:@"brand_id"];
    if (self.bannerType == 0) {
        [param setObject:@"1" forKey:@"type"];
    }
    if (self.bannerType == 1) {
        [param setObject:@"0" forKey:@"type"];
    }
    
    if (city && city.length > 0) {
        [param setObject:city forKey:@"city"];
    }
    [MCSessionManager.shareManager mc_POST:@"/user/app/slideshow/query/brandid" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        self.infos = resp.result;
        NSMutableArray *imgUrls = [NSMutableArray new];
        for (NSDictionary *item in self.infos) {
            [imgUrls addObject:item[@"imgurl"]];
        }
        self.banner.imageURLStringsGroup = imgUrls;
        if (imgUrls.count) {
            [self getHeightWith:imgUrls.firstObject];
        }
    }];
    
}

//  下载第一张图片设置高度
- (void)getHeightWith:(NSString *)url_0 {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url_0]];
           UIImage *img = [UIImage imageWithData:imgData];
        if (!img) {
            if (self.resetHeightBlock) {
                CGFloat h = SCREEN_WIDTH/2;
                self.banner.ly_height = h;
                self.resetHeightBlock(h);
            }
            return;
        }
        
        CGFloat rate = img.size.height / img.size.width; // 高宽比
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.resetHeightBlock) {
                CGFloat h = rate*self.frame.size.width;
                self.banner.ly_height = h;
                self.resetHeightBlock(h);
            }
        });
    });
}


#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self fetchBanners:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        NSString *city = nil;
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            NSLog(@"%@",placemark.name);
            //获取城市
            city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
        }
        if (!self.isFetch) {
            [self fetchBanners:city];
        }
        self.isFetch = YES;
    }];
    [manager stopUpdatingLocation];
}


- (NSMutableArray<NSDictionary *> *)infos {
    if (!_infos) {
        _infos = [NSMutableArray new];
    }
    return _infos;
}
- (SDCycleScrollView *)banner {
    if (!_banner) {
        _banner = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:self placeholderImage:nil];
        _banner.backgroundColor = [UIColor clearColor];
    }
    return _banner;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSString *url = self.infos[index][@"url"];
    NSString *title = self.infos[index][@"title"];
    if (title.length != 0) {
        [MCPagingStore pushWebWithTitle:title classification:@"功能跳转"];
    }
}
- (void)reloadImg
{
    [self fetchBanners:nil];
}
@end
