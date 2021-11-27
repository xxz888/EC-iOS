//
//  KDMsgViewCell.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/8.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDMsgViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@end

NS_ASSUME_NONNULL_END
