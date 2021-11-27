//
//  MCShareOverViewController.m
//  Pods
//
//  Created by wza on 2020/8/19.
//

#import "MCShareOverViewController.h"
#import "MCShareOverViewCell.h"
#import "MCShareSingleImgViewController.h"
#import "MCShareManyNavigateController.h"

@interface MCShareOverViewController ()<QMUITableViewDelegate, QMUITableViewDataSource>
@property(nonatomic, copy) NSArray<UIImage*> *images;
@end

@implementation MCShareOverViewController
- (instancetype)initWithImages:(NSArray<UIImage *> *)images {
    self = [super init];
    if (self) {
        self.images = images;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarTitle:@"分享" tintColor:UIColor.whiteColor];
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mc_tableview.rowHeight = 135*MCSCALE;
    
    [self.mc_tableview reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.images.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MCShareOverViewCell cellFromTableView:tableView image:self.images[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [MCPagingStore pagingURL:rt_share_single];
    } else if (indexPath.row == 1) {
//        [MCPagingStore pagingURL:rt_share_many];
        [self.navigationController pushViewController:[MCShareManyNavigateController new] animated:YES];
    } else if (indexPath.row == 2) {
        [MCPagingStore pagingURL:rt_share_article];
    } else if (indexPath.row == 3) {
        [MCPagingStore pagingURL:rt_news_list withUerinfo:@{@"classification":@"信用秘籍"}];
    } else if (indexPath.row == 4) {
        [MCPagingStore pagingURL:rt_news_videos];
    }
}


@end
