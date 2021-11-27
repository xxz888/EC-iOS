//
//  CalendarShowView.m
//  BQLCalendar
//
//  Created by sawu on 2018/8/29.
//  Copyright © 2018年 毕青林. All rights reserved.
//

#import "CalendarShowView.h"
#import "BQLCalendar.h"

@interface CalendarShowView()<UIScrollViewDelegate>
{
    NSArray* yueAR;
}

@property(nonatomic)UIScrollView* scrollView;

@property(nonatomic)NSDate* currentDate;

@property(nonatomic)UILabel* currentYear;

@property(nonatomic)UILabel* currentMonth;

@property(nonatomic)BQLCalendar* leftCalender;
@property(nonatomic)BQLCalendar* centerCalender;
@property(nonatomic)BQLCalendar* rightCalender;

@property(nonatomic)NSMutableArray* leftCalenderAR;
@property(nonatomic)NSMutableArray* centerCalenderAR;
@property(nonatomic)NSMutableArray* rightCalenderAR;

@end

@implementation CalendarShowView

-(UIScrollView*)scrollView{
    if (!_scrollView) {
        _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.pagingEnabled=YES;
        _scrollView.contentSize=CGSizeMake((SCREEN_WIDTH-20)*3, 330);
        _scrollView.delegate=self;
        _scrollView.contentOffset=CGPointMake(SCREEN_WIDTH-20, 0);
        CGFloat width=SCREEN_WIDTH-20;
//        CGFloat height=300;
        [_scrollView addSubview:self.leftCalender];
        _leftCalender.sd_layout.leftSpaceToView(_scrollView, 0).widthIs(width).heightIs(370).topSpaceToView(_scrollView, 10);
        [_scrollView addSubview:self.centerCalender];
        _centerCalender.sd_layout.leftSpaceToView(_scrollView, width).widthIs(width).heightIs(370).topSpaceToView(_scrollView, 10);
        [_scrollView addSubview:self.rightCalender];
        _rightCalender.sd_layout.leftSpaceToView(_scrollView, width*2).widthIs(width).heightIs(370).topSpaceToView(_scrollView, 10);
    }
    return _scrollView;
}

-(BQLCalendar*)leftCalender{
    if (!_leftCalender) {
        _leftCalender=[[BQLCalendar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 370)];
        NSInteger moth=[[self monthTranfor] integerValue];
        NSInteger year=[[self yearTranfor]integerValue];
        if (moth-1==0) {
            year=year-1;
            moth=12;
        }else{
            moth=moth-1;
        }
        [_leftCalender initSign:nil Touch:^(NSString *date) {
            
        } withWantMonth:[NSString stringWithFormat:@"%ld-%ld-01",year,moth]];
    }
    return _leftCalender;
}
-(BQLCalendar*)centerCalender{
    if (!_centerCalender) {
        _centerCalender=[[BQLCalendar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 370)];
        [_centerCalender initSign:nil Touch:^(NSString *date) {
            
        } withWantMonth:[self dateTranfor:_currentDate]];
    }
    return _centerCalender;
}
-(BQLCalendar*)rightCalender{
    if (!_rightCalender) {
        _rightCalender=[[BQLCalendar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 370)];
        NSInteger moth=[[self monthTranfor] integerValue];
        NSInteger year=[[self yearTranfor]integerValue];
        if (moth+1==13) {
            year=year+1;
            moth=1;
        }else{
            moth=moth+1;
        }
        [_rightCalender initSign:nil Touch:^(NSString *date) {
            
        } withWantMonth:[NSString stringWithFormat:@"%ld-%ld-01",year,moth]];
    }
    return _rightCalender;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _leftCalenderAR=[[NSMutableArray alloc]init];
        _centerCalenderAR=[[NSMutableArray alloc]init];
        _rightCalenderAR=[[NSMutableArray alloc]init];
        _currentDate=[NSDate date];
        [self getSignDataSerVice:_currentDate withIdx:1];
        yueAR=@[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
        self.backgroundColor=UIColor.whiteColor;
        UIView* headerVieww=UIView.new;
        headerVieww.backgroundColor=MAINCOLOR;
        [self addSubview:headerVieww];
        headerVieww.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).topSpaceToView(self, 0).heightIs(50 + 30);
        
        //weakDay
        NSArray *weekdayArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
        for (int i = 0; i < 7; i++) {
            UILabel *week = [[UILabel alloc] init];
            week.text     = weekdayArray[i];
            week.font     = [UIFont systemFontOfSize:14];
            week.frame    = CGRectMake((SCREEN_WIDTH-20)/7 * i, 50, (SCREEN_WIDTH-20)/7, 20);
            week.textAlignment   = NSTextAlignmentCenter;
            week.backgroundColor = [UIColor clearColor];
            week.textColor       = UIColor.whiteColor;
            [headerVieww addSubview:week];
        }
        
        _currentYear=UILabel.new;
        _currentYear.textColor=UIColor.whiteColor;
        _currentYear.font=LYFont(16);
        _currentYear.text=[self yearTranfor];
        [self addSubview:_currentYear];
        _currentYear.sd_layout.leftSpaceToView(self, 10).widthIs(120).heightIs(40).topSpaceToView(self, 0);
        
        _currentMonth=UILabel.new;
        _currentMonth.textColor=UIColor.whiteColor;
        _currentMonth.font=LYFont(20);
        _currentMonth.text=yueAR[[[self monthTranfor]integerValue]-1];
        _currentMonth.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_currentMonth];
        _currentMonth.sd_layout.centerXEqualToView(self).widthIs(120).heightIs(50).topSpaceToView(self, 0);
        
        //签到规则
        UIButton* signOrl=UIButton.new;
        [signOrl setTitle:@"签到规则" forState:UIControlStateNormal];
        [signOrl setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        signOrl.titleLabel.font=LYFont(15);
        signOrl.titleLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:signOrl];
        signOrl.sd_layout.rightSpaceToView(self, 0).topSpaceToView(self, 10).widthIs(100).heightIs(20);
        [signOrl addTarget:self action:@selector(signOrlTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.scrollView];
        _scrollView.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).topSpaceToView(headerVieww, -50).bottomSpaceToView(self, 0);
    }
    return self;
}
- (void)signOrlTouched:(UIButton *)sender {
    self.state=@"1";
    NSString *msg = @"  1、每日签到，获得积分实时累加\n  2、用户等级越高，积分获取越多\n     3、用户累计签到，可领取对应多倍积分奖励\n     4、签到获得的积分可以用于积分商城的礼品兑换";
    QMUIAlertController *alert = [[QMUIAlertController alloc] initWithTitle:@"签到规则" message:msg preferredStyle:QMUIAlertControllerStyleAlert];
    [alert addAction:[QMUIAlertAction actionWithTitle:@"知道了" style:QMUIAlertActionStyleCancel handler:nil]];
    [alert showWithAnimated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.x==SCREEN_WIDTH-20){
        return;
    }
    NSInteger moth=[[self monthTranfor] integerValue];
    NSInteger year=[[self yearTranfor]integerValue];
    if (scrollView.contentOffset.x==0) {
        //左侧
        if (moth-1==0) {
            year=year-1;
            moth=12;
        }else{
            moth=moth-1;
        }
        _currentDate=[self stringTodateTranfor:[NSString stringWithFormat:@"%ld-%ld-01",year,moth]];
    }
    if (scrollView.contentOffset.x==(SCREEN_WIDTH-20)*2) {
        //右侧
        if (moth+1==13) {
            year=year+1;
            moth=1;
        }else{
            moth=moth+1;
        }
        _currentDate=[self stringTodateTranfor:[NSString stringWithFormat:@"%ld-%ld-01",year,moth]];
    }
    [self reloadShowView:scrollView.contentOffset.x==(SCREEN_WIDTH-20)*2?1:0];
    _currentYear.text=[self yearTranfor];
    _currentMonth.text=yueAR[[[self monthTranfor]integerValue]-1];
    _scrollView.contentOffset=CGPointMake(SCREEN_WIDTH-20, 0);
}

-(void)getSignDataSerVice:(NSDate*)date withIdx:(int)idx{
    if (idx==2) {
        [MCLoading show];
    }
    
    NSDictionary *param = @{@"userId":SharedUserInfo.userid,
                            @"year":[self yearTranfors:date],
                            @"month":[self monthTranfors:date]};
    
    [MCSessionManager.shareManager mc_POST:@"/user/app/signin/getsignby/yearandmonth" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        switch (idx) {
        case 0:
            //left
            {
                [self.leftCalender.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj removeFromSuperview];
                }];
                [self.leftCalenderAR removeAllObjects];
                for (NSString* str in resp.result) {
                    NSString* resstr=[str substringFromIndex:str.length-2];
                    [self.leftCalenderAR addObject:[NSString stringWithFormat:@"%ld",[resstr integerValue]]];
                }
                [self.leftCalender initSign:[self.leftCalenderAR copy] Touch:^(NSString *date) {
                    
                } withWantMonth:[self dateTranfor:date]];
            }
            break;
        case 1:
            //center
            {
                [self.centerCalender.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj removeFromSuperview];
                }];

                [self.centerCalenderAR removeAllObjects];
                for (NSString* str in resp.result) {
                    NSString* resstr=[str substringFromIndex:str.length-2];
                    [self.centerCalenderAR addObject:[NSString stringWithFormat:@"%ld",[resstr integerValue]]];
                }
                [self.centerCalender initSign:[self.centerCalenderAR copy] Touch:^(NSString *date) {
                    
                } withWantMonth:[self dateTranfor:date]];
            }
            break;
        case 2:
            //right
            {
                [self.rightCalender.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj removeFromSuperview];
                }];
                [self.rightCalenderAR removeAllObjects];
                for (NSString* str in resp.result) {
                    NSString* resstr=[str substringFromIndex:str.length-2];
                    [self.rightCalenderAR addObject:[NSString stringWithFormat:@"%ld",[resstr integerValue]]];
                }
                [self.rightCalender initSign:[self.rightCalenderAR copy] Touch:^(NSString *date) {
                    
                } withWantMonth:[self dateTranfor:date]];
            }
            break;
        default:
            break;
        }
    }];
    
}

#pragma mark **************************************************< private >****************************************
//更新试图部分
-(void)reloadShowView:(NSInteger)idx{
    [_leftCalender.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_centerCalender.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_rightCalender.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    //更新左侧
    NSInteger moth=[[self monthTranfor] integerValue];
    NSInteger year=[[self yearTranfor]integerValue];
    if (moth-1==0) {
        year=year-1;
        moth=12;
    }else{
        moth=moth-1;
    }
    [_leftCalender initSign:nil Touch:^(NSString *date) {
        
    } withWantMonth:[NSString stringWithFormat:@"%ld-%ld-01",year,moth]];
    [self getSignDataSerVice:[self stringTodateTranfor:[NSString stringWithFormat:@"%ld-%ld-01",year,moth]] withIdx:0];
    
    //更新中间
    [_centerCalender initSign:idx?_rightCalenderAR:_leftCalenderAR Touch:^(NSString *date) {
        
    } withWantMonth:[self dateTranfor:_currentDate]];
    [self getSignDataSerVice:_currentDate withIdx:1];
    
    //更新右侧
    moth=[[self monthTranfor] integerValue];
    year=[[self yearTranfor]integerValue];
    if (moth+1==13) {
        year=year+1;
        moth=1;
    }else{
        moth=moth+1;
    }
    [_rightCalender initSign:nil Touch:^(NSString *date) {
        
    } withWantMonth:[NSString stringWithFormat:@"%ld-%ld-01",year,moth]];
    [self getSignDataSerVice:[self stringTodateTranfor:[NSString stringWithFormat:@"%ld-%ld-01",year,moth]] withIdx:2];
}
//年份转换
-(NSString*)yearTranfor{
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString* yera=[formatter stringFromDate:_currentDate];
    return yera;
}
-(NSString*)yearTranfors:(NSDate*)date{
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString* yera=[formatter stringFromDate:date];
    return yera;
}
//月份转换
-(NSString*)monthTranfor{
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM"];
    NSString* month=[formatter stringFromDate:_currentDate];
    return month;
}
-(NSString*)monthTranfors:(NSDate*)date{
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM"];
    NSString* month=[formatter stringFromDate:date];
    return month;
}
//日期转字符串
-(NSString*)dateTranfor:(NSDate*)date{
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* str=[formatter stringFromDate:date];
    return str;
}
//字符串转日期
-(NSDate*)stringTodateTranfor:(NSString*)string{
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date=[formatter dateFromString:string];
    return date;
}

- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_viewTouch) {
        _viewTouch();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
