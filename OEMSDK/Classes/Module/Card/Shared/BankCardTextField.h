//
//  BankCardTextField.h
//  TextFieldDmo
//
//  Created by  on 2019/5/23.
//  Copyright © 2019 . All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


@interface BankCardTextField : UITextField
/**
 *  默认为4，即4个数一组 用空格分隔
 */
@property (assign, nonatomic) NSInteger groupSize;

/**
 *  分隔符 默认为空格
 */
@property (copy, nonatomic) NSString *separator;


/// 忽略分隔符的text
@property(nonatomic, copy) NSString *mc_realText;

@end

@interface UITextField (WYRange)

- (NSRange)selectedRange;

- (void)setSelectedRange:(NSRange)range;

- (void)bankNoshouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end
NS_ASSUME_NONNULL_END
