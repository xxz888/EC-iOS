//
//  MCUpdate3FeilvCell.h
//  Pods
//
//  Created by wza on 2020/7/31.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MCUpdate3FeilvCell : UITableViewCell


@property(nonatomic, strong) QMUIMarqueeLabel *feilvLab1;
@property(nonatomic, strong) QMUIMarqueeLabel *feilvLab2;


+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end

NS_ASSUME_NONNULL_END
