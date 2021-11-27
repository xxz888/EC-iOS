//
//  KDSearchView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KDSearchViewDelegate <NSObject>

- (void)inputTextFieldString:(NSString *)searchText;

@end

@interface KDSearchView : UIView

@property (nonatomic, weak) id<KDSearchViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
