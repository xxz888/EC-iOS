//
//  MCFeedBackHeader.m
//  Pods
//
//  Created by wza on 2020/8/19.
//

#import "MCFeedBackHeader.h"

@implementation MCFeedBackHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textView.placeholder = @"真诚为您服务，您的意见和建议将是我们努力的动力";
    self.textField.placeholder = @"请留下手机号或邮箱，方便我们给您答复";
    
    self.textView.contentInset = UIEdgeInsetsMake(0, 20, 0, 0);
    self.textField.textInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textField.font = [UIFont systemFontOfSize:15];
    
    
    self.button1.selected = YES;
    
    [self.button1 addTarget:self action:@selector(typeChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 addTarget:self action:@selector(typeChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.button3 addTarget:self action:@selector(typeChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.button1 setTitle:@"功能异常：功能故障或不可用" forState:UIControlStateNormal];
    [self.button2 setTitle:@"产品建议：用的不爽" forState:UIControlStateNormal];
    [self.button3 setTitle:@"其他" forState:UIControlStateNormal];
}

- (void)typeChanged:(MCFeedTypeButton *)sender {
    self.button1.selected = NO;
    self.button2.selected = NO;
    self.button3.selected = NO;
    
    sender.selected = YES;
}

@end
