//
//  KDPlanPreviewViewController.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/23.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "MCBaseViewController.h"
#import "KDRepaymentModel.h"
#import "KDRepaymentDetailModel.h"
#import "KDPlanPreviewViewCell.h"
#import "KDCreditAlertView.h"
#import "KDPlanPreviewView.h"
#import "KDTotalAmountModel.h"
#import "KDConsumptionDetailView.h"
NS_ASSUME_NONNULL_BEGIN

@interface KDPlanPreviewViewController : MCBaseViewController
@property (nonatomic, strong) KDRepaymentModel *repaymentModel;
@property (nonatomic, assign) NSInteger whereCome;// 1 下单 2 历史记录 3 信用卡还款进来
@property (nonatomic, assign) NSInteger orderType;
@property (nonatomic, assign) BOOL isCanDelete;
@property (nonatomic, strong) KDRepaymentDetailModel *detailModel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet KDFillButton *bottomBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;
@property (weak, nonatomic) IBOutlet UILabel *lab6;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLabelWidth;
@property (weak, nonatomic) IBOutlet UILabel *titleStatusLblTag;


//只做请求参数用，不做其他用
@property (nonatomic, strong) NSString * taskJSON;
@property (nonatomic, strong) NSString * version;
@property (nonatomic, strong) NSString * reservedAmount;
@property (nonatomic, strong) NSString * amount;
@property (nonatomic, strong) NSString * city;  //浙江省-杭州市-330000-330100
@property (nonatomic, strong) NSString * extra;//
@property (nonatomic, strong) NSString * balancePlanId;//

@end

NS_ASSUME_NONNULL_END
