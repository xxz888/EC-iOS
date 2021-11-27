//
//  MCFenrunDetailController.m
//  MCOEM
//
//  Created by yujia tian on 2020/5/10.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCFenrunDetailController.h"

@interface MCFenrunDetailController ()

@property (nonatomic, strong) MCFenrunModel *model;

@end


#define WS_ScaleRateX    [[UIScreen mainScreen] bounds].size.height/667.f
#define WS_ScaleRate      (IS_NOTCHED_SCREEN ? 1.2 : (SCREEN_HEIGHT/667.f))


@implementation MCFenrunDetailController

- (instancetype)initWithFenrunModel:(MCFenrunModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:@"分润详情" tintColor:nil];
    
    [self setupMainView];
}

//------ 主界面 ------//
- (void)setupMainView {
    
    CGFloat scale = 0;
    if (IS_NOTCHED_SCREEN) {
        scale = 0.18;
    } else if(IS_40INCH_SCREEN){
        scale = 0.25;
    } else if (IS_47INCH_SCREEN) {
        scale = 0.24;
    } else {
        scale = 0.23;
    }
    
    //新增图片背景
    UIImageView* backIM=[UIImageView new];
    UIImage *bgImg = [UIImage mc_imageNamed:@"wj_shouyixiangqing"];
    bgImg = [bgImg stretchableImageWithLeftCapWidth:bgImg.size.width * 0.5 topCapHeight:bgImg.size.height * 0.5];
    backIM.image=bgImg;
    backIM.layer.cornerRadius = 8;
    [self.view addSubview:backIM];
    backIM.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).topSpaceToView(self.view, NavigationContentTop+20).bottomSpaceToView(self.view, 65);
    //------ 1. headerView ------//
    // 背景
    CGFloat imageH = SCREEN_HEIGHT - NavigationContentTop - 20 - 65;
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    headerView.sd_layout.leftSpaceToView(self.view, 18).rightSpaceToView(self.view, 18).topSpaceToView(self.view, NavigationContentTop+23).heightIs(imageH * scale);
    
    //竖线
    CALayer* layerlyf=[CALayer layer];
    layerlyf.frame=CGRectMake(5, 20, 3, 20*WS_ScaleRate);
    layerlyf.backgroundColor=[UIColor colorWithRed:32/255.f green:134/255.f blue:221/255.f alpha:1.f].CGColor;
    [headerView.layer addSublayer:layerlyf];
    // 收益金额标题
    UILabel *fenRunLB = [UILabel new];
    fenRunLB.text=@"分润明细";
    [headerView addSubview:fenRunLB];
    fenRunLB.sd_layout.leftSpaceToView(headerView, 10).topSpaceToView(headerView, 20*WS_ScaleRate).heightIs(20*WS_ScaleRate).widthIs(120);
    
    // 标题
    UILabel *headerTitleLabel = [UILabel new];
    headerTitleLabel.text=@"订单金额";
    headerTitleLabel.textAlignment=NSTextAlignmentCenter;
    headerTitleLabel.font=[UIFont systemFontOfSize:18];
    [headerView addSubview:headerTitleLabel];
    headerTitleLabel.sd_layout.centerXEqualToView(headerView).topSpaceToView(headerView, 20).widthIs(180).heightIs(30);
    
    // 金额 [self.earningInfoDic valueForKey:@"acqAmount"]收益金额
    NSString *amountStr = [NSString stringWithFormat:@"¥ %.2f", self.model.amount.floatValue];
    UILabel *amountLabel = [UILabel new];
    amountLabel.textAlignment=NSTextAlignmentCenter;
    amountLabel.font=[UIFont systemFontOfSize:20];
    NSMutableAttributedString* astr=[[NSMutableAttributedString alloc]initWithString:amountStr];
    [astr setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:240/255.f green:128/255.f blue:97/255.f alpha:1.f],NSFontAttributeName:[UIFont systemFontOfSize:30]} range:NSMakeRange(2, amountStr.length-2)];
    amountLabel.attributedText=astr;
    [headerView addSubview:amountLabel];
    amountLabel.sd_layout.centerXEqualToView(headerView).topSpaceToView(headerTitleLabel, 10*WS_ScaleRate).widthIs(180).heightIs(30*WS_ScaleRate);
    
    //------ 2. midView ------//
    UIView *midView = [UIView new];
    midView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:midView];
    midView.sd_layout.leftSpaceToView(self.view, 18).topSpaceToView(headerView, 10).rightSpaceToView(self.view, 18).heightIs(imageH * (1 - scale * 2) - 10);
    
    // 刷卡人
    NSString *oriUser = self.model.oriphone;
    UILabel *oriUserLabel = [UILabel new];
    oriUserLabel.font = UIFontMake(15*WS_ScaleRate);
    oriUserLabel.text=@"刷卡人费率";
    [midView addSubview:oriUserLabel];
    oriUserLabel.sd_layout.leftSpaceToView(midView, 8).topSpaceToView(midView, 15*WS_ScaleRateX).widthIs((SCREEN_WIDTH-52)/2).heightIs(25*WS_ScaleRate);
    
    // 费率
    NSString *oriRate = [NSString stringWithFormat:@"%.2f%%", self.model.orirate.floatValue*100];
    UILabel *oriRateLabel = [UILabel new];
    oriRateLabel.textColor=[UIColor lightGrayColor];
    oriRateLabel.textAlignment=NSTextAlignmentRight;
    oriRateLabel.text=oriRate;
    oriRateLabel.font=[UIFont systemFontOfSize:14*WS_ScaleRate];
    [midView addSubview:oriRateLabel];
    oriRateLabel.sd_layout.rightSpaceToView(midView, 8).topSpaceToView(midView, 15*WS_ScaleRate).widthIs((SCREEN_WIDTH-52)/2).heightIs(25*WS_ScaleRate);
    // 受益人
    UILabel *acqUserLabel = [UILabel new];
    acqUserLabel.font=UIFontMake(15*WS_ScaleRate);
    acqUserLabel.text=@"收益人费率";
    //    [midView addSubview:acqUserLabel];
    acqUserLabel.sd_layout.leftSpaceToView(midView, 8).topSpaceToView(oriUserLabel, 5*WS_ScaleRate).widthIs((SCREEN_WIDTH-52)/2).heightIs(25*WS_ScaleRate);
    // 费率
    NSString *acqRate = [NSString stringWithFormat:@"%.2f%%", self.model.acqrate.floatValue*100];
    UILabel *acqRateLabel = [UILabel new];
    acqRateLabel.textColor=[UIColor lightGrayColor];
    acqRateLabel.textAlignment=NSTextAlignmentRight;
    acqRateLabel.text=acqRate;
    acqRateLabel.font=[UIFont systemFontOfSize:14*WS_ScaleRate];
    //    [midView addSubview:acqRateLabel];
    acqRateLabel.sd_layout.rightSpaceToView(midView, 8).topSpaceToView(oriRateLabel, 5*WS_ScaleRate).widthIs((SCREEN_WIDTH-52)/2).heightIs(25*WS_ScaleRate);
    
    //费率差
    UILabel *feilvLabel = [UILabel new];
    feilvLabel.text=@"费率差";
    feilvLabel.font=UIFontMake(15*WS_ScaleRate);
    //    [midView addSubview:feilvLabel];
    feilvLabel.sd_layout.leftSpaceToView(midView, 8).topSpaceToView(acqUserLabel, 5*WS_ScaleRate).widthIs((SCREEN_WIDTH-52)/2).heightIs(25*WS_ScaleRate);
    
    UILabel *feilvLB = [UILabel new];
    feilvLB.textColor=[UIColor lightGrayColor];
    feilvLB.textAlignment=NSTextAlignmentRight;
    feilvLB.text=[NSString stringWithFormat:@"%.2f%%",self.model.orirate.floatValue*100 - self.model.acqrate.floatValue*100];
    feilvLB.font=[UIFont systemFontOfSize:14*WS_ScaleRate];
    //    [midView addSubview:feilvLB];
    feilvLB.sd_layout.rightSpaceToView(midView, 8).topSpaceToView(acqRateLabel, 5*WS_ScaleRate).widthIs((SCREEN_WIDTH-52)/2).heightIs(25*WS_ScaleRate);
    
    //刷卡人号码
    UILabel* phoneLB=[UILabel new];
    phoneLB.text=@"刷卡人号码";
    phoneLB.font=UIFontMake(15*WS_ScaleRate);
    [midView addSubview:phoneLB];
    phoneLB.sd_layout.leftSpaceToView(midView, 8).topSpaceToView(oriUserLabel, 5*WS_ScaleRate).widthIs((SCREEN_WIDTH-52)/2).heightIs(25*WS_ScaleRate);
    UILabel* phoneorLB=[UILabel new];
    //    phoneorLB.text=[[rusults[0]stringByAppendingString:@"****"]stringByAppendingString:rusults[1]];
    phoneorLB.text = oriUser;
    phoneorLB.textColor=UIColor.lightGrayColor;
    phoneorLB.textAlignment=NSTextAlignmentRight;
    phoneorLB.font=[UIFont systemFontOfSize:14*WS_ScaleRate];
    [midView addSubview:phoneorLB];
    phoneorLB.sd_layout.rightSpaceToView(midView, 8).topSpaceToView(oriUserLabel, 5*WS_ScaleRate).widthIs((SCREEN_WIDTH-52)/2).heightIs(25*WS_ScaleRate);
    
    // 订单号
    UILabel *orderCodeLabel = [UILabel new];
    orderCodeLabel.text=@"订单号";
    orderCodeLabel.font=UIFontMake(15*WS_ScaleRate);
    [midView addSubview:orderCodeLabel];
    orderCodeLabel.sd_layout.leftSpaceToView(midView, 8).topSpaceToView(phoneLB, 5*WS_ScaleRate).widthIs(60).heightIs(25*WS_ScaleRate);
    NSString *orderCodeStr = [NSString stringWithFormat:@"%@", self.model.ordercode];
    UILabel *orderCodeDetailLabel = [UILabel new];
    orderCodeDetailLabel.textColor=[UIColor lightGrayColor];
    orderCodeDetailLabel.textAlignment=NSTextAlignmentRight;
    orderCodeDetailLabel.text=orderCodeStr;
    orderCodeDetailLabel.font=[UIFont systemFontOfSize:14*WS_ScaleRate];
    [midView addSubview:orderCodeDetailLabel];
    orderCodeDetailLabel.sd_layout.rightSpaceToView(midView, 8*WS_ScaleRate).topSpaceToView(phoneorLB, 5).leftSpaceToView(orderCodeLabel, 5).heightIs(25*WS_ScaleRate);
    
    //备注
    UILabel *beizhuLabel = [UILabel new];
    beizhuLabel.text=@"备注";
    beizhuLabel.font=UIFontMake(15*WS_ScaleRate);
    [midView addSubview:beizhuLabel];
    beizhuLabel.sd_layout.leftSpaceToView(midView, 8).topSpaceToView(orderCodeLabel, 5*WS_ScaleRate).widthIs(50).heightIs(25*WS_ScaleRate);
    
    UILabel *beizhuLB = [UILabel new];
    beizhuLB.textColor=[UIColor lightGrayColor];
    beizhuLB.textAlignment=NSTextAlignmentRight;
//    beizhuLB.text=@"差额费率分润";
    if (self.model.remark) {
        beizhuLB.text = self.model.remark;
    }
    beizhuLB.font=[UIFont systemFontOfSize:14*WS_ScaleRate];
    [midView addSubview:beizhuLB];
    beizhuLB.sd_layout.rightSpaceToView(midView, 8).topSpaceToView(orderCodeDetailLabel, 5*WS_ScaleRate).leftSpaceToView(beizhuLabel, 5).heightIs(25*WS_ScaleRate);
    
    //// 订单日期(14)
    UILabel *timeLabel = [UILabel new];
    timeLabel.font=UIFontMake(12*WS_ScaleRate);
    timeLabel.textColor=UIColor.lightGrayColor;
    NSString *timeStr = [NSString stringWithFormat:@"%@", self.model.createTime];
    timeLabel.text=[NSString stringWithFormat:@"订单日期：%@",timeStr];
    [midView addSubview:timeLabel];
    timeLabel.sd_layout.rightSpaceToView(midView, 8).bottomSpaceToView(midView, 5*WS_ScaleRate).widthIs((SCREEN_WIDTH-52)).heightIs(20*WS_ScaleRate);
    
    
    //------ 3. bottomView ------//
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomView];
    bottomView.sd_layout.leftSpaceToView(self.view, 18).rightSpaceToView(self.view, 18).topSpaceToView(midView, 10).heightIs(imageH * scale - 18);
    
    
    //竖线
    CALayer* layer2=[CALayer layer];
    layer2.frame=CGRectMake(5, 20, 3, 20*WS_ScaleRate);
    layer2.backgroundColor=[UIColor colorWithRed:32/255.f green:134/255.f blue:221/255.f alpha:1.f].CGColor;
    [bottomView.layer addSublayer:layer2];
    // 收益金额标题
    UILabel *shouyiTLB = [UILabel new];
    shouyiTLB.text=@"收益金额";
    [bottomView addSubview:shouyiTLB];
    shouyiTLB.sd_layout.leftSpaceToView(bottomView, 10).topSpaceToView(bottomView, 20*WS_ScaleRate).heightIs(20*WS_ScaleRate).widthIs(120);
    
    // 收益金额
    
    NSString *orderAmount = [NSString stringWithFormat:@"￥%.2f", self.model.acqAmount.floatValue];
    UILabel *orderAmountLabel = [UILabel new];
    orderAmountLabel.textAlignment=NSTextAlignmentCenter;
    orderAmountLabel.font=[UIFont systemFontOfSize:20*WS_ScaleRate];
    NSMutableAttributedString* oastr=[[NSMutableAttributedString alloc]initWithString:orderAmount];
    [oastr setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:240/255.f green:128/255.f blue:97/255.f alpha:1.f],NSFontAttributeName:[UIFont systemFontOfSize:22*WS_ScaleRate]} range:NSMakeRange(1, orderAmount.length-1)];
    orderAmountLabel.attributedText=oastr;
    [bottomView addSubview:orderAmountLabel];
    orderAmountLabel.sd_layout.topSpaceToView(bottomView, 20*WS_ScaleRate).rightSpaceToView(bottomView, 5).widthIs(100).heightIs(25*WS_ScaleRate);
    
    //底部标签
    UILabel *sdibuTLB = [UILabel new];
    sdibuTLB.text=@"(全民分享经济模式、推广越多、收益越高)";
    sdibuTLB.textAlignment=NSTextAlignmentCenter;
    sdibuTLB.font=[UIFont systemFontOfSize:12*WS_ScaleRate];
    sdibuTLB.textColor=[UIColor colorWithRed:106/255.f green:106/255.f blue:106/255.f alpha:1.f];
    [bottomView addSubview:sdibuTLB];
    sdibuTLB.sd_layout.leftSpaceToView(bottomView, 5).bottomSpaceToView(bottomView,10).heightIs(20*WS_ScaleRate).rightSpaceToView(bottomView, 5);
}


@end
