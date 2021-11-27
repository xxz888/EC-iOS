//
//  MCBankStore.h
//  Project
//
//  Created by Li Ping on 2019/6/24.
//  Copyright © 2019 LY. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface MCBankCardInfo : NSObject

@property (nonatomic, strong) UIImage *logo;
@property (nonatomic, copy) UIColor *cardCellBackgroundColor;

- (instancetype)initWithLogo:(UIImage *)logo cardCellBackgroundColor:(UIColor *)color;

@end







@interface MCBankStore : NSObject

+ (MCBankCardInfo *)getBankCellInfoWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
