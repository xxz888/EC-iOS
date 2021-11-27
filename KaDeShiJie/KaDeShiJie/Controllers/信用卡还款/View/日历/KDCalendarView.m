//
//  KDCalendarView.m
//  MCExample
//
//  Created by wza on 2020/9/23.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "KDCalendarView.h"
#import <OEMSDK/OEMSDK.h>
#import "KDCalendarCell.h"
#import "MSSCalendarManager.h"
#import "MSSCalendarHeaderModel.h"

@interface KDCalendarView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *coBG;
@property (weak, nonatomic) IBOutlet UILabel *montLab;

@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,assign)NSInteger startDate;
@property (nonatomic,assign)NSInteger endDate;

@property(nonatomic, assign) NSInteger month;
@property(nonatomic, assign) NSInteger currentMonth;

@property(nonatomic, assign) NSInteger year;

@property (nonatomic,strong)NSMutableArray * selectArray;

@end

@implementation KDCalendarView
- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:20];
    }
    return _dataArray;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        CGFloat itemW = SCREEN_WIDTH / 7;
        CGFloat itemH = 53;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.coBG.height) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColorWhite;
        [_collectionView registerClass:KDCalendarCell.class forCellWithReuseIdentifier:@"KDCalendarCell"];
    }
    return _collectionView;
}
- (void)requestDataSource:(NSInteger)targetMonth
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MSSCalendarManager *manager = [[MSSCalendarManager alloc]initWithShowChineseHoliday:NO showChineseCalendar:NO startDate:self.startDate];
        //获取三个月的
        NSArray <MSSCalendarHeaderModel *> *tempDataArray = [manager getCalendarDataSoruceWithTargetMonth:targetMonth];
        
        
        MSSCalendarHeaderModel *hM0 = tempDataArray[0];
        MSSCalendarHeaderModel *hM1 = tempDataArray[1];
        MSSCalendarHeaderModel *hM2 = tempDataArray[2];
        
        NSInteger firIndex = 0;   //本月第一天在哪一列
        for (int i = 0; i < hM1.calendarItemArray.count; i++) {
            MSSCalendarModel *dM = hM1.calendarItemArray[i];
            if (dM.week > 0) {
                firIndex = i;
                break;
            }
        }
        
        MSSCalendarModel *lastModel = hM1.calendarItemArray.lastObject;
        NSInteger lastCow = lastModel.week % 7;   //本月最后一天在哪一列
        
        
        NSArray *arr0 = [hM0.calendarItemArray subarrayWithRange:NSMakeRange(hM0.calendarItemArray.count - firIndex, firIndex)];
        
        NSArray *arr1 = [hM1.calendarItemArray subarrayWithRange:NSMakeRange(firIndex, hM1.calendarItemArray.count-firIndex)];
        
        NSMutableArray *mulArr2 = [NSMutableArray arrayWithCapacity:10];
        for (MSSCalendarModel *model in hM2.calendarItemArray) {
            if (model.week > 0) {
                [mulArr2 addObject:model];
            }
        }
        
        NSArray *arr2 = [mulArr2 subarrayWithRange:NSMakeRange(0, 6-lastCow)];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
     
            [self.dataArray removeAllObjects];

            [self.dataArray addObjectsFromArray:arr0];
            [self.dataArray addObjectsFromArray:arr1];
            [self.dataArray addObjectsFromArray:arr2];
            
            
            for (MSSCalendarModel *model in self.dataArray) {
                //设置账单日
                if (self.billMonth == model.month && model.day == self.billDay) {
                    model.labType = MSSCircleLabelTypeZhangdan;
                    model.selectItem = YES;
                }
                   
                //设置还款日
                if (model.month == self.repaymentMonth && model.day == self.repaymentDay) {
                    model.labType = MSSCircleLabelTypeHuankuan;
                    model.selectItem = YES;
                }
            }
            NSMutableArray * oldDataArray = [[NSMutableArray alloc]initWithArray:self.dataArray];
            for (NSInteger i = 0 ; i < oldDataArray.count ; i++) {
                    MSSCalendarModel * oldModel = oldDataArray[i];
                    for (MSSCalendarModel * selectModel in self.selectArray) {
                        if (oldModel.year == selectModel.year &&
                            oldModel.month == selectModel.month &&
                            oldModel.day == selectModel.day
                            ) {
                            selectModel.labType = MSSCircleLabelTypeSelected;
                            [self.dataArray replaceObjectAtIndex:i withObject:selectModel];
                        }
                    }
                }

       
            
            [self.collectionView reloadData];
        });
    });
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.qmui_maskedCorners = QMUILayerMinXMinYCorner | QMUILayerMaxXMinYCorner;
    self.layer.cornerRadius = 12;
    
    
    
    
    [self.coBG addSubview:self.collectionView];
    
    [self getCurrent];
    
    kWeakSelf(self);
    //1.查询当天是否可以开始执行
    [[MCSessionManager shareManager] mc_POST:@"/creditcardmanager/app/plan/today/run" parameters:@{} ok:^(MCNetResponse * _Nonnull resp) {
    
        weakself.selectCurrent = [resp.messege integerValue];
        [weakself requestDataSource:weakself.month];
    }];
  
    
    
}

- (IBAction)cancelTouched:(UIButton *)sender {
    [self.modalVC hideWithAnimated:YES completion:nil];
}
- (IBAction)okTouched:(UIButton *)sender {
    
//    NSMutableArray *selArr = [NSMutableArray new];
//    for (MSSCalendarModel *model in self.dataArray) {
//        if (model.labType == MSSCircleLabelTypeSelected) {
//            [selArr addObject:model];
//        }
//    }
    

    if (self.confirmBlock) {
        self.confirmBlock(self.selectArray);
    }
}


#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MSSCalendarModel *calendarItem = self.dataArray[indexPath.row];
    KDCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KDCalendarCell" forIndexPath:indexPath];
    cell.repaymentDay = self.repaymentDay;
    cell.currentMonth = self.currentMonth;
    cell.repaymentMonth = self.repaymentMonth;
    cell.selectCurrent = self.selectCurrent;
    cell.model = calendarItem;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MSSCalendarModel *calendarItem = self.dataArray[indexPath.row];
//    KDCalendarCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.
    //得到还款日
//    NSString * repayString = [NSString stringWithFormat:@"%@-%ld-%ld",
//                              [MCDateStore getUseYear:self.currentMonth],
//                              self.repaymentMonth,
//                              self.repaymentDay];
    //点击的日期
    NSString * clickString = [NSString stringWithFormat:@"%ld-%ld-%ld",calendarItem.year,calendarItem.month,calendarItem.day];

    //结果说明：resp_message为0代表当天不执行计划，为1代表当天开始执行计划
    if (calendarItem.day == [MCDateStore getCurrentDay] && self.selectCurrent == 0) {
        return;
    }
    
    if (![MCDateStore date:clickString isBetweenDate:[NSDate date] andDate:@"2030-01-01"]) {
        return;
    }

    
    if (calendarItem.labType == MSSCircleLabelTypeSelected) {
        if (calendarItem.month == self.currentMonth && calendarItem.day == self.billDay) { //账单日
            calendarItem.labType = MSSCircleLabelTypeZhangdan;
        } else if (calendarItem.month == self.currentMonth && calendarItem.day == self.repaymentDay) {   //还款日
            calendarItem.labType = MSSCircleLabelTypeHuankuan;
        } else {
            calendarItem.labType = MSSCircleLabelTypeNormal;
        }
        calendarItem.selectItem = NO;
        NSMutableArray * selectArrayCopy = [[NSMutableArray alloc]initWithArray:self.selectArray];
        for (MSSCalendarModel * calendarItemModel in selectArrayCopy) {
            if (calendarItemModel.year == calendarItem.year &&
                calendarItemModel.month == calendarItem.month &&
                calendarItemModel.day == calendarItem.day
                ) {
                [self.selectArray removeObject:calendarItemModel];
            }
        }
    } else {
        calendarItem.selectItem = YES;
        calendarItem.labType = MSSCircleLabelTypeSelected;
        [self.selectArray addObject:calendarItem];
    }
    NSArray *sortedArray = [self.selectArray sortedArrayUsingComparator:^(MSSCalendarModel *calendarItem1,MSSCalendarModel *calendarItem2)
    {if (calendarItem1.dateInterval < calendarItem2.dateInterval ){return NSOrderedAscending;}else{return NSOrderedDescending;}}];
    [self.selectArray removeAllObjects];
    [self.selectArray addObjectsFromArray:sortedArray];
    
    [self.collectionView reloadData];
}

- (void)getCurrent {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitWeekday |NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    
    self.month = comps.month;
    self.year = comps.year;
    self.currentMonth = comps.month;
    self.montLab.text = [NSString stringWithFormat:@"%zi年%02d月", self.year, (int)self.month];
    
}


- (IBAction)lastTouched:(id)sender {
    if (self.month > 1) {
        self.month -= 1;
        self.montLab.text = [NSString stringWithFormat:@"%zi年%02d月", self.year, (int)self.month];
        [self requestDataSource:self.month];
    }else{
        self.month = 12;
        self.year -= 1;
        self.montLab.text = [NSString stringWithFormat:@"%zi年%02d月", self.year, (int)self.month];
        [self requestDataSource:self.month];
    }
    
}
- (IBAction)nextTouched:(id)sender {
    if (self.month < 12) {
        self.month += 1;
        self.montLab.text = [NSString stringWithFormat:@"%zi年%02d月", self.year, (int)self.month];
        [self requestDataSource:self.month];
    }else{
        self.month = 1;
        self.year += 1;
        self.montLab.text = [NSString stringWithFormat:@"%zi年%02d月",self.year, (int)self.month];
        [self requestDataSource:self.month];
    }
}

@end
