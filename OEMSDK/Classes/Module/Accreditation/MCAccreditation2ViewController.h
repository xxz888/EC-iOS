//
//  MCAccreditation2ViewController.h
//  OEMSDK
//
//  Created by apple on 2020/10/30.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCAccreditation2ViewController : MCBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView * zhengImv;
@property (weak, nonatomic) IBOutlet UIImageView *fanImv;

@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *idTf;

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
- (IBAction)finishAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
