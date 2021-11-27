//
//  KDProvisionsViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDProvisionsViewController.h"
#import "KDShiftToProvisionsViewController.h"
#import "KDOutProvisionsViewController.h"

@interface KDProvisionsViewController ()
@property (weak, nonatomic) IBOutlet UIView *topContentView;
// 历史记录
@property (weak, nonatomic) IBOutlet UIButton *historyBtn;
@property (weak, nonatomic) IBOutlet UIButton *outBtn;
@property (weak, nonatomic) IBOutlet UIButton *inBtn;

@end

@implementation KDProvisionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 历史记录
    self.historyBtn.layer.cornerRadius = self.historyBtn.ly_height * 0.5;
    
    // 转入
    self.inBtn.layer.cornerRadius = 4;
    // 转出
    self.outBtn.layer.cornerRadius = 4;

    self.topContentView.layer.cornerRadius = 12;
    self.topContentView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    self.topContentView.layer.shadowOffset = CGSizeMake(0,2.5);
    self.topContentView.layer.shadowOpacity = 1;
    self.topContentView.layer.shadowRadius = 15;
    
    [self setNavigationBarHidden];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage mc_imageNamed:@"nav_left_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, StatusBarHeightConstant, 44, 44);
    [self.view addSubview:backBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"备付金介绍" forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:[UIColor whiteColor]];
    shareBtn.layer.cornerRadius = 11;
    [shareBtn setTitleColor:UIColor.mainColor forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleLabel.font = LYFont(13);
    shareBtn.frame = CGRectMake(SCREEN_WIDTH - 84, StatusBarHeightConstant + 12, 94, 22);
    [self.view addSubview:shareBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = @"备付金";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}

- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 备付金介绍
- (void)clickRightBtnAction
{
    
}

#pragma mark - 转入
- (IBAction)shiftToAction:(UIButton *)sender {
    [self.navigationController pushViewController:[KDShiftToProvisionsViewController new] animated:YES];
}
- (IBAction)outProvisions:(id)sender {
    [self.navigationController pushViewController:[KDOutProvisionsViewController new] animated:YES];
}
@end
