//
//  MCModuleListController.m
//  MCOEM
//
//  Created by wza on 2020/5/12.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCModuleListController.h"

@interface MCModuleListController ()<QMUITableViewDelegate, QMUITableViewDataSource>

@property(nonatomic, strong) NSMutableArray<MCRouterModuleModel *> *dataSource;

@end

@implementation MCModuleListController
- (NSMutableArray<MCRouterModuleModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarTitle:@"Modules" tintColor:[UIColor qmui_randomColor]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem qmui_itemWithImage:[UIImage mc_imageNamed:@"nav_left_white"] target:self action:@selector(onLeftTouched:)];
    
    
    self.mc_tableview = [[QMUITableView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop-TabBarHeight) style:UITableViewStylePlain];
    [self.view addSubview:self.mc_tableview];
    
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    
    MGJRouter *router = [MGJRouter performSelector:NSSelectorFromString(@"sharedInstance")];
    NSMutableDictionary *routes = [[[router valueForKey:@"routes"] objectForKey:@"mc"] objectForKey:@"oc"];
    
    for (NSString *key in routes.allKeys) {
        MCRouterModuleModel *model = [MCRouterModuleModel new];
        model.module = key;
        model.controllerUrls = [routes[key] allKeys];
        [self.dataSource addObject:model];
    }
    
    
    [self.mc_tableview reloadData];
    
}
- (void)onLeftTouched:(UIBarButtonItem *)item {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].controllerUrls.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"rt_%@_%@", self.dataSource[indexPath.section].module,self.dataSource[indexPath.section].controllerUrls[indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *url = [NSString stringWithFormat:@"mc://oc/%@/%@", self.dataSource[indexPath.section].module,self.dataSource[indexPath.section].controllerUrls[indexPath.row]];
    [MCPagingStore pagingURL:url];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.dataSource[section].module;
}

@end


@implementation MCRouterModuleModel
@end
