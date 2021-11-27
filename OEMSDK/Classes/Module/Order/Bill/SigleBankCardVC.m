//
//  SigleBankCardVC.m
//  Project
//
//  Created by liuYuanFu on 2019/6/4.
//  Copyright © 2019 LY. All rights reserved.
//

#import "SigleBankCardVC.h"

#import "SingleBankView.h"
#import "SingleBankCell.h"

@interface SigleBankCardVC ()<QMUITableViewDataSource,QMUITableViewDelegate,SigleBankDelegate>

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *earningArr;
@property (nonatomic, strong) NSMutableDictionary *earDic;

@property (nonatomic, strong) SingleBankView *xibView;      // 头部视图

@end

@implementation SigleBankCardVC


#pragma mark --- LIFE
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _earDic = [[NSMutableDictionary alloc]init];
    _earningArr = [[NSMutableArray alloc]init];
    [self setNavigationBarTitle:@"" tintColor:[UIColor mainColor]];
    
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    
    //------ 2. headerView ------/
    /**   加载View类型的xib方式   **/
    UINib *nib = [UINib nibWithNibName:@"SingleBankView" bundle:[NSBundle OEMSDKBundle]];
    NSArray *nibArray = [nib instantiateWithOwner:nil options:nil];
    self.xibView =(SingleBankView *)[nibArray lastObject];
    self.xibView.delegate = self;
    self.xibView.headArr = self.singleArr; //// 热线/图标/名称
    /**   加载View类型的xib方式   **/
    
    self.mc_tableview.tableHeaderView = self.xibView;
    self.mc_tableview.tableHeaderView.height = 260-64+NavigationContentTopConstant;
    
}

-(void)justMethodChuFa:(UIButton *)sender{
    if (sender.tag == 100) {// 返回
        [self.navigationController popViewControllerAnimated:YES];
    }else{// 拨打电话
        
        [MCServiceStore call:self.singleArr[0]];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"identii";
    SingleBankCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SingleBankCell" bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.cellArrZ = self.cellArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 发送短信到
    NSString *phoneStr = [NSString stringWithFormat:@"%@",self.cellArr[indexPath.row][1][1]];//发短信的号码
    NSString *smsContentStr = [NSString stringWithFormat:@"%@",self.cellArr[indexPath.row][1][0]];
    NSString *urlStr = [NSString stringWithFormat:@"sms://%@&body=%@", phoneStr, smsContentStr];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]; // 对中文进行编码
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

@end
