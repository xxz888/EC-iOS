//
//  KDCVNAlertContent.m
//  Pods
//
//  Created by wza on 2020/9/11.
//

#import "KDCVNAlertContent.h"

@interface KDCVNAlertContent ()

@property (weak, nonatomic) IBOutlet UIButton *btn;


@end

@implementation KDCVNAlertContent

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btn.layer.cornerRadius = self.btn.height/2;
    self.layer.cornerRadius = 12;
}
- (IBAction)onBtnTouched:(UIButton *)sender {
    if (self.touchBlock) {
        self.touchBlock();
    }
}

@end
