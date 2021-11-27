




#import <UIKit/UIKit.h>

@interface UILabel (Extension)

//------ 创建标签 ------//
+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text font:(CGFloat)font alpha:(CGFloat)alpha textColor:(UIColor *)textColor aliment:(NSTextAlignment)aliment;
//------ 创建标签 ------//
+ (UILabel *)labelWithFrame:(CGRect)frame backgroundColor:(UIColor *)bgColor text:(NSString *)text textColor:(UIColor *)textColor aliment:(NSTextAlignment)aliment font:(UIFont *)font;
/**
 初始化UILabel
 
 @param frame 尺寸
 @param text 文字
 @param textColor 文字颜色
 @param alignment 文字对齐方式
 @param font 文字字体
 @return 返回UILabel
 */
+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)alignment font:(UIFont *)font;
@end
