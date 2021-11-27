//
//  MCTeamController.m
//  MCOEM
//
//  Created by wza on 2020/5/11.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCTeamController.h"
#import "MCBannerView.h"
#import "MCTeamModel.h"
#import "MCTeamCell.h"
#import "MCTeamDetailController.h"



#define kBannerHeight 175*MCSCALE

@interface MCTeamController () <QMUITableViewDataSource, QMUITableViewDelegate>

@property(nonatomic, strong) MCBannerView *bannerView;

@property(nonatomic, strong) UILabel *lab1;
@property(nonatomic, strong) UILabel *lab2;
@property(nonatomic, strong) UILabel *lab3;

@property(nonatomic, copy) NSMutableArray<MCTeamModel *> *dataSource;

@end

@implementation MCTeamController
- (NSMutableArray<MCTeamModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (MCBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[MCBannerView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, kBannerHeight) bannerType:2];
    }
    return _bannerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"我的团队" tintColor:nil];
    [self.view addSubview:self.bannerView];
    [self.view addSubview:[self creatTop]];
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.separatorInset = UIEdgeInsetsZero;
    
    [self requestData];
    
    
    
}

- (UIView *)creatTop {
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, self.bannerView.bottom, SCREEN_WIDTH, 80)];
    top.backgroundColor = MAINCOLOR;
    NSArray *titles = @[@"已邀请",@"已实名",@"VIP"];
    UIStackView *HS = [[UIStackView alloc] initWithFrame:top.bounds];
    HS.axis = UILayoutConstraintAxisHorizontal;
    HS.distribution = UIStackViewDistributionFillEqually;
    HS.spacing = 0;
    HS.alignment = UIStackViewAlignmentCenter;
    for (int i=0; i<3; i++) {
        UILabel *lab1 = [[UILabel alloc] init];
        lab1.font = UIFontMake(16);
        lab1.textColor = UIColorWhite;
        lab1.text = titles[i];
    
        UILabel *lab2 = [[UILabel alloc] init];
        lab2.font = UIFontBoldMake(16);
        lab2.textColor = UIColorWhite;
        lab2.text = @"0";
        if (i == 0) {
            self.lab1 = lab2;
        }
        if (i == 1) {
            self.lab2 = lab2;
        }
        if (i == 2) {
            self.lab3 = lab2;
        }
        
        UIStackView *VS = [[UIStackView alloc] initWithArrangedSubviews:@[lab1,lab2]];
        VS.axis = UILayoutConstraintAxisVertical;
        VS.spacing = 2;
        VS.alignment = UIStackViewAlignmentCenter;
        
        [HS addArrangedSubview:VS];
    }
    [top addSubview:HS];
    
    return top;
}

- (void)layoutTableView {
    CGFloat y = NavigationContentTop + kBannerHeight + 80;
    self.mc_tableview.frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT-y);
}


- (void)requestData {
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_POST:@"/user/app/query/userteam" parameters:@{@"userId":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull resp) {
        weakSelf.lab1.text = [NSString stringWithFormat:@"%d",[resp.result[@"all"][@"betweenPush"] intValue]+[resp.result[@"all"][@"directPush"] intValue]];
        weakSelf.lab2.text = [NSString stringWithFormat:@"%@",resp.result[@"all"][@"realName"]];
        weakSelf.lab3.text = [NSString stringWithFormat:@"%@",resp.result[@"all"][@"vip"]];
    }];
    
    [self.sessionManager mc_POST:[NSString stringWithFormat:@"/user/app/usersys/query/%@",TOKEN] parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *temp = [MCTeamModel mj_objectArrayWithKeyValuesArray:resp.result[@"thirdLevelDistribution"]];
        [weakSelf.dataSource removeAllObjects];
        if (SharedUserInfo.brandStatus.intValue != 0) { //贴牌商
            weakSelf.dataSource = [NSMutableArray arrayWithArray:temp];
        } else {
            for (MCTeamModel *model in temp) {
                if (![model.TrueFalseBuy isEqualToString:@"4"] || SharedUserInfo.grade.intValue >= model.grade.intValue) {
                    [weakSelf.dataSource addObject:model];
                }
            }
        }
        [weakSelf.mc_tableview reloadData];
    }];
}


#pragma mark - Tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MCTeamCell cellWithTableView:tableView teamModel:self.dataSource[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MCTeamDetailController *vc = [[MCTeamDetailController alloc] initWithTeamModel:self.dataSource[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
