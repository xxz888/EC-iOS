//
//  MCSegementView.m
//  MCOEM
//
//  Created by wza on 2020/4/24.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCSegementView.h"

@interface MCSegementView ()

@property(nonatomic, strong) UIStackView *stack;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) NSMutableArray<QMUIButton *> *buttons;


@end

@implementation MCSegementView

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColor.mainColor;
        _lineView.qmui_height = 3;
        _lineView.layer.cornerRadius = 1.5;
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (NSMutableArray<QMUIButton *> *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray new];
    }
    return _buttons;
}
- (UIStackView *)stack {
    if (!_stack) {
        _stack = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, self.qmui_width, self.qmui_height-1.5)];
        _stack.axis = UILayoutConstraintAxisHorizontal;
        _stack.distribution = UIStackViewDistributionFillEqually;
        _stack.alignment = UIStackViewAlignmentFill;
        _stack.spacing = 0;
        [self addSubview:_stack];
    }
    return _stack;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    [self.buttons removeAllObjects];
    for (int i=0; i<titles.count; i++) {
        QMUIButton *button = [self creatButtonWithTitle:titles[i]];
        if (i==0) {
            button.selected = YES;
            [self.delegate segementViewDidSeletedIndex:0 buttonTitle:titles[i]];
        }
        [self.buttons addObject:button];
        [self.stack addArrangedSubview:button];
        if (titles.count > 1) {
            
        }
    }
    
    self.lineView.qmui_top = self.qmui_height-3;
    self.lineView.qmui_width = 24;
    self.lineView.centerX = self.width/4;
}

- (QMUIButton *)creatButtonWithTitle:(NSString *)title {
    QMUIButton *button = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColorBlack forState:UIControlStateNormal];
    [button setTitleColor: UIColor.mainColor forState:UIControlStateSelected];
    [button setTitleColor: UIColor.mainColor forState:UIControlStateHighlighted];
    button.titleLabel.font = UIFontMake(16);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonClick:(QMUIButton *)button {
    
    if (button.isSelected) {
        return;
    }
    for (QMUIButton *bu in self.buttons) {
        if (bu != button) {
            bu.selected = NO;
        }
    }
    button.selected = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.centerX = button.centerX;
    }];
    
    [self.delegate segementViewDidSeletedIndex:[self.buttons indexOfObject:button] buttonTitle:button.currentTitle];
}

- (NSInteger)currentIndex {
    for (int i = 0; i < self.buttons.count; i++) {
        QMUIButton *btn = self.buttons[i];
        if (btn.isSelected) {
            return i;
            break;
        }
    }
    return 0;
}

@end
