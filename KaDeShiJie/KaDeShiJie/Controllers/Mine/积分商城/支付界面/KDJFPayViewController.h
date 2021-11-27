//
//  KDJFPayViewController.h
//  KaDeShiJie
//
//  Created by apple on 2021/6/8.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDJFPayViewController : MCBaseViewController
- (IBAction)zhifuAction:(id)sender;
@property(nonatomic,strong)NSDictionary * goodDic;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *zfbBtn;
- (IBAction)wxAction:(id)sender;
- (IBAction)zfbAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@end

NS_ASSUME_NONNULL_END
