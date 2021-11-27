//
//  MCWithdrawHistoryVC.m
//  AFNetworking
//
//  Created by wza on 2020/9/10.
//

#import "MCWithdrawHistoryVC.h"
#import "MCWithdrawHistoryCell.h"

@interface MCWithdrawHistoryVC ()<QMUITableViewDelegate, QMUITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *totalLab;

@property (weak, nonatomic) IBOutlet UILabel *dayAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *monthAmountLab;

@property (weak, nonatomic) IBOutlet UILabel *dayNumLab;
@property (weak, nonatomic) IBOutlet UILabel *monthNumLab;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *vvvv;

@end

@implementation MCWithdrawHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBarTitle:@"提现记录" backgroundImage:[UIImage qmui_imageWithColor:MAINCOLOR]];
    
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.rowHeight = 70;
    self.mc_tableview.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    self.bgView.backgroundColor = MAINCOLOR;
    self.bgView.layer.cornerRadius = 20;
    self.bgView.layer.qmui_maskedCorners = QMUILayerMinXMaxYCorner|QMUILayerMaxXMaxYCorner;
    

    self.vvvv.layer.cornerRadius = 10;
    self.vvvv.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    self.vvvv.layer.shadowOffset = CGSizeMake(0,1.5);
    self.vvvv.layer.shadowOpacity = 1;
    self.vvvv.layer.shadowRadius = 10;
    
    self.dayNumLab.textColor = self.monthNumLab.textColor = MAINCOLOR;
}

- (void)layoutTableView {
    self.mc_tableview.frame = CGRectMake(0, 340, SCREEN_WIDTH, SCREEN_HEIGHT-340);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MCWithdrawHistoryCell cellWithTableview:tableView];
}

@end
