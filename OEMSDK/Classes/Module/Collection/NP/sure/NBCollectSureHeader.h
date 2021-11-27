//
//  NBCollectSureHeader.h
//  Project
//
//  Created by Li Ping on 2019/7/3.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCChooseCardModel.h"
#import "NBNPFindBankCardModel.h"

@protocol CollectSureHeaderDelegate <NSObject>

- (void)collectSureHeaderAction:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NBCollectSureHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UILabel *cardInfoLab;
@property (nonatomic, weak) id<CollectSureHeaderDelegate> delegate;

@property (nonatomic, strong) MCChooseCardModel *cardInfo;

@property (nonatomic, strong) NBNPFindBankCardModel *findModel;

@property (nonatomic, strong) MCChooseCardModel *bottomCardInfo;

@end

NS_ASSUME_NONNULL_END
