//
//  KDSearchView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDSearchView.h"

@interface KDSearchView ()<UITextFieldDelegate>
@property (nonatomic, assign) CGRect mFrame;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) QMUIButton *searchBtn;
@end

@implementation KDSearchView

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, self.mFrame.size.width - 30, self.mFrame.size.height)];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = LYFont(14);
        _textField.textColor = [UIColor qmui_colorWithHexString:@"#333333"];
        _textField.hidden = YES;
        _textField.delegate = self;
    }
    return _textField;
}

- (QMUIButton *)searchBtn
{
    if (!_searchBtn) {
        _searchBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setImage:[UIImage imageNamed:@"kd_search"] forState:UIControlStateNormal];
        [_searchBtn setTitle:@"请输入手机号或者姓名" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = LYFont(14);
        [_searchBtn setTitleColor:[UIColor qmui_colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _searchBtn.spacingBetweenImageAndTitle = 10;
        _searchBtn.frame = CGRectMake(0, 0, self.mFrame.size.width, self.mFrame.size.height);
        [_searchBtn addTarget:self action:@selector(clickSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mFrame = frame;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self addSubview:self.textField];
        [self addSubview:self.searchBtn];
    }
    return self;
}

- (void)clickSearchBtn
{
    self.searchBtn.hidden = YES;
    self.textField.hidden = NO;
    [self.textField becomeFirstResponder];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length != 0) {
        if ([self.delegate respondsToSelector:@selector(inputTextFieldString:)]) {
            [self.delegate inputTextFieldString:textField.text];
        }
    }
}
@end
