//
//  MCScrollText.m
//  Project
//
//  Created by Li Ping on 2019/5/30.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCScrollText.h"
#import "MCMessageModel.h"


@interface MCScrollText ()

@property (nonatomic, strong) UILabel *msg;

@end

@implementation MCScrollText

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

- (void)setup {
    self.clipsToBounds = YES;
    [self addSubview:self.msg];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = self.bounds;
    [self addSubview:btn];
    [btn addTarget:self action:@selector(onMsgTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self fetchMessage];
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(scrollText) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:t forMode:NSRunLoopCommonModes];
}

- (void)scrollText {
    if (CGRectGetMaxX(self.msg.frame) < 0) {
        self.msg.frame = CGRectMake(self.frame.size.width, 0, self.msg.frame.size.width, self.msg.frame.size.height);
    }
    self.msg.frame = CGRectMake(self.msg.frame.origin.x-1, 0, self.msg.frame.size.width, self.msg.frame.size.height);
}
- (void)fetchMessage {
    
    [MCLATESTCONTROLLER.sessionManager mc_GET:[NSString stringWithFormat:@"/user/app/jpush/history/brand/%@",TOKEN] parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        for (NSDictionary *dic in resp.result[@"content"]) {
            if (![dic[@"btype"] isEqualToString:@"androidVersion"]) { // 过滤安卓消息
                NSString * content = dic[@"content"];
                content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                content = [content stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
                CGSize s = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"PingFang-SC-Medium" size:13]} context:nil].size;
                
                self.msg.frame = CGRectMake(0, 0, s.width, self.frame.size.height);
                self.msg.text = content;
                
                break;
            }
        }
    }];
    
}

- (void)onMsgTouched:(UIButton *)sender {
    [MCPagingStore pagingURL:rt_notice_list];
}

- (UILabel *)msg {
    if (!_msg) {
        _msg = [[UILabel alloc] initWithFrame:self.bounds];
        _msg.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 13];
        _msg.textColor = [UIColor colorWithRed:38/255.0 green:39/255.0 blue:46/255.0 alpha:1.0];
        _msg.text = [NSString stringWithFormat:@"欢迎使用%@！", BCFI.brand_name];
    }
    return _msg;
}

@end
