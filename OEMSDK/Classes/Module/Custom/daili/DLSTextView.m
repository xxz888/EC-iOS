//
//  TextView.m
//  Project
//
//  Created by liuYuanFu on 2019/9/5.
//  Copyright © 2019 LY. All rights reserved.
//

#import "DLSTextView.h"
#import <PGDatePicker/PGDatePickManager.h>
#import "LY_ScrollTextLabel.h"
#import "FormValidator.h"


@interface DLSTextView ()<PGDatePickerDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@property (strong, nonatomic) IBOutlet UIView *dateView;
// 日期
@property (strong, nonatomic) IBOutlet UILabel *dateLb;

// 直交易量
@property (strong, nonatomic) IBOutlet UILabel *zhiJYLLb;
@property (strong, nonatomic) IBOutlet LY_ScrollTextLabel *zhiJYLLB;
// 间交易量
@property (strong, nonatomic) IBOutlet UILabel *jianJYLLb;
@property (strong, nonatomic) IBOutlet LY_ScrollTextLabel *jianJYLLB;

// 直推 总交易量
@property (strong, nonatomic) IBOutlet UILabel *zhiAllLb;
@property (strong, nonatomic) IBOutlet LY_ScrollTextLabel *zhiAllLB;

// 间推 总交易量
@property (strong, nonatomic) IBOutlet UILabel *jianAllLb;
@property (strong, nonatomic) IBOutlet LY_ScrollTextLabel *jianAllLB;

@property (strong, nonatomic) IBOutlet UILabel *zhiLb1;
@property (strong, nonatomic) IBOutlet LY_ScrollTextLabel *zhiLB1;

@property (strong, nonatomic) IBOutlet UILabel *jianLb1;
@property (strong, nonatomic) IBOutlet LY_ScrollTextLabel *jianLB1;

@property (strong, nonatomic) IBOutlet UILabel *zhiLb2;
@property (strong, nonatomic) IBOutlet LY_ScrollTextLabel *zhiLB2;

@property (strong, nonatomic) IBOutlet UILabel *jianLb2;
@property (strong, nonatomic) IBOutlet LY_ScrollTextLabel *jianLB2;

@property (strong, nonatomic) IBOutlet UILabel *zhiLb3;
@property (strong, nonatomic) IBOutlet LY_ScrollTextLabel *zhiLB3;

@property (strong, nonatomic) IBOutlet UILabel *jianLb3;
@property (strong, nonatomic) IBOutlet LY_ScrollTextLabel *jianLB3;

@property (strong, nonatomic) IBOutlet UILabel *zhiLb4;
@property (strong, nonatomic) IBOutlet LY_ScrollTextLabel *zhiLB4;

@property (strong, nonatomic) IBOutlet UILabel *jianLb4;
@property (strong, nonatomic) IBOutlet LY_ScrollTextLabel *jianLB4;

@end

@implementation DLSTextView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)awakeFromNib{
    [super awakeFromNib];
    
    
    
    // 更改view的边属性
    for (int i = 1000; i<1010; i++) {
        UIView *view = [self viewWithTag:i];
        view.layer.cornerRadius = 12.0;
        view.layer.borderColor = LYColor(190, 190, 190).CGColor;
        view.layer.borderWidth = 0.5;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseDatePick:)];
    [self.dateView addGestureRecognizer:tap];
    
    NSDate *now = [NSDate date];
    /* 1.本月 直推间推/总*/
    // 年月
          NSString *strM = [NSString stringWithFormat:@"%@-%@", [self years][0],[self years][1]];
          // 起始年月日:
          NSString *starStrM= [NSString stringWithFormat:@"%@-01",strM];
          // 结束年月日:
          NSString *endStrM = [NSString stringWithFormat:@"%@-%ld",strM,[self howManyDaysInThisYear:[[FormValidator years][1] integerValue] withMonth:[[FormValidator years][1] integerValue]]];
    
    //当月
    [self request_Month_DataForAllRecordInfo:starStrM endDay:endStrM];

    /* 2.总 直推/间推收益 */
         //  今天的年月日
    NSString *starstrAll = [NSString stringWithFormat:@"%@-%@-%@", [self years][0],[self years][1],[self years][2]];
    
    //全部
    [self request_All_DataForAllRecordInfo:@"2019-10-01" endDay:starstrAll];
    
    /* 3.当日 直推间推 */
        //   今天的年月日
    NSString *starstrM = [NSString stringWithFormat:@"%@-%@-%@", [self years][0],[self years][1],[self years][2]];
    [self request_Today_DataForAllRecordInfo:starstrM endDay:starstrM];
    
}

-(void)chooseDatePick:(UITapGestureRecognizer *)tap{
    
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.style = PGDatePickManagerStyleAlertBottomButton;
    datePickManager.isShadeBackground = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.isHiddenMiddleText = false;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerTypeSegment;
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
    [MCLATESTCONTROLLER presentViewController:datePickManager animated:false completion:nil];
    
    
    /* 时间设置 */
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM";
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [dateFormatter stringFromDate:datenow];
    
    datePicker.minimumDate = [dateFormatter dateFromString: @"2016-01"];
    datePicker.maximumDate = [dateFormatter dateFromString: currentTimeString];
    
    NSDate *date = [dateFormatter dateFromString:currentTimeString];
    [datePicker setDate:date animated:false];
    
    
}


#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    NSString *monthStrB;
    NSString *strB;
    if (dateComponents.month<10) {
        monthStrB = [NSString stringWithFormat:@"0%ld",(long)dateComponents.month];
    }else{
        monthStrB = [NSString stringWithFormat:@"%ld",(long)dateComponents.month];
    }
    strB = [NSString stringWithFormat:@"%ld-%@", (long)dateComponents.year,monthStrB];
    self.dateLb.text = strB;
    
    // 起始:
    NSString *starStrB = [NSString stringWithFormat:@"%@-01",strB];
    // 结束:
    NSString *endStrB = [NSString stringWithFormat:@"%@-%ld",strB,[self howManyDaysInThisYear:(long)dateComponents.year withMonth:(long)dateComponents.month]];
    
    [self request_Month_DataForAllRecordInfo:starStrB endDay:endStrB];
}


//接口 1:查询 本月 直推间推/总
- (void)request_Month_DataForAllRecordInfo:(NSString *)startDay endDay:(NSString *)endDay{
    NSString *urlStr = @"/statistics/app/query/team/amount";
    
    /*  */
    NSMutableDictionary *barginDic = [NSMutableDictionary dictionary];
      barginDic[@"startDay"] = startDay;
      barginDic[@"endDay"] = endDay;
    
    [MCLATESTCONTROLLER.sessionManager mc_POST:urlStr parameters:barginDic ok:^(MCNetResponse * _Nonnull resp) {
        
        MCLog(@"查询 本月 直推间推/总");
        
        NSDictionary *response = resp.result;
        NSString *zhiStr3 = [NSString stringWithFormat:@"%.4f",[response[@"directRepayment"] doubleValue]/10000];
        NSString *jianStr3 = [NSString stringWithFormat:@"%.4f",[response[@"indirectRepayment"] doubleValue]/10000];
        NSString *zhiStr4 = [NSString stringWithFormat:@"%.4f",[response[@"directRecharge"] doubleValue]/10000];
        NSString *jianStr4 = [NSString stringWithFormat:@"%.4f",[response[@"indirectRecharge"] doubleValue]/10000];
        
        NSString *zhiJYLStr = [NSString stringWithFormat:@"%.4f",[response[@"directRepayment"] doubleValue]/10000+[response[@"directRecharge"] doubleValue]/10000];
        NSString *jianJYLStr = [NSString stringWithFormat:@"%.4f",[response[@"indirectRepayment"] doubleValue]/10000+[response[@"indirectRecharge"] doubleValue]/10000];

                    self.zhiLb3.hidden = YES;
                    self.jianLb3.hidden = YES;
                    self.zhiLb4.hidden = YES;
                    self.jianLb4.hidden = YES;
        
                    self.zhiJYLLb.hidden = YES;
                    self.jianJYLLb.hidden = YES;

        
        [self valueWithLabel:self.zhiLB3 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font: LYFont(20) labelSpacing:30 pauseInterval:1.7 scrollSpeed:30 fadeLength:12.f isLeft:YES];
        self.zhiLB3.text = zhiStr3?zhiStr3:@"0.00";
        
        [self valueWithLabel:self.jianLB3 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font: LYFont(20) labelSpacing:30 pauseInterval:1.7 scrollSpeed:30 fadeLength:12.f isLeft:YES];
        self.jianLB3.text = jianStr3?jianStr3:@"0.00";
        
        [self valueWithLabel:self.zhiLB4 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font: LYFont(20) labelSpacing:30 pauseInterval:1.7 scrollSpeed:30 fadeLength:12.f isLeft:YES];
        self.zhiLB4.text = zhiStr4?zhiStr4:@"0.00";
        
        [self valueWithLabel:self.jianLB4 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font: LYFont(20) labelSpacing:30 pauseInterval:1.7 scrollSpeed:30 fadeLength:12.f isLeft:YES];
        self.jianLB4.text = jianStr4?jianStr4:@"0.00";
        
        /* 最顶部 */
        [self valueWithLabel:self.zhiJYLLB textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font: LYFont(20) labelSpacing:30 pauseInterval:1.7 scrollSpeed:30 fadeLength:12.f isLeft:YES];
        self.zhiJYLLB.text = zhiJYLStr?zhiJYLStr:@"0.00";
               
        [self valueWithLabel:self.jianJYLLB textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font: LYFont(20) labelSpacing:30 pauseInterval:1.7 scrollSpeed:30 fadeLength:12.f isLeft:YES];
        self.jianJYLLB.text = jianJYLStr?jianJYLStr:@"0.00";
    }];
    
}

//接口 2.查询总交易量
- (void)request_All_DataForAllRecordInfo:(NSString *)startDay endDay:(NSString *)endDay{
    NSString *urlStr = @"/statistics/app/query/team/amount";
    
    /*  */
    NSMutableDictionary *barginDic = [NSMutableDictionary dictionary];
      barginDic[@"startDay"] = startDay;
      barginDic[@"endDay"] = endDay;
    
    [MCLATESTCONTROLLER.sessionManager mc_POST:urlStr parameters:barginDic ok:^(MCNetResponse * _Nonnull okResponse) {
        
        MCLog(@"查下总交易量成功!!!!")
        
        NSDictionary *response = okResponse.result;
//        NSString *zhiStr3 = [NSString stringWithFormat:@"%.4f",[response[@"directRepayment"] doubleValue]/10000];
//        NSString *jianStr3 = [NSString stringWithFormat:@"%.4f",[response[@"indirectRepayment"] doubleValue]/10000];
//        NSString *zhiStr4 = [NSString stringWithFormat:@"%.4f",[response[@"directRecharge"] doubleValue]/10000];
//        NSString *jianStr4 = [NSString stringWithFormat:@"%.4f",[response[@"indirectRecharge"] doubleValue]/10000];
        
        NSString *zhiJYLStr = [NSString stringWithFormat:@"%.4f",[response[@"directRepayment"] doubleValue]/10000+[response[@"directRecharge"] doubleValue]/10000];
        NSString *jianJYLStr = [NSString stringWithFormat:@"%.4f",[response[@"indirectRepayment"] doubleValue]/10000+[response[@"indirectRecharge"] doubleValue]/10000];
        
        self.zhiAllLb.hidden = YES;
        self.jianAllLb.hidden = YES;
        /* 最顶部 */
        [self valueWithLabel:self.zhiAllLB textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font: LYFont(28) labelSpacing:30 pauseInterval:1.7 scrollSpeed:30 fadeLength:12.f isLeft:YES];
        self.zhiAllLB.text = zhiJYLStr?zhiJYLStr:@"0.00";
        
        [self valueWithLabel:self.jianAllLB textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font: LYFont(28) labelSpacing:30 pauseInterval:1.7 scrollSpeed:30 fadeLength:12.f isLeft:YES];
        self.jianAllLB.text = jianJYLStr?jianJYLStr:@"0.00";
    }];
    
}


//接口 3.查询 当天直推间推
- (void)request_Today_DataForAllRecordInfo:(NSString *)startDay endDay:(NSString *)endDay{
//    NSString *urlStr = @"/user/app/month/dimension/get/day/month/sum/amount/by/userid";
        NSString *urlStr = @"/statistics/app/query/team/amount";
        /*  */
        NSMutableDictionary *barginDic = [NSMutableDictionary dictionary];
        barginDic[@"startDay"] = startDay;
        barginDic[@"endDay"] = endDay;
    
    [MCLATESTCONTROLLER.sessionManager mc_POST:urlStr parameters:barginDic ok:^(MCNetResponse * _Nonnull okResponse) {
        MCLog(@"查询 当天直推间推!!!!!!");
        NSDictionary *response = okResponse.result;
        NSString *zhiStr1 = [NSString stringWithFormat:@"%.4f",[response[@"directRepayment"] doubleValue]/10000];
         NSString *jianStr1 = [NSString stringWithFormat:@"%.4f",[response[@"indirectRepayment"] doubleValue]/10000];
         NSString *zhiStr2 = [NSString stringWithFormat:@"%.4f",[response[@"directRecharge"] doubleValue]/10000];
         NSString *jianStr2 = [NSString stringWithFormat:@"%.4f",[response[@"indirectRecharge"] doubleValue]/10000];

                     self.zhiLb1.hidden = YES;
                     self.jianLb1.hidden = YES;
                     self.zhiLb2.hidden = YES;
                     self.jianLb2.hidden = YES;
        [self valueWithLabel:self.zhiLB1 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font: LYFont(20) labelSpacing:30 pauseInterval:1.7 scrollSpeed:30 fadeLength:12.f isLeft:YES];
         self.zhiLB1.text = zhiStr1?zhiStr1:@"0.00";
         
         [self valueWithLabel:self.jianLB1 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font: LYFont(20) labelSpacing:30 pauseInterval:1.7 scrollSpeed:30 fadeLength:12.f isLeft:YES];
         self.jianLB1.text = jianStr1?jianStr1:@"0.00";
         
         [self valueWithLabel:self.zhiLB2 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font: LYFont(20) labelSpacing:30 pauseInterval:1.7 scrollSpeed:30 fadeLength:12.f isLeft:YES];
         self.zhiLB2.text = zhiStr2?zhiStr2:@"0.00";
         
         [self valueWithLabel:self.jianLB2 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font: LYFont(20) labelSpacing:30 pauseInterval:1.7 scrollSpeed:30 fadeLength:12.f isLeft:YES];
         self.jianLB2.text = jianStr2?jianStr2:@"0.00";
    }];
        
}

- (void)valueWithLabel:(LY_ScrollTextLabel *)label textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)alignment font:(UIFont *)font labelSpacing:(CGFloat)labelSpacing pauseInterval:(CGFloat)pauseInterval scrollSpeed:(CGFloat)scrollSpeed fadeLength:(CGFloat)fadeLength isLeft:(BOOL)left {
    
    label.textColor = textColor;
    label.textAlignment = alignment;
    label.font = font;
    label.labelSpacing = labelSpacing; // distance between start and end labels
    label.pauseInterval = pauseInterval; // seconds of pause before scrolling starts again
    label.scrollSpeed = scrollSpeed; // pixels per second
    label.fadeLength = fadeLength;
    label.scrollDirection = left ? LYAutoScrollDirectionLeft : LYAutoScrollDirectionRight;
    [label observeApplicationNotifications];
}

// 通过当前年月 获取当月天数
- (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month{
  if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
    return 31 ;
  
  if((month == 4) || (month == 6) || (month == 9) || (month == 11))
    return 30;
  
  if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3))
  {
    return 28;
  }
  
  if(year % 400 == 0)
    return 29;
  
  if(year % 100 == 0)
    return 28;
  
  return 29;
}


//------ 获取当前的年月 ------//
- (NSArray *)years {
    NSMutableArray *yearArr = [[NSMutableArray alloc]init];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger mon = [dateComponent month];
    NSInteger da = [dateComponent day];
    
    NSString *year = [NSString stringWithFormat:@"%ld",[dateComponent year]];
    
    NSString *month;
    if (mon < 10) {
        month = [NSString stringWithFormat:@"0%ld",mon];
    }else{
        month = [NSString stringWithFormat:@"%ld",(long)mon];
    }
    
    NSString *day;
    if (da < 10) {
        day = [NSString stringWithFormat:@"0%ld",da];
    }else{
        day = [NSString stringWithFormat:@"%ld",(long)da];
    }
    
    [yearArr addObject:year];
    [yearArr addObject:month];
    [yearArr addObject:day];
    return yearArr;
}


@end
