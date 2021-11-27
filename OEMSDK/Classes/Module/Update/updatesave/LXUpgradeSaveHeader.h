//
//  LXUpgradeSaveHeader.h
//  Project
//
//  Created by Li Ping on 2019/7/22.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCProductModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXUpgradeSaveHeader : UIView

- (instancetype)initWithGrades:(NSArray <MCProductModel *> *)grades;

@end

NS_ASSUME_NONNULL_END
