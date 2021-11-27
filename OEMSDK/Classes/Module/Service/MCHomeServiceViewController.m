//
//  MCHomeServiceViewController.m
//  OEMSDK
//
//  Created by apple on 2020/11/25.
//

#import "MCHomeServiceViewController.h"
#import "MQServiceToViewInterface.h"
#import <MeiQiaSDK/MQDefinition.h>
@interface MCHomeServiceViewController ()

@end

@implementation MCHomeServiceViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMQMessages:) name:MQ_RECEIVED_NEW_MESSAGES_NOTIFICATION object:nil];
    //请求未读消息
    [self requestGetUnreadMessages];
    
    [self requestGuanFangLiuYan];
    
    [self requestQueryFangLiuYan];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MQ_RECEIVED_NEW_MESSAGES_NOTIFICATION object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    [self setData];
}
-(void)setData{
    
    if (MCModelStore.shared.preUserPhone.length == 11) {
        NSString *pre = [MCModelStore.shared.preUserPhone substringToIndex:3];
        NSString *suf = [MCModelStore.shared.preUserPhone substringFromIndex:MCModelStore.shared.preUserPhone.length - 4];
        self.zhituiPhoneLbl.text = [NSString stringWithFormat:@"手机号:%@****%@",pre,suf];
    }

}
-(void)setUI{
    [self setNavigationBarTitle:@"客服" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];

    self.topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    self.topView.layer.shadowOffset = CGSizeMake(0,2.5);
    self.topView.layer.shadowOpacity = 1;
    self.topView.layer.shadowRadius = 10;
    
    self.middleView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    self.middleView.layer.shadowOffset = CGSizeMake(0,2.5);
    self.middleView.layer.shadowOpacity = 1;
    self.middleView.layer.shadowRadius = 10;
    
    self.bottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    self.bottomView.layer.shadowOffset = CGSizeMake(0,2.5);
    self.bottomView.layer.shadowOpacity = 1;
    self.bottomView.layer.shadowRadius = 10;
    
    self.liuyanbanView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    self.liuyanbanView.layer.shadowOffset = CGSizeMake(0,2.5);
    self.liuyanbanView.layer.shadowOpacity = 1;
    self.liuyanbanView.layer.shadowRadius = 10;
    
    ViewRadius(self.liuyanbanMessageLbl, 8);
    //添加点击手势
    self.kefuView.userInteractionEnabled = YES;
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView:)];
    [self.kefuView addGestureRecognizer:click];
        
    //添加点击手势
    self.liuyanbanView.userInteractionEnabled = YES;
    UITapGestureRecognizer * liuyanbanClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLiuyanbanView:)];
    [self.liuyanbanView addGestureRecognizer:liuyanbanClick];
    
    //添加点击手势
    self.bottomView.userInteractionEnabled = YES;
    UITapGestureRecognizer * dianhuaClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guanfangkefuAction:)];
    [self.bottomView addGestureRecognizer:dianhuaClick];
    
    //添加点击手势
    self.topView.userInteractionEnabled = YES;
    UITapGestureRecognizer * topViewClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zhituiTelAction:)];
    [self.topView addGestureRecognizer:topViewClick];

}
-(void)clickView:(id)tp{
    [MCServiceStore pushMeiqiaVC];
}
-(void)clickLiuyanbanView:(id)tp{
    [MCPagingStore pagingURL:rt_card_liuyanban];

}
- (IBAction)zhituiTelAction:(id)sender {
    if (MCModelStore.shared.preUserPhone) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",MCModelStore.shared.preUserPhone]]];
    } else {
        [MCToast showMessage:@"没有上级！"];
    }
}
- (IBAction)guanfangkefuAction:(id)sender {
    if (SharedBrandInfo.brandPhone) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",SharedBrandInfo.brandPhone]]];
    } else {
        [MCToast showMessage:@"获取客服电话失败！"];
    }
}

- (IBAction)kefuAction:(id)sender {
    [MCServiceStore pushMeiqiaVC];
}
#pragma mark === 永久闪烁的动画 ======

-(CABasicAnimation *)opacityForever_Animation:(float)time{

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。

    animation.fromValue = [NSNumber numberWithFloat:1.0f];

    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。

    animation.autoreverses = YES;

    animation.duration = time;

    animation.repeatCount = MAXFLOAT;

    animation.removedOnCompletion = NO;

    animation.fillMode = kCAFillModeForwards;

     animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。

    return animation;

}




// 监听收到美洽聊天消息的广播
- (void)didReceiveNewMQMessages:(NSNotification *)notification {
    //请求未读消息
    [self requestGetUnreadMessages];
}

-(void)requestGetUnreadMessages{
    kWeakSelf(self);
    [MQServiceToViewInterface getUnreadMessagesWithCompletion:^(NSArray *messages, NSError *error) {
    if ([messages count] == 0) {
        [weakself.kefuImv.layer removeAllAnimations];
        
    }else{
        [weakself.kefuImv.layer addAnimation:[weakself opacityForever_Animation:0.4] forKey:nil];
    }

}];
}

-(void)requestQueryFangLiuYan{
    __weak typeof(self) weakSelf = self;
    [MCSessionManager.shareManager mc_POST:@"/user/app/jpush/MessagePush/Query" parameters:@{@"userid":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull resp) {
        if ([resp.code isEqualToString:@"000000"]) {
            //这里判断未读数组，把未读变成已读
            for (NSDictionary * typeDic in resp.result) {
                if ([typeDic[@"type"] integerValue] == 0) {
                    [weakSelf.kefuImv.layer addAnimation:[weakSelf opacityForever_Animation:0.4] forKey:nil];
                    break;
                }
            }
        }
    }];
}
-(void)requestGuanFangLiuYan{
    __weak typeof(self) weakSelf = self;
    [MCSessionManager.shareManager mc_POST:@"/user/app/jpush/MessagePush/Query" parameters:@{@"userid":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull resp) {
        if ([resp.code isEqualToString:@"000000"]) {
            
            NSMutableArray * type2Array = [[NSMutableArray alloc]init];
            for (NSDictionary * typeDic in resp.result) {
                if ([typeDic[@"type"] integerValue] == 0) {
                    [type2Array addObject:typeDic];
                }
            }
            if ([type2Array count] > 0) {
                
                weakSelf.liuyanbanMessageLbl.hidden = NO;
                weakSelf.liuyanbanMessageLbl.text = [NSString stringWithFormat:@"%ld",[type2Array count]];
                if (type2Array.count > 99) {
                    weakSelf.liuyanbanMessageLbl.text = @"99+";
                }
                [weakSelf.liuyanbanMessageLbl.layer addAnimation:[weakSelf opacityForever_Animation:0.4] forKey:nil];

            }else{
                [weakSelf.kefuImv.layer removeAllAnimations];
                weakSelf.liuyanbanMessageLbl.hidden = YES;
            }
        }else{
            [MCToast showMessage:resp.messege];
        }

    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        [MCToast showMessage:resp.messege];
    }];
}
@end
