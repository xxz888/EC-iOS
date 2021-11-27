//
//  KDDirectPushChoseStatusView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDDirectPushChoseStatusView.h"

@interface KDDirectPushChoseStatusView ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;

@end

@implementation KDDirectPushChoseStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDDirectPushChoseStatusView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.topView.layer.cornerRadius = 14;
    
}

- (IBAction)choseStatusAction:(UIButton *)sender {
    if (self.choseStatus) {
        self.choseStatus(sender.titleLabel.text);
    }
}

- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    
    [self.btn1 setTitle:titleArray[0] forState:UIControlStateNormal];
    [self.btn2 setTitle:titleArray[1] forState:UIControlStateNormal];
    [self.btn3 setTitle:titleArray[2] forState:UIControlStateNormal];
    if (titleArray.count == 4) {
        [self.btn4 setTitle:titleArray[3] forState:UIControlStateNormal];
        self.pushHeight.constant = 228;
        self.btn4Height.constant = 57;
        self.btn4.hidden = NO;
    }else{
        self.pushHeight.constant = 228-57;
        self.btn4Height.constant = 0;

        self.btn4.hidden = YES;

    }
}
@end
