//
//  MCRunTextView.h
//  MCOEM
//
//  Created by SS001 on 2020/3/28.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCRunTextView : UIView

/** 是否显示标签文字 */
@property (nonatomic, assign, getter=isShowMark) IBInspectable BOOL showMark;

@end

NS_ASSUME_NONNULL_END
