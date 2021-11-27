//
//  KDCreditAlertView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDCreditAlertView.h"

@interface KDCreditAlertView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation KDCreditAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDCreditAlertView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 12;
}

- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    
    self.titleLabel.text = titleString;
}
- (IBAction)cancelAction:(id)sender {
    if (self.cancelBtnAction) {
        self.cancelBtnAction();
    }
}
- (IBAction)sureAction:(id)sender {
    if (self.sureBtnAction) {
        self.sureBtnAction();
    }
}
@end
