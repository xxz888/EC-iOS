//
//  MCProductView.h
//  MCOEM
//
//  Created by wza on 2020/4/22.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MCProductViewTypeUpdate,
    MCProductViewTypeMyRate,
} MCProductViewType;

@interface MCProductView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIImageView *gradeImgView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *currentGradeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@property(nonatomic, assign) MCProductViewType type;

@end

NS_ASSUME_NONNULL_END
