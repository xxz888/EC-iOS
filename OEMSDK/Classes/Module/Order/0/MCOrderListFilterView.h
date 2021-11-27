//
//  MCOrderListFilterView.h
//  MCOEM
//
//  Created by wza on 2020/4/25.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STModal.h"
#import "MCFilterButton.h"
#import "MCOrderListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCOrderFilterModel : NSObject

@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) BOOL isSelected;

@end






@protocol MCOrderListFilterViewDelegate <NSObject>

- (void)filterDidChangedTypes:(NSMutableArray<MCOrderFilterModel *> *)types status:(NSMutableArray<MCOrderFilterModel *> *)status;

@end

@interface MCOrderListFilterView : UIView

@property(nonatomic, strong) STModal *statusModal;
@property(nonatomic, strong) STModal *typeModal;
@property(nonatomic, strong) MCFilterButton *typeButton;
@property(nonatomic, strong) MCFilterButton *statusButton;


@property(nonatomic, strong) UIView *typeView;
@property(nonatomic, strong) UIView *statusView;


@property(nonatomic, weak) id<MCOrderListFilterViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame type:(MCOrderListType)type;

@end

NS_ASSUME_NONNULL_END
