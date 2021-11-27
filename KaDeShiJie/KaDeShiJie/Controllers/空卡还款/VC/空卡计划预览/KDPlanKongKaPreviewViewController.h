//
//  KDPlanKongKaPreviewViewController.h
//  KaDeShiJie
//
//  Created by apple on 2020/12/1.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "MCBaseViewController.h"
#import "KDRepaymentModel.h"
#import "KDRepaymentDetailModel.h"
#import "KDPlanKongKaPreviewCell.h"
#import "KDCreditAlertView.h"
#import "KDPlanPreviewView.h"
#import "KDTotalAmountModel.h"
#import "KDConsumptionDetailView.h"
#import "KDDirectRefundModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KDPlanKongKaPreviewViewController : MCBaseViewController
@property (nonatomic, strong) NSMutableDictionary * startDic;// 上个界面传过来的dic
@property (nonatomic, strong) KDDirectRefundModel *directModel;
@property (nonatomic, assign) NSInteger whereCome;// 1 下单 2 历史记录 3 信用卡还款进来
@property (nonatomic, assign) NSInteger orderType;
@property (nonatomic, assign) BOOL isCanDelete;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet KDFillButton *bottomBtn;
@property (weak, nonatomic) IBOutlet KDFillButton *bottomBtn2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomCons;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;


@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;

//cell头 状态 文字的宽度和lbl
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLabelWidth;
@property (weak, nonatomic) IBOutlet UILabel *titleStatusLblTag;

@property (nonatomic, strong) NSString * stateString;// 状态文字
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (nonatomic, strong) NSString * version;


@end

NS_ASSUME_NONNULL_END
