//
//  FormValidator.h
//  Design
//
//  Created by fanghailong on 15/6/23.
//  Copyright (c) 2015年 ptteng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormValidator : NSObject<UIAlertViewDelegate>

+(CGRect)rectWidthAndHeightWithStr:(NSString *)str AndFont:(CGFloat)fontFloat;

+(CGRect)rectWidthAndHeightWithStr:(NSString *)str AndFont:(CGFloat)fontFloat WithStrWidth:(CGFloat)widh;


+ (BOOL)isBlankString:(NSString *)string;

#pragma mark --- 手机号验证
+ (BOOL)validateMobile:(NSString *)mobile;

//------ 1. 获取当前时间戳 ------//
+ (NSString *)getCurrentTimeStamp;
//------ 2. 读取本地json ------//
+ (NSMutableArray *)getLocalJson:(NSString *)jsonName;
//------ 3. 获取今年指定月的天数 ------//
+ (NSInteger)howManyDaysInThisMonth:(NSInteger)imonth;
//------ 4. 获取当前的年月 ------//
+ (NSArray *)years;
/**
 *  ios比较日期大小默认会比较到秒
 *  @return 1 第一个时间靠后  -1 第一个时间靠前  0 两个时间相同
 */
+ (int)junc_CompareOneDate:(NSDate *)oneDate withAnotherDate:(NSDate *)anotherDate;
//  入参是NSString类型
+ (int)junc_CompareOneDateStr:(NSString *)oneDateStr withAnotherDateStr:(NSString *)anotherDateStr;
/**
 * 开始到结束的时间差
 */
+ (int)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
//------ 5. 将数字转为每隔3位整数由逗号“,”分隔的字符串 ------//
+ (NSString *)separateNumberUseCommaWith:(NSString *)number;
//------ 6. 根据颜色生成图片 ------//
+ (UIImage *)imageWithFrame:(CGRect)frame color:(UIColor *)color alpha:(CGFloat)alpha;
//------ 8. 判断身份证号 ------//
+ (BOOL)judgeIdentityStringValid:(NSString *)identityString;
//------ 9.根据时间判断星期几 ------//
+ (NSString *)getWeekWithDateString:(NSString *)dateStr;
/*
 view 是要设置渐变字体的控件   bgVIew是view的父视图  colors是渐变的组成颜色  startPoint是渐变开始点 endPoint结束点
 */
+ (void)TextGradientView:(UIView *)view bgView:(UIView *)bgView gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
/*
 获取今天之前或之后的天数日期
 */
+ (NSMutableArray *)getDaysDateFromTodayWithNumber:(int)number dateFormat:(NSString *)dateFormat isBefore:(BOOL)before;
/** 等比例缩放图片 */
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
/** 修改图片尺寸 */
+ (UIImage *)scaleToSize:(UIImage*)img size:(CGSize)size;
/** 修改字符串中字符大小和颜色 */
+ (NSMutableAttributedString *)changeOriginalString:(NSString *)OriginalString changeString:(NSString *)changeString changeFont:(UIFont *)changeFont changeColor:(UIColor *)changeColor isSpace:(BOOL)space;



@end
