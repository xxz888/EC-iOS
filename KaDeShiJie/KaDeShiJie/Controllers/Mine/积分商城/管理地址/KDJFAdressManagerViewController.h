//
//  KDJFAdressManagerViewController.h
//  KaDeShiJie
//
//  Created by apple on 2021/6/11.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDJFAdressManagerViewController : MCBaseViewController
@property(nonatomic)BOOL whereCome;//yes 新增 no 编辑
@property (weak, nonatomic) IBOutlet UITextField *shouhuorenTf;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *adressTf;
@property (weak, nonatomic) IBOutlet UITextField *detailAdressTf;


- (IBAction)saveAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
