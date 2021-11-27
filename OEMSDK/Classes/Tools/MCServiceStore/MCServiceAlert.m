//
//  MCServiceAlert.m
//  Lianchuang_477
//
//  Created by wza on 2020/9/5.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCServiceAlert.h"
#import <OEMSDK/OEMSDK.h>

@interface MCServiceAlert ()

@property(nonatomic, strong) QMUIModalPresentationViewController *modalVC;
@property(nonatomic, strong) UIView *contentView;

@property(nonatomic, copy) NSArray *items;

@end

@implementation MCServiceAlert

static MCServiceAlert *_single = nil;

+ (instancetype)shared {
    
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        if (_single == nil) {
            _single = [[self alloc] init];
        }
    });
    return _single;
}

+ (void)showWithTypes:(NSArray *)types {
    
    MCServiceAlert *alert = [MCServiceAlert shared];
    alert.items = types;
    [alert.modalVC showWithAnimated:YES completion:nil];
}
+ (void)dismiss {
    [[MCServiceAlert shared].modalVC dismissViewControllerAnimated:YES completion:nil];
}

- (QMUIModalPresentationViewController *)modalVC {
    if (!_modalVC) {
        _modalVC = [[QMUIModalPresentationViewController alloc] init];
        _modalVC.animationStyle = QMUIModalPresentationAnimationStyleSlide;
        _modalVC.contentView = self.contentView;
        __weak __typeof(self)weakSelf = self;
        _modalVC.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
            weakSelf.contentView.frame = CGRectMake(10, SCREEN_HEIGHT-250, SCREEN_WIDTH-20, 230);
        };
    }
    return _modalVC;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = UIColor.whiteColor;
        _contentView.layer.cornerRadius = 5;
        _contentView.clipsToBounds = YES;
        //titleview
        UIView *titV = [self titleView];
        [_contentView addSubview:titV];
        [titV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        //stackview
        UIStackView *stack = [self stackV];
        [_contentView addSubview:stack];
        [stack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(titV.mas_bottom);
            make.height.mas_equalTo(100);
        }];
        //line
        UIView *line = [[UIView alloc] init];
        [_contentView addSubview:line];
        line.backgroundColor = UIColorForBackground;
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(stack.mas_bottom).offset(20);
            make.height.mas_equalTo(1);
        }];
        //cancel
        QMUIButton *cancelButton = [self cancelButton];
        [_contentView addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(line.mas_bottom);
            make.height.mas_equalTo(60);
        }];
        
        for (NSNumber *tn in self.items) {
            if (tn.intValue == 0) {
                QMUIButton *item = [self creatItemWithTitle:@"美洽客服" imageName:@"美洽客服"];
                [stack addArrangedSubview:item];
            }
            if (tn.intValue == 1) {
                QMUIButton *item = [self creatItemWithTitle:@"电话客服" imageName:@"电话客服"];
                [stack addArrangedSubview:item];
            }
            if (tn.intValue == 2) {
                QMUIButton *item = [self creatItemWithTitle:@"微信客服" imageName:@"微信客服"];
                [stack addArrangedSubview:item];
            }
            if (tn.intValue == 3) {
                QMUIButton *item = [self creatItemWithTitle:@"QQ客服" imageName:@"QQ客服"];
                [stack addArrangedSubview:item];
            }
        }
    }
    return _contentView;
}



- (UIView *)titleView {
    UIView *v = [[UIView alloc] init];
    QMUILabel *lab = [[QMUILabel alloc] init];
    lab.text = @"在线客服";
    lab.font = [UIFont boldSystemFontOfSize:16];
    lab.textColor = [UIColor darkGrayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [v addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    return v;
}

- (UIStackView *)stackV {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.alignment = UIStackViewAlignmentFill;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.distribution = UIStackViewDistributionFillEqually;
    stack.spacing = 0;
    return stack;
}

- (QMUIButton *)cancelButton {
    QMUIButton *button = [[QMUIButton alloc] init];
    button.qmui_automaticallyAdjustTouchHighlightedInScrollView = YES;
    button.adjustsButtonWhenHighlighted = NO;
    button.titleLabel.font = UIFontBoldMake(16);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:ButtonHighlightedAlpha] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(handleCancelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (QMUIButton *)creatItemWithTitle:(NSString *)title imageName:(NSString *)imgName {
    QMUIButton *button = [[QMUIButton alloc] qmui_initWithImage:[UIImage mc_imageNamed:imgName] title:title];
    button.imagePosition = QMUIButtonImagePositionTop;
    button.spacingBetweenImageAndTitle = 15;
    button.titleLabel.font = UIFontMake(12);
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(itemTouched:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)handleCancelButtonEvent:(QMUIButton *)sender {
    
    [self.modalVC hideWithAnimated:YES completion:nil];
}

- (void)itemTouched:(QMUIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"美洽客服"]) {
        [self.modalVC hideWithAnimated:YES completion:^(BOOL finished) {
            [MCServiceStore pushMeiqiaVC];
        }];
    }
    if ([sender.currentTitle isEqualToString:@"QQ客服"]) {
        [self.modalVC hideWithAnimated:YES completion:^(BOOL finished) {
            [MCServiceStore jumpQQ];
        }];
    }
    if ([sender.currentTitle isEqualToString:@"微信客服"]) {
        [self.modalVC hideWithAnimated:YES completion:^(BOOL finished) {
            [MCServiceStore jumpWeixin];
        }];
    }
    if ([sender.currentTitle isEqualToString:@"电话客服"]) {
        [self.modalVC hideWithAnimated:YES completion:^(BOOL finished) {
            [MCServiceStore callBrand];
        }];
    }
}

- (void)dealloc
{
    MCLog(@"MCServiceAlert dealloc");
}


@end
