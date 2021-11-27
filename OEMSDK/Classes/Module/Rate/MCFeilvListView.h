//
//  MCFeilvListView.h
//  MCOEM
//
//  Created by wza on 2020/4/25.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCFeilvModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCFeilvListView : UIView

@property(nonatomic, copy) NSMutableArray<NSMutableArray<MCFeilvModel *> *> *feilvDataSource;

@end

NS_ASSUME_NONNULL_END
