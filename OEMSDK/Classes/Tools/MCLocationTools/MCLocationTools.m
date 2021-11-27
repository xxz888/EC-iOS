//
//  MCLocationTools.m
//  MCOEM
//
//  Created by SS001 on 2020/3/28.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCLocationTools.h"
#import <CoreLocation/CoreLocation.h>       // 为了访问当前位置

@interface MCLocationTools ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *mgr;
@end

@implementation MCLocationTools
static MCLocationTools *_tools = nil;


- (CLLocationManager *)mgr
{
    if (!_mgr) {
        _mgr = [[CLLocationManager alloc] init];
        _mgr.delegate = self;
        _mgr.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _mgr;
}

+ (instancetype)share
{
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        if (_tools == nil) {
            _tools = [[self alloc] init];
        }
    });
    return _tools;
}

- (void)getlocationName:(LocationName)location
{
    [self.mgr requestWhenInUseAuthorization];
    [self.mgr startUpdatingLocation];
    _location = location;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (locations.count == 0) {
        return;
    }
    [manager stopUpdatingLocation];
    CLLocation *newLocation = locations.firstObject;
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler: ^(NSArray *placemarks,NSError *error) {
        for (CLPlacemark *placeMark in placemarks)
        {
            NSDictionary *addressDic=placeMark.addressDictionary;//地址的所有信息
            
            NSString *province = [addressDic objectForKey:@"State"];//省。直辖市  江西省
            NSString *city = [addressDic objectForKey:@"City"];//市  丰城市
            NSString *area =[addressDic objectForKey:@"SubLocality"];//区
            self.location(province, city, area);
        }
    }];
}
@end
