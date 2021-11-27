//
//  MCUpdateView.m
//  Project
//
//  Created by Li Ping on 2019/8/2.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCUpdateAlertView.h"
#import "STModal.h"

@interface MCUpdateAlertView ()

@property (nonatomic, strong) STModal *modal;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@property (weak, nonatomic) IBOutlet UILabel *brandNameLab;
@property (weak, nonatomic) IBOutlet UILabel *versionLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isForce;



@end

@implementation MCUpdateAlertView

- (STModal *)modal {
    if (!_modal) {
        _modal = [STModal modal];
        _modal.dimBackgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _modal;
}


- (void)showWithVersion:(NSString *)version content:(NSString *)content downloadUrl:(NSString *)url isForce:(BOOL)force {
    self.url = url;
    self.isForce = force;
    if (content) {
        self.contentLab.text = content;
    }
    self.brandNameLab.text = MCModelStore.shared.brandConfiguration.brand_name;
    if (version) {
        self.versionLab.text = [NSString stringWithFormat:@"v %@",version];
    }
    self.modal.hideWhenTouchOutside = !force;
    [self.modal showContentView:self animated:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    [self.updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.updateButton.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.updateButton.layer.cornerRadius = 4;
//    self.updateButton.layer.borderWidth = 1;
    
    
//    self.backgroundColor = [[UIColor mainColor] colorWithAlphaComponent:0.2];
    

}

- (IBAction)onUpdateTouched:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.url]];
    [self.modal hide:YES];
}

@end
