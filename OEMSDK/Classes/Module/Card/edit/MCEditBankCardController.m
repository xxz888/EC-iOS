//
//  MCEditBankCardController.m
//  MCOEM
//
//  Created by wza on 2020/4/24.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCEditBankCardController.h"

#import "MCXinyongkaHeader.h"
#import "MCChuxukaHeader.h"
@interface MCEditBankCardController ()

@property(nonatomic, strong) MCBankCardModel *model;
@property(nonatomic, assign) MCBankCardType type;


@end

@implementation MCEditBankCardController

- (instancetype)initWithType:(MCBankCardType)type cardModel:(MCBankCardModel *)model {
    self = [super init];
    if (self) {
        self.type = type;
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == MCBankCardTypeXinyongka) {
        MCXinyongkaHeader *header = [MCXinyongkaHeader newFromNib];
        if (self.model) {
            header.model = self.model;
            [self setNavigationBarTitle:@"修改信用卡" tintColor:nil];
        } else {
            [self setNavigationBarTitle:@"添加信用卡" tintColor:nil];
            [self showGuidePage];
        }
        self.mc_tableview.tableHeaderView = header;
    } else {
        MCChuxukaHeader *header = [MCChuxukaHeader newFromNib];
        header.loginVC = self.loginVC;
        header.whereCome = self.whereCome;
        if (self.model) {
            header.model = self.model;
            [self setNavigationBarTitle:@"修改储蓄卡" tintColor:nil];
        } else {
            [self setNavigationBarTitle:@"添加储蓄卡" tintColor:nil];
            
            
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [shareBtn setTitle:@"客服" forState:UIControlStateNormal];
            [shareBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
            [shareBtn addTarget:self action:@selector(clickRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
            shareBtn.titleLabel.font = LYFont(14);
            shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);


            shareBtn.frame = CGRectMake(SCREEN_WIDTH - 70, StatusBarHeightConstant + 12, 70, 22);
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
        }
        self.mc_tableview.tableHeaderView = header;
    }
    
    
    
}
-(void)clickRightBtnAction{
[MCServiceStore pushMeiqiaVC];
}
-(void)showGuidePage{
    //空白的frame
    CGRect emptyRect = CGRectMake(0, 52+kTopHeight,KScreenWidth, 381);
    //图片的frame
    CGRect imgRect = CGRectMake(20,52+kTopHeight+381, kRealWidthValue(200), kRealWidthValue(200)*1417/1890);
    kWeakSelf(self);
    [[KDGuidePageManager shareManager] showGuidePageWithType:KDGuidePageTypeXinYongKaShouKuan emptyRect:emptyRect imgRect:imgRect imgStr:@"guide3" completion:^{}];
}
@end
