//
//  MCCustomMenuView.m
//  Project
//
//  Created by Ning on 2019/11/5.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCCustomMenuView.h"
#import "MCMenuItemView.h"
#import "MCDataProfessor.h"
#import "MCMenuManager.h"
#import "LHMainView.h"


@interface MCCustomMenuView ()<MCMenuItemViewDelegate, LHMainViewDelegate>

@end
@implementation MCCustomMenuView

#pragma mark - Public Methods
- (instancetype)initWithFrame:(CGRect)frame
                     dataType:(MCCustomMenuViewDataType)dataType{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataType = dataType;
        [self p_baseDataSet];
        [self p_setUI];
        [self refreshData];
    }
    return self;
}

- (void) refreshData{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self p_getMenuComponentData];
    });
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self p_setUI];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //    if (self.menuViewHeight) {
    //        self.menuViewHeight(self.height);
    //    }
}
/// 自定义视图的位置
/// @param lineSpacing 行间距
/// @param rowSpacing 列间距
/// @param menuWidth 单个视图宽度
/// @param menuHeight 单个视图高度
- (void) resetLineSpacing:(CGFloat)lineSpacing
               rowSpacing:(CGFloat)rowSpacing
                menuWidth:(CGFloat)menuWidth
               menuHeight:(CGFloat)menuHeight{
    for (NSInteger i = 0; i < self.menuItemArray.count; i++) {
        MCMenuItemView* itemView = self.menuItemArray[i];
        itemView.frame = CGRectMake(rowSpacing + i%self.columnn * (menuWidth + rowSpacing),lineSpacing + i/self.columnn * (menuHeight + lineSpacing),menuWidth, menuHeight);
        [itemView refreshUI];
    }
    //计算高度
    self.height = lineSpacing * (self.row+1) + menuHeight*self.row;
    if (self.menuViewHeight) {
        if (self.height > 0) {
            self.menuViewHeight(self.height);
        }
    }
}

#pragma mark - Private Methods
/// 界面设置
- (void) p_setUI{
    self.row = 0;
    self.columnn = 1;
    self.rowSpacing = 10;
    self.lineSpacing = 10;
    self.backgroundColor = [UIColor whiteColor];
}
- (void) p_baseDataSet{
    if (!self.itemColor) {
        self.itemColor = [UIColor whiteColor];
    }
    if (!self.itemFont) {
        self.itemFont = [UIFont systemFontOfSize:14];
    }
}
- (void) p_getMenuComponentData{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:BCFI.brand_id forKey:@"brandId"];
    
    __weak __typeof(self)weakSelf = self;
    
    [MCLATESTCONTROLLER.sessionManager mc_POST:@"/user/app/select/topup/home/Selectagreement/" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        [self p_parseDataSource:resp.result[@"content"]];
    }];
}

- (void)p_parseDataSource:(NSArray*)datasource{
    switch (self.dataType) {
        case MCCustomMenuViewTypeMain:{
            self.datasource = [[MCDataProfessor sharedConfig] getShelvesWithDatasource:datasource isMain:YES].mutableCopy;
        }
            break;
        case MCCustomMenuViewTypeVice:{
            self.datasource = [[MCDataProfessor sharedConfig] getShelvesWithDatasource:datasource isMain:NO].mutableCopy;
        }
            break;
        default:
            break;
    }
}

#pragma mark - 初始化列表
- (void) configMenuList{
    self.row = [[MCDataProfessor sharedConfig] getMaxRow:self.datasource];
    self.columnn = [[MCDataProfessor sharedConfig] getMaxColumnn:self.datasource];
    
    // 默认高度
    CGFloat width  = (SCREEN_WIDTH - (self.columnn+1)*self.rowSpacing)/self.columnn;
    
    if (!self.itemHeight && self.itemHeight <= 0) {self.itemHeight = kMenuHeight;}
    
    if (self.dataType == MCCustomMenuViewTypeMain) {
        LHMainView *mainView = [[LHMainView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
        mainView.delegate = self;
        mainView.dataArray = self.datasource;
        [self addSubview:mainView];
        
        self.height = 180;
        self.menuViewHeight(180);
    } else {
        for (NSUInteger i = 0; i < self.datasource.count; i++) {
            NSDictionary* menuDictionary = self.datasource[i];
            NSInteger row = [[NSString stringWithFormat:@"%@",menuDictionary[@"row"]] integerValue]-1;
            NSInteger columnn = [[NSString stringWithFormat:@"%@",menuDictionary[@"columnn"]] integerValue]-1;
            
            MCMenuItemView* itemView = [[MCMenuItemView alloc] initWithFrame:CGRectMake(self.rowSpacing + columnn * (width + self.rowSpacing),self.lineSpacing + row * (self.itemHeight + self.lineSpacing),width, self.itemHeight)];
            
            itemView.tag = i;
            itemView.delegate = self;
            //属性设置
            itemView.iconeWidth = self.iconeWidth;
            itemView.iconeHeight = self.iconeHeight;
            
            itemView.spacing = self.spacing;
            
            [itemView updataBackgroundColor:self.itemColor titlesFont:self.itemFont iconeWidth:self.iconeWidth iconeHeight:self.iconeHeight];
            [itemView updataWithDataSource:menuDictionary];
            [self addSubview:itemView];
            
            [self.menuItemArray addObject:itemView];
            [self.sortArray addObject:menuDictionary];
            
            itemView.layer.cornerRadius = 5;
            itemView.layer.masksToBounds = YES;
            
        }
        //计算高度
        self.height = self.lineSpacing * (self.row+1) + self.itemHeight*self.row;
        if (!self.menuViewHeight && self.height <=0) {return;}
        self.menuViewHeight(self.height);
    }
}

- (void) p_clearView{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark - Protocol Methods
- (void)didSeletedMenuItemWithTag:(NSUInteger)aTag{
    if (self.didSeletedMenuItemWithSeletedItemIndexAndSeletedDictionary) {
        self.didSeletedMenuItemWithSeletedItemIndexAndSeletedDictionary(aTag, self.sortArray[aTag]);
    }
    [[MCMenuManager sharedConfig] pushModuleWithData:self.sortArray[aTag]];
}
- (void)didSeletedMainViewWithTag:(NSUInteger)aTag
{
    if (self.didSeletedMenuItemWithSeletedItemIndexAndSeletedDictionary) {
        self.didSeletedMenuItemWithSeletedItemIndexAndSeletedDictionary(aTag, self.sortArray[aTag]);
    }
    [[MCMenuManager sharedConfig] pushModuleWithData:self.datasource[aTag]];
}
#pragma mark - Setter And Getter Method
- (void)setHeight:(CGFloat)height{
    _height = height;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,height);
}

- (void)setDatasource:(NSMutableArray *)datasource{
    _datasource = datasource;
    [self p_clearView];
    //初始化列表
    [self configMenuList];
}

- (NSMutableArray*) menuItemArray {
    if (nil == _menuItemArray) {
        _menuItemArray = [[NSMutableArray alloc] init];
    }
    return _menuItemArray;
}

- (NSMutableArray*) sortArray {
    if (nil == _sortArray) {
        _sortArray = [[NSMutableArray alloc] init];
    }
    return _sortArray;
}
@end
