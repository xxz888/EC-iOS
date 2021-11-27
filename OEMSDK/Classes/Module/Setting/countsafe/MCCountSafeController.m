//
//  MCCountSafeController.m
//  MCOEM
//
//  Created by wza on 2020/4/21.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCCountSafeController.h"
#import "MCResetPWDController.h"

@interface MCCountSafeController ()<QMUITableViewDelegate, QMUITableViewDataSource>

@property(nonatomic, strong) NSArray<NSDictionary *> *dataSource;

@end

@implementation MCCountSafeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:SharedConfig.safe_title tintColor:UIColor.whiteColor];
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.mj_header = nil;
    self.dataSource = @[
        @{@"img":[UIImage mc_imageNamed:@"one_safe_paypass_reset"],
          @"title":@"重置交易密码"
        }];
    [self.mc_tableview reloadData];
    self.mc_tableview.separatorInset = UIEdgeInsetsZero;
}




#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = UIFontMake(16);
        cell.textLabel.textColor = UIColorBlack;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.imageView.image = [self.dataSource[indexPath.row] objectForKey:@"img"];
    cell.textLabel.text = [self.dataSource[indexPath.row] objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MCResetPWDType type = MCResetPWDTypeTrade;
    MCResetPWDController *vc = [[MCResetPWDController alloc] initWithType:type];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
