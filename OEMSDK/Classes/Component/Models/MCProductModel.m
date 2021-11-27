//
//  MCProductModel.m
//  MCOEM
//
//  Created by wza on 2020/4/17.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCProductModel.h"
#import "FormValidator.h"
@implementation MCProductModel



+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

- (CGFloat)updateCellHeight{
        // 说明一的高度
        CGRect rectOne = [FormValidator rectWidthAndHeightWithStr:self.earningsState AndFont:14 WithStrWidth:SCREEN_WIDTH-70];
        // 说明二的高度
        CGRect rectTwo = [FormValidator rectWidthAndHeightWithStr:self.upgradestate AndFont:14 WithStrWidth:SCREEN_WIDTH-70];
    
        CGFloat cellHeight = 90 + rectOne.size.height + rectTwo.size.height;
    
    
    return cellHeight;
}

- (NSString *)isBuy {
    BOOL b = self.grade.intValue > SharedUserInfo.grade.intValue;
    if (b) {
        return @"0";
    } else {
        return @"1";
    }
}

@end
