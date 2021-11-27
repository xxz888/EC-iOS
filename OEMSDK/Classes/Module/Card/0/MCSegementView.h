//
//  MCSegementView.h
//  MCOEM
//
//  Created by wza on 2020/4/24.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MCSegementViewDelegate <NSObject>

- (void)segementViewDidSeletedIndex:(NSInteger)index buttonTitle:(NSString *)title;

@end


@interface MCSegementView : UIView

@property(nonatomic, weak) id<MCSegementViewDelegate> delegate;

@property(nonatomic, copy) NSArray<NSString *> *titles;

@property(nonatomic, assign, readonly) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
