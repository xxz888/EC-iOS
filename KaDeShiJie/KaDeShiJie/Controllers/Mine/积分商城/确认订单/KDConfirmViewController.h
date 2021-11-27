//
//  KDConfirmViewController.h
//  KaDeShiJie
//
//  Created by apple on 2021/6/8.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDConfirmViewController : MCBaseViewController
@property (weak, nonatomic) IBOutlet UIView *noAddressView;

@property (weak, nonatomic) IBOutlet UIImageView *goodImv;
@property (weak, nonatomic) IBOutlet UILabel *goodTitle;
@property (weak, nonatomic) IBOutlet UILabel *goodPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodTotalPrice;
- (IBAction)confirmAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confrimBtn;
@property(nonatomic,strong)NSDictionary * goodDic;
@property (weak, nonatomic) IBOutlet UIView *haveAddressView;
@property (weak, nonatomic) IBOutlet UILabel *cPhone;
@property (weak, nonatomic) IBOutlet UILabel *cName;
@property (weak, nonatomic) IBOutlet UILabel *cDetailAdress;
@property (weak, nonatomic) IBOutlet UILabel *cAdress;




@end

NS_ASSUME_NONNULL_END
