//
//  MCShareOverViewCell.h
//  Pods
//
//  Created by wza on 2020/8/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCShareOverViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

+ (instancetype)cellFromTableView:(QMUITableView *)tableview image:(UIImage *)img;

@end

NS_ASSUME_NONNULL_END
