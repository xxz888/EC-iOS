//
//  MCArticleMoreOpration.m
//  Pods
//
//  Created by wza on 2020/9/10.
//

#import "MCArticleMoreOpration.h"

@interface MCArticleMoreOpration()

@end

@implementation MCArticleMoreOpration

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[self creatContentView]];
    }
    return self;
}

- (UIView *)creatContentView {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = [UIColor qmui_colorWithHexString:@"#444444"];
    view.layer.cornerRadius = 4;
    UIStackView *stack = [[UIStackView alloc] initWithFrame:view.bounds];
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.alignment = UIStackViewAlignmentFill;
    stack.distribution = UIStackViewDistributionFillEqually;
    stack.spacing = 0;
    QMUIButton *copyBtn = [self creatItemButtonTitle:@"复制文案" icon:[UIImage mc_imageNamed:@"article_copy"]];
    copyBtn.tag = 1000;
    [copyBtn addTarget:self action:@selector(itemTouched:) forControlEvents:UIControlEventTouchUpInside];
    QMUIButton *saveBtn = [self creatItemButtonTitle:@"保存图片" icon:[UIImage mc_imageNamed:@"article_save"]];
    saveBtn.tag = 1001;
    [saveBtn addTarget:self action:@selector(itemTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [stack addArrangedSubview:copyBtn];
    [stack addArrangedSubview:saveBtn];
    [view addSubview:stack];
    
    return view;
}

- (QMUIButton *)creatItemButtonTitle:(NSString *)title icon:(UIImage *)img {
    QMUIButton *button = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.titleLabel.font = UIFontBoldMake(13);
    [button setImage:img forState:UIControlStateNormal];
    button.imagePosition = QMUIButtonImagePositionLeft;
    button.spacingBetweenImageAndTitle = 6;

    return button;
}
- (void)itemTouched:(QMUIButton *)sender {
    NSInteger idx = sender.tag - 1000;
    __weak __typeof(self)weakSelf = self;
    [self hideWithAnimated:YES completion:^(BOOL finished) {
        weakSelf.selectedBlock(idx);
    }];
}
@end
