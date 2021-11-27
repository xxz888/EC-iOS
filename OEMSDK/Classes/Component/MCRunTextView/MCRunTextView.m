//
//  MCRunTextView.m
//  MCOEM
//
//  Created by SS001 on 2020/3/28.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCRunTextView.h"
#import "MCMessageModel.h"

@interface MCRunTextView ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *markView;
@property (nonatomic, strong) QMUIMarqueeLabel *runView;
@property (nonatomic, strong) UIButton *msgBtn;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation MCRunTextView

- (UIImageView *)iconView
{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage mc_imageNamed:@"laba"]];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}

- (UIView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor qmui_colorWithHexString:@"#D8D8D8"];
    }
    return _lineView;
}

- (UILabel *)markView
{
    if (!_markView) {
        _markView = [[UILabel alloc] init];
        _markView.textAlignment = NSTextAlignmentCenter;
        _markView.textColor = [UIColor whiteColor];
        _markView.backgroundColor = [UIColor mainColor];
        _markView.font = [UIFont qmui_lightSystemFontOfSize:10];
        _markView.layer.cornerRadius = 5;
        _markView.layer.masksToBounds = YES;
        _markView.text = @"消息";
    }
    return _markView;
}

- (QMUIMarqueeLabel *)runView
{
    if (_runView == nil) {
        _runView = [[QMUIMarqueeLabel alloc] init];
        _runView.spacingBetweenHeadToTail = 100;
        _runView.fadeWidthPercent = 0;
        _runView.speed = 1.f;
        _runView.shouldFadeAtEdge = NO;
        _runView.font = [UIFont qmui_lightSystemFontOfSize:13];
        _runView.textColor = [UIColor qmui_colorWithHexString:@"#999999"];
        _runView.text = [NSString stringWithFormat:@"欢迎使用%@，祝您生活愉快",MCModelStore.shared.brandConfiguration.brand_name];
    }
    return _runView;
}

- (UIButton *)msgBtn
{
    if (!_msgBtn) {
        _msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_msgBtn addTarget:self action:@selector(clickMsgView) forControlEvents:UIControlEventTouchUpInside];
        _msgBtn.showsTouchWhenHighlighted = NO;
    }
    return _msgBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    [self addSubview:self.iconView];
    [self addSubview:self.runView];
    [self addSubview:self.msgBtn];
    
    [self fetchMesage];
}

- (void)setShowMark:(BOOL)showMark
{
    _showMark = showMark;
    
    if (showMark) {
        [self addSubview:self.lineView];
        [self addSubview:self.markView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(self.iconView.mj_size);
    }];
    
    if (self.showMark) {
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).mas_offset(10);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(20);
        }];

        [self.markView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lineView.mas_right).mas_offset(10);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(32);
            make.height.mas_equalTo(16);
        }];

        [self.runView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            make.right.mas_offset(-10);
            make.left.equalTo(self.markView.mas_right).mas_offset(10);
        }];
    } else {
        [self.runView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            make.right.mas_offset(-10);
            make.left.equalTo(self.iconView.mas_right).mas_offset(10);
        }];
    }
    [self.msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.mas_offset(0);
    }];
}

- (void)clickMsgView
{
    MCLog(@"点击了滚动view");
    [MCPagingStore pagingURL:rt_notice_list];
}

- (void)fetchMesage{
    __weak __typeof(self)weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"/user/app/jpush/history/brand/%@", TOKEN];
    [[MCSessionManager shareManager] mc_GET:url parameters:nil ok:^(MCNetResponse * _Nonnull okResponse) {
        
        NSArray <MCMessageModel *> *array = [MCMessageModel mj_objectArrayWithKeyValuesArray:okResponse.result[@"content"]];
        NSMutableString *content = [NSMutableString string];
        for (MCMessageModel *model in array) {
            if (![model.btype containsString:@"androidVersion"]) {
                NSString *appendString = [model.content stringByAppendingFormat:@"%@      ",model.content];
                [content appendString:appendString];
                break;
            }
        }
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        content = [content stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
        //MCLog(@"%@",content);
//        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.runView.text = content;
//        });
        
        

    }];
}
@end
