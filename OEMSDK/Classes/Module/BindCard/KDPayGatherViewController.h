//
//  KDPayGatherViewController.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/12.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDPayGatherViewController : MCBaseViewController
//@property (nonatomic, strong) MCChannelModel *channelModel;
@property (nonatomic, strong) MCBankCardModel *cardModel;
@property (nonatomic, strong) NSString *money;
- (instancetype)initWithClassification:(MCBankCardModel *)cardModel;


@property (weak, nonatomic) IBOutlet UILabel *change2Lbl;

@property (weak, nonatomic) IBOutlet UIButton *change2Btn;

@property (weak, nonatomic) IBOutlet UILabel *change1TagLbl;
@property (weak, nonatomic) IBOutlet UILabel *change2TagLbl;


@end

NS_ASSUME_NONNULL_END
