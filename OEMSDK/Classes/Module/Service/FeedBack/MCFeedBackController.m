//
//  MCFeedBackController.m
//  Pods
//
//  Created by wza on 2020/8/19.
//

#import "MCFeedBackController.h"
#import <OEMSDK/OEMSDK.h>
#import "MCFeedBackHeader.h"
#import "KDCommonAlert.h"

@interface MCFeedBackController ()
@property(nonatomic, strong) MCFeedBackHeader *header;
@end

@implementation MCFeedBackController

- (MCFeedBackHeader *)header {
    if (!_header) {
        _header = [MCFeedBackHeader newFromNib];
    }
    return _header;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarTitle:@"意见反馈" tintColor:nil];
    self.mc_tableview.mj_header = self.header;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:@"提交" target:self action:@selector(rightTouched)];
}

- (void)rightTouched {
    if (self.header.textView.text.length < 1) {
        [MCToast showMessage:@"请输入您的意见和建议"];
        return;
    }
    if (self.header.textField.text.length < 1) {
        [MCToast showMessage:@"请输入您的联系方式"];
        return;
    }
    [MCLoading show];
    
    [self performSelector:@selector(tijiao) withObject:nil afterDelay:0.8];
}

- (void)tijiao {
    [MCLoading hidden];
    
    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
    [commonAlert initKDCommonAlertContent:@"感谢您的反馈"  isShowClose:YES];
//    [commonAlert initKDCommonAlertTitle:@"" content:@"感谢您的反馈" leftBtnTitle:@"取消" rightBtnTitle:@"确定" ];
    commonAlert.middleActionBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };    
    
//    QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:nil message:@"感谢您的反馈" preferredStyle:QMUIAlertControllerStyleAlert];
//    [alert addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }]];
//    [alert showWithAnimated:YES];
    
}
@end
