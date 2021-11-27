//
//  KDChannelView.m
//  OEMSDK
//
//  Created by apple on 2020/12/14.
//

#import "KDChannelView.h"

@implementation KDChannelView


- (void)drawRect:(CGRect)rect {
    ViewBorderRadius(self.codeTf, 5, 1, [UIColor colorWithRed:253/255.0 green:241/255.0 blue:150/255.0 alpha:1.0]);
}


- (IBAction)codeAction:(id)sender {
    [self changeSendBtnText:self.codeBtn];
    if (self.sendBtnActionBlock) {
        self.sendBtnActionBlock();
    }
}
- (IBAction)bindChannelAction:(id)sender {
    if (self.bindBtnActionBlock) {
        self.bindBtnActionBlock();
    }
}

- (IBAction)closeAction:(id)sender {
    
    if (self.closeActionBlock) {
        self.closeActionBlock();
    }
}
//------ 验证码发送按钮动态改变文字 ------//
- (void)changeSendBtnText:(UIButton *)codeBtn{
    __block NSInteger second = 60;
    // 全局队列 默认优先级
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 定时器模式 事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // NSEC_PER_SEC是秒 *1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second >= 0) {
                [codeBtn setBackgroundImage:nil forState:0];
                [codeBtn setTitle:[NSString stringWithFormat:@"%lds", second] forState:UIControlStateNormal];
                [codeBtn setUserInteractionEnabled:NO];
                second--;
            }else {
                dispatch_source_cancel(timer);
                [codeBtn setBackgroundImage:[UIImage mc_imageNamed:@"KD_Channel_CodeBtn"] forState:0];

                [codeBtn setTitle:@"" forState:(UIControlStateNormal)];
                [codeBtn setUserInteractionEnabled:YES];
            }
        });
    });
    // 启动源
    dispatch_resume(timer);
}
@end
