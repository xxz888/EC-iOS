//
//  KDTopDelegateHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/23.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDTopDelegateHeaderView.h"

@interface KDTopDelegateHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIImageView *topLogoView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@end

@implementation KDTopDelegateHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDTopDelegateHeaderView" owner:nil options:nil] firstObject];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.topView.layer.cornerRadius = 10;
    self.searchView.layer.cornerRadius = 10;
    self.searchBtn.titleLabel.font = [UIFont qmui_systemFontOfSize:15 weight:QMUIFontWeightBold italic:NO];
    self.topLogoView.layer.cornerRadius = 28;
    
    [self getUserInfo];
    [self getActivePerson:1];
}

- (void)reloadData
{
    [self getUserInfo];
    [self getActivePerson:1];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 284);
}
- (IBAction)searchText:(id)sender {
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(topDelegateHeaderViewSearchText:)]) {
        [self.delegate topDelegateHeaderViewSearchText:self.textField.text];
    }
}

- (void)getUserInfo
{
    // 查询用户信息
    [[MCSessionManager shareManager] mc_POST:@"/transactionclear/app/standard/extension/user/query" parameters:@{@"userId":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull resp) {
        NSDictionary *dict = resp.result;
        if (dict) {
            NSInteger grade = [dict[@"promotionLevelId"] intValue];
            if (grade <= 3) {
                self.nameLabel.text = @"顶级代理";
            } else {
                [self getGradeNameWithGrade:grade];
            }
            [self getWagesWithGrade:grade];
        } else {
            self.nameLabel.text = @"顶级代理";
            self.moneyLabel.text = @"0.00元";
        }
    }];
}
- (void)getGradeNameWithGrade:(NSInteger)grade
{
    [[MCSessionManager shareManager] mc_POST:@"/transactionclear/app/standard/agent/name" parameters:@{@"promotionLevelId":@(grade)} ok:^(MCNetResponse * _Nonnull resp) {
        NSDictionary *dict = resp.result;
        self.nameLabel.text = dict[@"gradeName"];
    }];
}
- (void)getWagesWithGrade:(NSInteger)grade
{
    [[MCSessionManager shareManager] mc_POST:@"/transactionclear/app/standard/wages/query" parameters:@{@"promotionLevelId":@(grade), @"userId":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull resp) {
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元", [resp.result floatValue]];
    }];
}
- (void)getActivePerson:(NSInteger)type
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SharedUserInfo.userid forKey:@"userId"];
    [[MCSessionManager shareManager] mc_POST:@"/transactionclear/app/standard/extension/user/record/all/query" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        NSDictionary *result = resp.result;
        self.lab1.text = result[@"activationByTime"];
        self.lab2.text = result[@"extensionByTime"];
        self.lab3.text = result[@"activationAll"];
        self.lab4.text = result[@"extensionAll"];
    }];
}

@end
