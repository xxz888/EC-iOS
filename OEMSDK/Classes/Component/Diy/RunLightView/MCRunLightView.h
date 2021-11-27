//
//  MCRunLightView.h
//  Project
//
//  Created by Ning on 2019/11/18.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MCScrollText;
@interface MCRunLightView : UIView
/** 左侧喇叭视图 */
@property(nonatomic,readwrite,strong)  UIImageView *iconeImageView;
/** 跑马灯视图 */
@property(nonatomic,readwrite,strong)  MCScrollText *scrololerView;

@property (nonatomic, strong) UILabel *leftLabel;

@end

NS_ASSUME_NONNULL_END
