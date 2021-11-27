//
//  MCAccreditation1ViewController.h
//  AFNetworking
//
//  Created by apple on 2020/10/30.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCAccreditation1ViewController : MCBaseViewController
@property (weak, nonatomic) IBOutlet QMUIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *userXieYiLbl;
- (IBAction)agreeAction:(id)sender;
- (IBAction)selectAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
