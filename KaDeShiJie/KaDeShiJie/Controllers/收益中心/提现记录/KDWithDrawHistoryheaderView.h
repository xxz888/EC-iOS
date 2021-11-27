//
//  KDWithDrawHistoryheaderView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDHistoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDWithDrawHistoryheaderView : UIView
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) KDHistoryModel *model;
@end

NS_ASSUME_NONNULL_END
