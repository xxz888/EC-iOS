//
//  MCAlertStore.m
//  Project
//
//  Created by Li Ping on 2019/6/21.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCAlertStore.h"
#import "KDCommonAlert.h"


static MCAlertStore *_singleStore = nil;




@interface MCAlertStore()

@property (nonatomic, strong) QMUIModalPresentationViewController *modal;



@end

@implementation MCAlertStore

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_singleStore == nil) {
            _singleStore = [[self alloc]init];
        }
    });
    return _singleStore;
}


+ (void)showWithTittle:(NSString *)tit message:(NSString *)message buttonTitles:(NSArray *)titles sureBlock:(nullable sureBlock)block {
    
  [MCAlertStore showWithTittle:tit message:message buttonTitles:titles sureBlock:block cancelBlock:nil];    
}

+ (void)showWithTittle:(NSString *)tit message:(NSString *)message buttonTitles:(NSArray *)titles sureBlock:(sureBlock)block cancelBlock:(nullable cancelBlock)cancelblock {
    [[MCAlertStore shareInstance] showWithTittle:tit message:message buttonTitles:titles sureBlock:block cancelBlock:cancelblock];
}

- (void)showWithTittle:(NSString *)tit message:(NSString *)message buttonTitles:(NSArray *)titles sureBlock:(nullable sureBlock)block cancelBlock:(nullable cancelBlock)cancelblock {
    [self setupViewWithTittle:tit message:message buttonTitles:titles sureBlock:block cancelBlock:cancelblock];
}

- (void)setupViewWithTittle:(NSString *)tit message:(NSString *)message buttonTitles:(NSArray *)titles sureBlock:(nullable sureBlock)block cancelBlock:(nullable cancelBlock)cancelblock {
    
    if (self.modal.isVisible) {
        MCLog(@"正在展示");
        return;
    }
    
    self.block = block;
    self.cancelblock = cancelblock;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 30, DEFAULT_H)];
    view.backgroundColor = [UIColor whiteColor];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 5;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 60, 60)];
    imgView.image = [MCImageStore getAppIcon];
    imgView.layer.cornerRadius = 5;
    imgView.layer.masksToBounds = YES;
    [view addSubview:imgView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = tit;
    titleLab.numberOfLines = 0;
    titleLab.textColor = [UIColor darkTextColor];
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    CGSize size = [tit boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 120, MAXFLOAT)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:titleLab.font}
                                    context:nil].size;
    titleLab.frame = CGRectMake(80, 20, size.width, size.height);
    [view addSubview:titleLab];
    
    
    QMUITextView *msgLab = [[QMUITextView alloc] init];
    
    msgLab.text = message;
    msgLab.textColor = [UIColor lightGrayColor];
    msgLab.editable = NO;
    msgLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    
    msgLab.textContainerInset = UIEdgeInsetsZero;
    
    
    [view addSubview:msgLab];
    
    
    CGSize msize = [message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 120, MAXFLOAT)
           options:NSStringDrawingUsesLineFragmentOrigin
        attributes:@{NSFontAttributeName:msgLab.font}
           context:nil].size;
    
    CGFloat V_H = msize.height + 56 + 45 + 20;
    
    if (V_H <= DEFAULT_H) {
        msgLab.frame = CGRectMake(80, titleLab.qmui_bottom+10, view.qmui_width - 90, msize.height);
        
    } else {
        if (V_H > 400) {
                CGFloat mH = 400 - 56 - 45 - 10;
                msgLab.frame = CGRectMake(80, CGRectGetMaxY(titleLab.frame) + 10, view.qmui_width - 90, mH);
                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 400);
            } else {
                
                msgLab.frame = CGRectMake(80, CGRectGetMaxY(titleLab.frame) + 10, view.qmui_width - 90, msize.height+20);
                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, V_H+10);
            }
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 44, view.frame.size.width, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:line];
    
    if (titles) {
        if (titles.count == 1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:titles[0] forState:UIControlStateNormal];
            [button setTitleColor:MCModelStore.shared.brandConfiguration.color_main forState:UIControlStateNormal];
            button.frame = CGRectMake(0, view.frame.size.height - 43, view.frame.size.width, 43);
            [button addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
        }
        if (titles.count == 2) {
            
            CGFloat buttonW = (view.frame.size.width - 1)/2;
            
            UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancel setTitle:titles[0] forState:UIControlStateNormal];
            [cancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            cancel.frame = CGRectMake(0, view.frame.size.height - 43, buttonW, 43);
            [cancel addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:cancel];
            
            UIView *VL = [[UIView alloc] initWithFrame:CGRectMake(buttonW, view.frame.size.height-43, 1, 43)];
            VL.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [view addSubview:VL];
            
            UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
            [sure setTitle:titles[1] forState:UIControlStateNormal];
            [sure setTitleColor:MCModelStore.shared.brandConfiguration.color_main forState:UIControlStateNormal];
            sure.frame = CGRectMake(buttonW+1, view.frame.size.height - 43, buttonW, 43);
            [sure addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:sure];
        }
    }
    
    self.modal = [[QMUIModalPresentationViewController alloc] init];
    self.modal.modalPresentationStyle = QMUIModalPresentationAnimationStyleFade;
    self.modal.contentView = view;
    if ([titles containsObject:@"立即重登"]) {
        self.modal.modal = YES;
    }
    [self.modal showWithAnimated:YES completion:nil];
}

- (void)cancelClick:(UIButton *)sender {
    if (self.cancelblock) {
        self.cancelblock();
    }
    [self.modal hideWithAnimated:YES completion:nil];
}

- (void)sureClick:(UIButton *)sender {
    __weak __typeof(self)weakSelf = self;
    [self.modal hideWithAnimated:YES completion:^(BOOL finished) {
        if (weakSelf.block) {
            weakSelf.block();
        }
    }];
    
}

@end
