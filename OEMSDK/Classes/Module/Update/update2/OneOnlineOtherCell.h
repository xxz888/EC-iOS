//
//  OneOnlineOtherCell.h
//  JFB
//
//  Created by Shao Wei Su on 2017/7/31.
//  Copyright © 2017年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCProductModel.h"


@interface OneOnlineOtherCell : UITableViewCell

/** 产品图标 */
@property (nonatomic, strong) UIImageView *proImageV;
/** 小图标一 */
@property (nonatomic, strong) UIImageView *littleImvOne;
/** 小图标二 */
@property (nonatomic, strong) UIImageView *littleImvTwo;
/** 产品名称 */
@property (nonatomic, strong) UILabel *proNameLabel;
/** 说明一 */
@property (nonatomic, strong) UILabel *infoOneLabel;
/** 说明二 */
@property (nonatomic, strong) UILabel *infoTwoLabel;
/** 是否购买*/
@property (nonatomic, strong) UILabel *isBuyLabel;

/** model */
@property (nonatomic, strong) MCProductModel *proModel;

- (void)setProModel:(MCProductModel *)proModel;

+ (instancetype)cellFromTableView:(UITableView *)tableview;


@end
