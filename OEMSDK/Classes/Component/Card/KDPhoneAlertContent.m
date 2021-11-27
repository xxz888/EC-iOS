//
//  KDPhoneAlertContent.m
//  Pods
//
//  Created by wza on 2020/9/11.
//

#import "KDPhoneAlertContent.h"

@interface KDPhoneAlertContent()

@property (weak, nonatomic) IBOutlet UIButton *btn;


@end



@implementation KDPhoneAlertContent

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btn.layer.cornerRadius = self.btn.height/2;
    self.layer.cornerRadius = 12;
}
- (IBAction)touched:(id)sender {
    if (self.touchBlock) {
        self.touchBlock();
    }
}

@end
