//
//  KDJFAdressListTableViewCell.h
//  KaDeShiJie
//
//  Created by apple on 2021/6/15.
//  Copyright © 2021 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDJFAdressListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cPhone;
@property (weak, nonatomic) IBOutlet UILabel *cName;
@property (weak, nonatomic) IBOutlet UILabel *cDetailAdress;
@property (weak, nonatomic) IBOutlet UILabel *cAdress;
@end

NS_ASSUME_NONNULL_END
