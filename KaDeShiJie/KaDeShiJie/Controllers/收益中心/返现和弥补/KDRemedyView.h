//
//  KDRemedyView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDCreditExtensionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDRemedyView : UIView
- (void)showView;
@property (nonatomic, strong) KDCreditExtensionModel *creditExtensionModel;
@end

NS_ASSUME_NONNULL_END
