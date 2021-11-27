//
//  KDSlotCardOrderInfoViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/25.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDSlotCardOrderInfoViewController.h"
#import <MBProgressHUD.h>
@interface KDSlotCardOrderInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;

@property (nonatomic, assign) BOOL isBackHomeVC;
//需要将dispatch_source_t timer设置为成员变量，不然会立即释放
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation KDSlotCardOrderInfoViewController
- (instancetype)initWithClassification:(NSDictionary *)slotHistoryDic{
    self = [super init];
    if (self) {
        self.slotHistoryModel = [[KDSlotCardHistoryModel alloc]init];
        self.slotHistoryModel.channelname = slotHistoryDic[@"channelname"];
        self.slotHistoryModel.rate = [slotHistoryDic[@"rate"] floatValue];
        self.slotHistoryModel.realAmount = [slotHistoryDic[@"realAmount"] floatValue];
        self.slotHistoryModel.extraFee = [slotHistoryDic[@"extraFee"] floatValue];
        self.slotHistoryModel.costfee = [slotHistoryDic[@"costfee"] floatValue];
        self.slotHistoryModel.desc = slotHistoryDic[@"desc"] ;
        self.slotHistoryModel.status = [slotHistoryDic[@"status"] integerValue];
        self.slotHistoryModel.createTime = slotHistoryDic[@"createTime"] ;
        self.slotHistoryModel.ordercode = slotHistoryDic[@"ordercode"] ;
        self.slotHistoryModel.amount = [slotHistoryDic[@"amount"] floatValue];

        self.isBackHomeVC = YES;
        
        [self customBackButton];
        
        [self setupView];

    }
    return self;
}
// 自定义返回按钮
- (void)customBackButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage mc_imageNamed:@"nav_left_white"] forState:0];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 18, 18);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
}
// 返回按钮按下
- (void)backBtnClicked:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"账单详情" backgroundImage:[UIImage qmui_imageWithColor:UIColor.mainColor]];
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#f5f5f5"];
    
    [self setupView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isBackHomeVC) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.isBackHomeVC = NO;
    }
}
- (void)setupView
{
    self.nameLabel.text = self.slotHistoryModel.channelname;
    self.rateLabel.text = [NSString stringWithFormat:@"%.2f%%", self.slotHistoryModel.rate * 100];
    self.rateLabel.layer.cornerRadius = 3;
    self.rateLabel.layer.masksToBounds = YES;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", self.slotHistoryModel.amount];
    self.moneyLabel.textColor = [UIColor mainColor];
    
    if (self.slotHistoryModel.status == 1) {
        self.statusLabel.text = @"订单状态：已成功";
    } else if (self.slotHistoryModel.status == 2) {
        self.statusLabel.text = @"订单状态：已失败";
    } else if (self.slotHistoryModel.status == 3) {
        self.statusLabel.text = @"订单状态：待结算";
        
       
    }
    
    self.lab1.text = [NSString stringWithFormat:@"%.2f元", self.slotHistoryModel.realAmount];
    self.lab2.text = [NSString stringWithFormat:@"%.2f元", self.slotHistoryModel.amount - self.slotHistoryModel.realAmount];
    self.lab3.text = [NSString stringWithFormat:@"%@", self.slotHistoryModel.desc];
    self.lab4.text = self.slotHistoryModel.createTime;
    self.lab5.text = self.slotHistoryModel.ordercode;
}

@end
