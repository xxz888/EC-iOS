//
//  KDJFShopHeaderCollectionReusableView.h
//  KaDeShiJie
//
//  Created by apple on 2021/6/8.
//  Copyright © 2021 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDJFShopHeaderCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *lunboView;
@property (weak, nonatomic) IBOutlet UIImageView *personImv;
@property (weak, nonatomic) IBOutlet UILabel *personTitle;
@property (weak, nonatomic) IBOutlet UILabel *jifenLbl;
@property (weak, nonatomic) IBOutlet UIView *jifenView;

@end

NS_ASSUME_NONNULL_END
