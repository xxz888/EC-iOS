//
//  MCRealNameViewController.m
//  Project
//
//  Created by SS001 on 2020/1/8.
//  Copyright © 2020 LY. All rights reserved.
//

#import "MCRealNameViewController.h"
#import "MCTXManager.h"
#import "MCManualRealNameController.h"
//#import <AuthSDK/AuthSDK.h>
#import "KDLoginTool.h"

static NSString *KRealNameConfig = @"/user/app/get/brand/config";

@interface MCRealNameViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MCRealNameViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (IBAction)leftBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setNavigationBarHidden];
    self.topView.layer.cornerRadius = 20;
    self.topView.layer.masksToBounds = YES;
    [self getData];
}

- (void)getData {
    NSDictionary *params = @{@"brandId":SharedConfig.brand_id};
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_POST:KRealNameConfig parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        NSString *artificialRecognition = resp.result[@"artificialRecognition"];
        NSString *faceRecognition = resp.result[@"faceRecognition"];
        if (faceRecognition.intValue == 1) {
            [weakSelf.dataArray addObject:@{@"type":@"0", @"img":@"mc_realname_1"}];
        }
//        if (artificialRecognition.intValue == 1) {
//            [weakSelf.dataArray addObject:@{@"type":@"1", @"img":@"mc_realname_0"}];
//        }
        weakSelf.tableView.hidden = NO;
        [weakSelf.tableView reloadData];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = [UIScreen mainScreen].bounds.size.width / 375;
    return 160 * scale;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"realnamecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    CGFloat scale = [UIScreen mainScreen].bounds.size.width / 375;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160 * scale)];
    imgView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:imgView];
    NSDictionary *dict = self.dataArray[indexPath.row];
    imgView.image = [UIImage mc_imageNamed:dict[@"img"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSInteger type = [dict[@"type"] intValue];
    
    
    //上海明哲活物识别
    if (type == 0) {
        __weak __typeof(self)weakSelf = self;
        [[MCTXManager shared] startFaceEngineCompletion:^(MCTXResult * _Nonnull result) {
            if (!result.error) {
                [MCToast showMessage:@"实名成功！"];
                
                [[KDLoginTool shareInstance] getChuXuCardData:NO];
            }
        }];
    //人工识别
    } else if(type == 1){
        [self.navigationController pushViewController:[MCManualRealNameController new] animated:YES];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
