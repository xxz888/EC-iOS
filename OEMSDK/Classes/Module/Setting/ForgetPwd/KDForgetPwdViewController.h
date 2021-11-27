//
//  KDForgetPwdViewController.h
//  KaDeShiJie
//
//  Created by apple on 2020/11/3.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDForgetPwdViewController : MCBaseViewController
@property (weak, nonatomic) IBOutlet QMUITextField *phoneTf;
@property (weak, nonatomic) IBOutlet QMUITextField *pwd1Tf;
@property (weak, nonatomic) IBOutlet QMUITextField *pwd2Tf;
@property (weak, nonatomic) IBOutlet QMUITextField *codeTf;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
- (IBAction)finishAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property(nonatomic, strong) NSString * startPhone;

@end

NS_ASSUME_NONNULL_END
