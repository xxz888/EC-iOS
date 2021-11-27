


#import "FormValidator.h"

@implementation FormValidator

+(CGRect)rectWidthAndHeightWithStr:(NSString *)str AndFont:(CGFloat)fontFloat
{
    CGRect fcRect = [str boundingRectWithSize:CGSizeMake(150, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontFloat]} context:nil];
    return fcRect;
}

+(CGRect)rectWidthAndHeightWithStr:(NSString *)str AndFont:(CGFloat)fontFloat WithStrWidth:(CGFloat)widh
{
    CGRect fcRect = [str boundingRectWithSize:CGSizeMake(widh, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontFloat]} context:nil];
    return fcRect;
}

+ (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        
        return YES;
    }
    
    return NO;
}

#pragma mark --- 手机号验证
+ (BOOL)validateMobile:(NSString *)mobile {
    
    //    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$";
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//------ 获取当前时间戳 ------//
+ (NSString *)getCurrentTimeStamp {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];
    ;
    return timeString;
}
//------ 读取本地json ------//
+ (NSMutableArray *)getLocalJson:(NSString *)jsonName {
    
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"]];
    
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    
    NSMutableArray *newArray = [NSMutableArray array];
    
    for (NSDictionary *dict in dataArray) {
        
        [newArray addObject:dict];
    }
    return newArray;
}

//------ 获取今年指定月的天数 ------//
+ (NSInteger)howManyDaysInThisMonth:(NSInteger)imonth {
    
    int year = [[FormValidator years][0] intValue];
    
    // 如果不指定月数，则显示当前月
    if (imonth == 0) {
        
        imonth = [[FormValidator years][1] intValue];
    }
    
    if((imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
        
        return 31 ;
    
    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
        
        return 30;
    
    if((year%4 == 1)||(year%4 == 2)||(year%4 == 3))
        
        return 28;
    
    if(year%400 == 0)
        
        return 29;
    
    if(year%100 == 0)
        
        return 28;
    
    return 29;
    
}
//------ 获取当前的年月 ------//
+ (NSArray *)years {
    NSMutableArray *yearArr = [[NSMutableArray alloc]init];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    [yearArr addObject:@(year)];
    [yearArr addObject:@(month)];
    [yearArr addObject:@(day)];
    return yearArr;
    
}
/**
 *  ios比较日期大小默认会比较到秒
 *  @return 1 第一个时间靠后  -1 第一个时间靠前  0 两个时间相同
 */
+ (int)junc_CompareOneDate:(NSDate *)oneDate withAnotherDate:(NSDate *)anotherDate {
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    
    NSString *oneDayStr = [df stringFromDate:oneDate];
    
    NSString *anotherDayStr = [df stringFromDate:anotherDate];
    
    NSDate *dateA = [df dateFromString:oneDayStr];
    
    NSDate *dateB = [df dateFromString:anotherDayStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    
    if (result == NSOrderedAscending)
    {  // oneDate < anotherDate
        return 1;
        
    }else if (result == NSOrderedDescending)
    {  // oneDate > anotherDate
        return -1;
    }
    
    // oneDate = anotherDate
    return 0;
}

//  入参是NSString类型
+ (int)junc_CompareOneDateStr:(NSString *)oneDateStr withAnotherDateStr:(NSString *)anotherDateStr {
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dateA = [[NSDate alloc]init];
    
    NSDate *dateB = [[NSDate alloc]init];
    
    dateA = [df dateFromString:oneDateStr];
    
    dateB = [df dateFromString:anotherDateStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    
    if (result == NSOrderedAscending)
    {  // oneDateStr < anotherDateStr
        return 1;
        
    }else if (result == NSOrderedDescending)
    {  // oneDateStr > anotherDateStr
        return -1;
    }
    
    // oneDateStr = anotherDateStr
    return 0;
}
/**
 * 开始到结束的时间差
 */
+ (int)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
//    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
//    int second = (int)value % 60;//秒
//    int minute = (int)value / 60 % 60;
//    int house = (int)value / (24 * 3600) % 3600;
    int day = (int)value / (24 * 3600);
    
//    if (day != 0) {
//        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];
//    }else if (day==0 && house !=0) {
//        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
//    }else if (day==0 && house==0 && minute!=0) {
//        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
//    }else{
//        str = [NSString stringWithFormat:@"耗时%d秒",second];
//    }
    return day;
}
//------ 将数字转为每隔3位整数由逗号“,”分隔的字符串 ------//
+ (NSString *)separateNumberUseCommaWith:(NSString *)number {
    // 前缀
    NSString *prefix = @"";
    // 后缀
    NSString *suffix = @"";
    // 分隔符
    NSString *divide = @",";
    NSString *integer = @"";
    NSString *radixPoint = @"";
    BOOL contains = NO;
    if ([number containsString:@"."]) {
        contains = YES;
        // 若传入浮点数，则需要将小数点后的数字分离出来
        NSArray *comArray = [number componentsSeparatedByString:@"."];
        integer = [comArray firstObject];
        radixPoint = [comArray lastObject];
    } else {
        integer = number;
    }
    // 将整数按各个字符为一组拆分成数组
    NSMutableArray *integerArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < integer.length; i ++) {
        NSString *subString = [integer substringWithRange:NSMakeRange(i, 1)];
        [integerArray addObject:subString];
    }
    // 将整数数组倒序每隔3个字符添加一个逗号“,”
    NSString *newNumber = @"";
    for (NSInteger i = 0 ; i < integerArray.count ; i ++) {
        NSString *getString = @"";
        NSInteger index = (integerArray.count-1) - i;
        if (integerArray.count > index) {
            getString = [integerArray objectAtIndex:index];
        }
        BOOL result = YES;
        if (index == 0 && integerArray.count%3 == 0) {
            result = NO;
        }
        if ((i+1)%3 == 0 && result) {
            newNumber = [NSString stringWithFormat:@"%@%@%@",divide,getString,newNumber];
        } else {
            newNumber = [NSString stringWithFormat:@"%@%@",getString,newNumber];
        }
    }
    if (contains) {
        newNumber = [NSString stringWithFormat:@"%@.%@",newNumber,radixPoint];
    }
    if (![prefix isEqualToString:@""]) {
        newNumber = [NSString stringWithFormat:@"%@%@",prefix,newNumber];
    }
    if (![suffix isEqualToString:@""]) {
        newNumber = [NSString stringWithFormat:@"%@%@",newNumber,suffix];
    }
    return newNumber;
}
//------ 根据颜色生成图片 ------//
+ (UIImage *)imageWithFrame:(CGRect)frame color:(UIColor *)color alpha:(CGFloat)alpha {
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetAlpha(context, alpha);
    CGContextFillRect(context, frame);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
//------ 判断身份证号 ------//
+ (BOOL)judgeIdentityStringValid:(NSString *)identityString {
    
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    //  NSString *regex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}
//------ 根据时间判断星期几 ------//
+ (NSString *)getWeekWithDateString:(NSString *)dateStr {
    
    /* 2017-06-22 */
    NSString *weekStr = @"";
    NSString *year = [dateStr substringToIndex:4];
    NSString *month = [dateStr substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [dateStr substringFromIndex:8];
    
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[day intValue]];
    [_comps setMonth:[month intValue]];
    [_comps setYear:[year intValue]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger _weekday = [weekdayComponents weekday];
    
    switch (_weekday) {
        case 1: {
            
            weekStr = @"星期日";
            break;
        }
        case 2: {
            
            weekStr = @"星期一";
            break;
        }
        case 3: {
            
            weekStr = @"星期二";
            break;
        }
        case 4: {
            
            weekStr = @"星期三";
            break;
        }
        case 5: {
            
            weekStr = @"星期四";
            break;
        }
        case 6: {
            
            weekStr = @"星期五";
            break;
        }
        case 7: {
            
            weekStr = @"星期六";
            break;
        }
            
        default:
            break;
    }
    return weekStr;
}
/*
 view 是要设置渐变字体的控件   bgVIew是view的父视图  colors是渐变的组成颜色  startPoint是渐变开始点 endPoint结束点
 */
+ (void)TextGradientView:(UIView *)view bgView:(UIView *)bgView gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = view.frame;
    gradientLayer1.colors = colors;
    gradientLayer1.startPoint =startPoint;
    gradientLayer1.endPoint = endPoint;
    [bgView.layer addSublayer:gradientLayer1];
    gradientLayer1.mask = view.layer;
    view.frame = gradientLayer1.bounds;
}
/*
 获取今天之前或之后的天数日期
 */
+ (NSMutableArray *)getDaysDateFromTodayWithNumber:(int)number dateFormat:(NSString *)dateFormat isBefore:(BOOL)before {
    
    NSMutableArray *daysArr = [NSMutableArray array];
    NSDate *nowDate = [NSDate date];
    NSDate *theDate;
    NSTimeInterval oneDay = 24*60*60*1;  //1天的长度
    //之前的天数
    if (before) {
        
        for (int i = number; i >= 0; i--) {
            
            theDate = [nowDate initWithTimeIntervalSinceNow:-oneDay * i];
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:dateFormat];// yyyy-MM-dd
            //用[NSDate date]可以获取系统当前时间
            NSString * currentDateStr = [dateFormatter stringFromDate:theDate];
            [daysArr addObject:currentDateStr];
        }
    }else {
       
        for (int i = 0; i < number; i++) {
            
            theDate = [nowDate initWithTimeIntervalSinceNow:+oneDay * i];
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:dateFormat];// yyyy-MM-dd
            //用[NSDate date]可以获取系统当前时间
            NSString * currentDateStr = [dateFormatter stringFromDate:theDate];
            [daysArr addObject:currentDateStr];
        }
    }
    return daysArr;
}
/** 等比例缩放图片 */
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}
/** 修改图片尺寸 */
+ (UIImage *)scaleToSize:(UIImage*)img size:(CGSize)size {
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}
/** 修改字符串中字符大小和颜色 */
+ (NSMutableAttributedString *)changeOriginalString:(NSString *)OriginalString changeString:(NSString *)changeString changeFont:(UIFont *)changeFont changeColor:(UIColor *)changeColor isSpace:(BOOL)space {
    
    if (space) {
        OriginalString = [OriginalString stringByReplacingOccurrencesOfString:changeString withString:[NSString stringWithFormat:@" %@ ", changeString]];
    }
    NSMutableAttributedString *attDescribeStr = [[NSMutableAttributedString alloc] initWithString:OriginalString];
    [attDescribeStr addAttribute:NSForegroundColorAttributeName value:changeColor range:[OriginalString rangeOfString:changeString]];
    [attDescribeStr addAttribute:NSFontAttributeName value:changeFont range:[OriginalString rangeOfString:changeString]];
    
    return attDescribeStr;
}


@end



















