//
//  SigleBankCardVC.h
//  Project
//
//  Created by liuYuanFu on 2019/6/4.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SigleBankCardVC : MCBaseViewController
// 定义一个选择辨识用户点击后的 枚举类型
typedef enum : NSInteger {
    LTFenLeiType = 0,    // 分类收益
    LTMeiRiType = 1 << 1,// 每日
}LTOptionBtType;
//定义枚举变量
@property(nonatomic,assign)LTOptionBtType optionBtType;
// 热线/图标/名称
@property(nonatomic,strong)NSArray *singleArr;

@property (nonatomic,strong)NSArray *cellArr;
@end

NS_ASSUME_NONNULL_END
