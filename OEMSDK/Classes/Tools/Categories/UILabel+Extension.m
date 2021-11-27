#import "UILabel+Extension.h"

@implementation UILabel (Extension)
+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text font:(CGFloat)font alpha:(CGFloat)alpha textColor:(UIColor *)textColor aliment:(NSTextAlignment)aliment {
    
    UILabel *label =[[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.alpha = alpha;
    label.textColor = textColor;
    label.textAlignment = aliment;
    label.font = [UIFont systemFontOfSize:font];
    return label;
}
+ (UILabel *)labelWithFrame:(CGRect)frame backgroundColor:(UIColor *)bgColor text:(NSString *)text textColor:(UIColor *)textColor aliment:(NSTextAlignment)aliment font:(UIFont *)font {
    
    UILabel *label =[[UILabel alloc]initWithFrame:frame];
    label.backgroundColor = bgColor;
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = aliment;
    label.font = font;
    return label;
}
/**
 初始化UILabel
 
 @param frame 尺寸
 @param text 文字
 @param textColor 文字颜色
 @param alignment 文字对齐方式
 @param font 文字字体
 @return 返回UILabel
 */
+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)alignment font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = alignment;
    label.font = font;
    
    return label;
}

@end
