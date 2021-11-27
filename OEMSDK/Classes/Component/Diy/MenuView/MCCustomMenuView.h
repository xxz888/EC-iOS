//
//  MCCustomMenuView.h
//  Project
//
//  Created by Ning on 2019/11/5.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRow                4   // 列数
#define kRowSpacing         10  // 列间距
#define kLineSpacing        10  // 行间距

#define kMenuHeight         80.0f // item高度

//#define KMainHight          180.0f // 主功能区高度
//#define kMenuWidth          (self.frame.size.width - (kRowSpacing * (kRow+1))) / kRow


typedef NS_ENUM(NSInteger, MCCustomMenuViewDataType){
    MCCustomMenuViewTypeMain,//主功能区
    MCCustomMenuViewTypeVice,//副功能区
};

typedef  void (^MCMenuViewHeight)(CGFloat menuViewHeight);
typedef  void (^DidSeletedMenuItemWithSeletedItemIndexAndSeletedDictionary)(NSInteger seletedItemIndex,NSDictionary* _Nullable seletedDictionary);



NS_ASSUME_NONNULL_BEGIN

@interface MCCustomMenuView : UIView

/*************************图标相关设置***********************************/
/** 图片宽度*/
@property(nonatomic,readwrite,assign)  CGFloat  iconeWidth;
/** 图片高度*/
@property(nonatomic,readwrite,assign)  CGFloat  iconeHeight;

/*************************item相关设置***********************************/
/** 背景颜色 */
@property(nonatomic,readwrite,strong)  UIColor *itemColor;

/** 字体大小 */
@property(nonatomic,readwrite,strong)  UIFont  *itemFont;

@property(nonatomic,readwrite,assign)  CGFloat  itemHeight;

/** 默认列间距 10  */
@property(nonatomic,readwrite,assign)  NSUInteger  rowSpacing;

/** 默认列间距 10  */
@property(nonatomic,readwrite,assign)  NSUInteger  lineSpacing;

/** 图片和标题间距 默认是3 */
@property(nonatomic,readwrite,assign)  CGFloat    spacing;

/** 数据源 */
@property(nonatomic,readwrite,strong)  NSMutableArray *datasource;
/** 视图容器 */
@property(nonatomic,readwrite,strong)  NSMutableArray *menuItemArray;
/** 排序后的正常数据 */
@property(nonatomic,readwrite,strong)  NSMutableArray *sortArray;
/** 行数 */
@property(nonatomic,readwrite,assign)  NSInteger row;
/** 列数 */
@property(nonatomic,readwrite,assign)  NSInteger columnn;
/** 视图总高度 */
@property(nonatomic,readwrite,assign)  CGFloat height;
/** 功能区类型 */
@property(nonatomic,readwrite,assign)  MCCustomMenuViewDataType dataType;

/** 视图总高度 */
@property(nonatomic,readwrite,copy)  MCMenuViewHeight menuViewHeight;
@property(nonatomic,readwrite,copy)  DidSeletedMenuItemWithSeletedItemIndexAndSeletedDictionary didSeletedMenuItemWithSeletedItemIndexAndSeletedDictionary;

/// 初始化
/// @param frame 位置
/// @param dataType 功能区类型
- (instancetype)initWithFrame:(CGRect)frame
                     dataType:(MCCustomMenuViewDataType)dataType;

/// 自定义视图的位置
/// @param lineSpacing 行间距
/// @param rowSpacing 列间距
/// @param menuWidth 单个视图宽度
/// @param menuHeight 单个视图高度
- (void) resetLineSpacing:(CGFloat)lineSpacing
               rowSpacing:(CGFloat)rowSpacing
                menuWidth:(CGFloat)menuWidth
                menuHeight:(CGFloat)menuHeight;

/**
 * 数据请求
 */
- (void) refreshData;

/**
 * 子类覆盖该方法布局其他视图
 */
- (void) configMenuList;

@end

NS_ASSUME_NONNULL_END
