//
//  MCIncomeRateModel.m
//  MCOEM
//
//  Created by SS001 on 2020/4/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCIncomeRateModel.h"

@implementation MCIncomeRateModel

- (UIImage *)icon {
    UIImage *img = [UIImage mc_imageNamed:@"incomeRate_logo"];
    return img;
}


- (NSString *)phone {
    if (_phone.length < 4) {
        return @"";
    }
    NSString *prePhone = [_phone substringToIndex:3];
    NSString *sufPohne = [_phone substringFromIndex:_phone.length - 4];
    return [NSString stringWithFormat:@"%@ **** %@", prePhone, sufPohne];
}

- (NSString *)name {
    if (_name.length < 1) {
        return @"";
    }
    NSString *preName = [_name substringToIndex:1];
    if (_name.length == 1) {
        return _name;
    } else if (_name.length == 2) {
        return [NSString stringWithFormat:@"%@*", preName];
    } else {
        
        NSMutableString *mutableName = [NSMutableString stringWithString:preName];
        for (int i = 0 ; i < _name.length - 2; i++) {
            [mutableName appendString:@"*"];
        }
        NSString *sufName = [_name substringFromIndex:_name.length - 1];
        [mutableName appendString:sufName];
        
        return mutableName;
    }
}

@end
