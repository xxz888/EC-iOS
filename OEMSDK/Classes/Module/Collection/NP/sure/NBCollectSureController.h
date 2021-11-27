//
//  NBCollectSureController.h
//  Project
//
//  Created by Li Ping on 2019/7/3.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCBaseViewController.h"
#import "NBNPFindBankCardModel.h"
#import "MCChooseCardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NBCollectSureController : MCBaseViewController


@property (nonatomic, strong) NBNPFindBankCardModel *findCardModel;
//信用卡
@property (nonatomic, strong) MCChooseCardModel *xykModel;
@end

NS_ASSUME_NONNULL_END
