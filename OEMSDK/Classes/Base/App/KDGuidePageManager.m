//
//  KDGuidePageManager.m
//  KaDeShiJie
//
//  Created by apple on 2021/3/5.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDGuidePageManager.h"
@interface KDGuidePageManager ()

@property (nonatomic, copy) FinishBlock finish;
@property (nonatomic, copy) ShiMingBlock shimingBlock;

@property (nonatomic, copy) NSString *guidePageKey;
@property (nonatomic, assign) KDGuidePageType guidePageType;
@property (nonatomic) CGRect emptyRect;
@property (nonatomic) CGRect imgRect;

@end
@implementation KDGuidePageManager
+ (instancetype)shareManager {
    static KDGuidePageManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KDGuidePageManager alloc] init];
    });
    return manager;
}

#pragma mark --------------------先查询是否实名-------------------------
-(void)requestShiMing:(ShiMingBlock)shimingBlock{

    [MCModelStore.shared reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
        //realnameStatus为0的话，就是未实名
        if ([userInfo.realnameStatus integerValue] != 1) {
            NSString *msg = @"您的账号还未实名，实名认证后即可使用所有功能";
            QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:QMUIAlertControllerStyleAlert];
            [alert addAction:[QMUIAlertAction actionWithTitle:@"暂不实名" style:QMUIAlertActionStyleCancel handler:nil]];
            [alert addAction:[QMUIAlertAction actionWithTitle:@"去实名" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
                [MCLATESTCONTROLLER.navigationController pushViewController:[MGJRouter objectForURL:rt_card_vc2] animated:YES];
            }]];
            [alert showWithAnimated:YES];
        }else{
            shimingBlock();
        }
    }];
}


- (void)showGuidePageWithType:(KDGuidePageType)type emptyRect:(CGRect)emptyRect imgRect:(CGRect)imgRect imgStr:(NSString *)imgStr{
    [self creatControlWithType:type emptyRect:emptyRect imgRect:imgRect imgStr:imgStr completion:NULL];
}

- (void)showGuidePageWithType:(KDGuidePageType)type emptyRect:(CGRect)emptyRect imgRect:(CGRect)imgRect imgStr:(NSString *)imgStr completion:(FinishBlock)completion {
//    [self creatControlWithType:type emptyRect:emptyRect imgRect:imgRect imgStr:imgStr completion:completion];
//    return;
    [MCModelStore.shared reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
        //已实名&未认证&没有点击退出向导，才给遮罩
        BOOL isFIRSTSHIMING = [[NSUserDefaults standardUserDefaults] boolForKey:@"ISNEEDZHIYIN"];

        
        if ([userInfo.realnameStatus integerValue] == 1 && [userInfo.verificationStatus integerValue] == 0 && isFIRSTSHIMING) {
            [self creatControlWithType:type emptyRect:emptyRect imgRect:imgRect imgStr:imgStr completion:completion];
        }
    }];
    
}

- (void)creatControlWithType:(KDGuidePageType)type emptyRect:(CGRect)emptyRect imgRect:(CGRect)imgRect imgStr:(NSString *)imgStr completion:(FinishBlock)completion{
    _finish = completion;
    self.emptyRect = emptyRect;
    self.imgRect = imgRect;
    // 遮盖视图
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    //退出向导位置是写死的，不动就行
    UIImageView * skipImgView = [[UIImageView alloc]init];
    [bgView addSubview:skipImgView];
    skipImgView.frame = CGRectMake(KScreenWidth-100, kStatusBarHeight+5, kRealWidthValue(90), kRealWidthValue(90)*138/270);
    skipImgView.image = [UIImage mc_imageNamed:@"guide_tip"];
    
    //遮罩指引的图片，每个界面的位置和图片都不一样
    UIImageView *imgView = [[UIImageView alloc] init];
    [bgView addSubview:imgView];
    
   
    // 第一个路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:emptyRect cornerRadius:5] bezierPathByReversingPath]];
    imgView.frame = imgRect;
    imgView.image = [UIImage mc_imageNamed:imgStr];
    
    // 绘制透明区域
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [bgView.layer setMask:shapeLayer];
}

- (void)tap:(UITapGestureRecognizer *)recognizer {
    
    CGPoint point = [recognizer locationInView:recognizer.view];
    //透明区域点击
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.emptyRect cornerRadius:5] ;
    if ([path containsPoint:point]) {
        UIView *bgView = recognizer.view;
        [bgView removeFromSuperview];
        [bgView removeGestureRecognizer:recognizer];
        [[bgView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        bgView = nil;
        if (_finish) _finish();
    }
    
    //退出向导的方法
    CGRect skipRect = CGRectMake(KScreenWidth-100, kStatusBarHeight+5, kRealWidthValue(90), kRealWidthValue(90)*142/228);
    UIBezierPath * skipPath = [UIBezierPath bezierPathWithRoundedRect:skipRect cornerRadius:0];
    if ([skipPath containsPoint:point]) {
        UIView *bgView = recognizer.view;
        [bgView removeFromSuperview];
        [bgView removeGestureRecognizer:recognizer];
        [[bgView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        bgView = nil;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ISNEEDZHIYIN"];

        
    }
}
@end
