//
//  MCBillSearchViewController.m
//  AFNetworking
//
//  Created by SS001 on 2020/7/21.
//

#import "MCBillSearchViewController.h"
#import "BillSearchCell.h"
#import "SigleBankCardVC.h"

@interface MCBillSearchViewController ()<QMUITableViewDelegate, QMUITableViewDataSource>

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *earningArr;

@property (nonatomic, strong)NSArray *imgArr;
@property (nonatomic, strong)NSArray *textArr;
@property (nonatomic, strong)NSArray *numberArr;
@property (nonatomic, strong)NSArray *detailArr;

@property (nonatomic, strong)NSArray *xinNumberArr;
@property (nonatomic, strong)NSArray *cellArr;
@end

@implementation MCBillSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:@"账单查询" tintColor:[UIColor mainColor]];
    
    self.mc_tableview.delegate = self;
    self.mc_tableview.dataSource = self;
    self.imgArr = @[@"zhongxinyinhang",@"pudongfazhanyinhang",@"xingyeyinhang",@"guangfayinhang",@"zhongguoyinhang",@"huaxiayinhang",@"zhongguoyouzhengyinhang",@"shanghaiyinhang",@"zhongguojiansheyinhang",@"zhongguominshengyinhang",@"gongshangyinhang",@"jiaotongyinhang",@"zhongguonongyeyinhang",@"zhaoshangyinhang",@"pinganyinhang",@"zhongguoguangdayinhang"];
    self.textArr = @[@"中信银行",@"浦东发展银行",@"兴业银行",@"广发银行",@"中国银行",@"华夏银行",@"中国邮政储蓄银行",@"上海银行",@"中国建设银行",@"中国民生银行",@"工商银行",@"交通银行",@"中国农业银行",@"招商银行",@"平安银行",@"中国光大银行"];
    self.numberArr = @[@"95558",@"95528",@"95561",@"95508",@"95566",@"95577",@"95580",@"95594",@"95533",@"95568",@"95588",@"95559",@"95599",@"95555",@"95511",@"95595"];
    self.detailArr = @[@"查询可用额度、账单、积分",@"查询账单、积分",@"查询账单",@"查询可用额度、积分",@"查询可用额度、积分",@"查询账单",@"查询可用额度、积分",@"",@"查询可用额度、账单、积分",@"查询可用额度、账单、积分",@"查询可用额度、账单、积分",@"查询可用额度、账单、积分",@"查询可用额度、积分",@"查询可用额度、账单、积分",@"查询可用额度、账单",@"查询可用额度、账单、积分"];
    
    self.xinNumberArr = @[@"400-889-5558",@"400-820-8788",@"95561",@"400-830-8003",@"400-669-5566",@"400-669-5577",@"400-88-95580",@"95594",@"400-820-0588",@"400-669-5568",@"400-669-5588",@"400-800-9888",@"400-669-5599",@"400-820-5555",@"95511",@"400-788-8888"];
    
    /* 四维数组,第一维作为跳转的下标将二维数组带入到所跳转类,第二维数组设置为cell行数, 通过行数下标取到第三维数组赋值给cell内,cell第二行用第四维拼接*/
    self.cellArr = @[
                     @[
                         @[@"查询账单",@[@"ZD+卡号后四位",@"1069800955508"],@"ZD1234"],
                         @[@"查询可用额度",@[@"YE+卡号后四位",@"106980095558"],@"YE1234"],
                         @[@"查询积分",@[@"JF+卡号后四位",@"106980095558"],@"JF1234"]
                         ],
                     @[
                         @[@"查询账单",@[@"ZDCX+空格+卡号后四位",@"95528"],@"ZDCX1234"],
                           @[@"查询积分",@[@"JFCX+空格+卡号后四位",@"95528"],@"JFCX 1234"]
                    ],
                     @[
                         @[@"查询账单",@[@"30+卡号后四位",@"95561"],@"301234"]
                         ],
                     @[
                         @[@"查询可用额度",@[@"XED+卡号后四位",@"95508"],@"XED1234"],
                         @[@"查询积分",@[@"XJF+卡号后四位",@"95508"],@"XJF1234"]
                         ],
                     @[
                         @[@"查询可用额度",@[@"1#+卡号后四位",@"95566"],@"1#1234"],
                         @[@"查询积分",@[@"17#+卡号后四位",@"95566"],@"17#1234"]
                         ],
                     @[
                         @[@"查询账单",@[@"ZD+卡号后四位",@"106902895577"],@"ZD1234"]
                         ],
                     @[
                         @[@"查询可用额度",@[@"EDCX#+卡号后四位",@"95580"],@"EDXC#1234"],
                         @[@"查询积分",@[@"JFCX#+卡号后四位",@"95580"],@"JFCX#1234"]
                         ],
                     @[],
                     @[
                         @[@"查询账单",@[@"CCZD#+卡号后四位",@"95533"],@"CCZD#1234"],
                         @[@"查询可用额度",@[@"CCED#+卡号后四位",@"95533"],@"CCED#1234"],
                         @[@"查询积分",@[@"CCJF#+卡号后四位",@"95533"],@"CCJF#1234"]
                         ],
                     @[
                         @[@"查询账单",@[@"ZD+卡号后四位",@"106902895568"],@"ZD1234"],
                         @[@"查询可用额度",@[@"ED+卡号后四位",@"106902895568"],@"ED1234"],
                         @[@"查询积分",@[@"JF+卡号后四位",@"106902895568"],@"JF1234"]
                         ],
                     @[
                         @[@"查询账单",@[@"CXZD#+卡号#+短信密码",@"95588"],@"CXZD#6236681820051005104#123456"],
                         @[@"查询可用额度",@[@"CXZD#+卡号#+短信密码",@"95588"],@"CXED#6236681820051005104#123456"],
                         @[@"查询积分",@[@"CXJF#+卡号#+短信密码",@"95588"],@"CXJF#6236681820051005104#123456"]
                         ],
                     @[
                         @[@"查询账单",@[@"CC账单#+卡号后四位",@"95559"],@"CC账单#1234"],
                         @[@"查询可用额度",@[@"CC额度#+卡号后四位",@"95559"],@"CC额度#1234"],
                        @[@"查询积分",@[@"CC积分#+卡号后四位",@"95559"],@"CC积分#1234"]
                         ],
                     @[
                        @[@"查询账单",@[@"CCDQZD#+卡号后四位",@"1069095599"],@"CCDQZD#1234"],
                         @[@"查询积分",@[@"CCJFKH#+卡号后四位",@"1069095599"],@"CCJFKH#1234"]
                         ],
                     
                     @[
                         @[@"查询账单(移动用户)",@[@"#ZD",@"1065795555"],@""],
                         @[@"查询账单(联通、电信用户)",@[@"#ZD",@"1065502010095555"],@""],
                         @[@"查询可用额度(移动用户)",@[@"#ED",@"1065795555"],@""],
                         @[@"查询可用额度(联通、电信用户)",@[@"#ED",@"1065502010095555"],@""],
                         @[@"查询积分(移动用户)",@[@"#JF",@"1065795555"],@""],
                         @[@"查询积分（联通、电信用户）",@[@"#JF",@"1065502010095555"],@""]
                         ],
                     
                     @[
                         @[@"查询账单",@[@"ZD",@"9551186"],@""],
                         @[@"查询可用额度",@[@"ED",@"9551186"],@""]
                         ],
                     @[
                         @[@"查询账单",@[@"账单#+卡号后四位",@"95595"],@"账单#1234"],
                         @[@"查询可用额度",@[@"额度#+卡号后四位",@"95595"],@"额度#1234"],
                         @[@"查询积分",@[@"积分#+卡号后四位",@"95595"],@"积分#1234"]
                         ]
    ];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.textArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BillSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillSearchCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"BillSearchCell" bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:@"BillSearchCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"BillSearchCell"];
    }
    cell.text.text = self.textArr[indexPath.row];
    cell.img.image = [UIImage mc_imageNamed:self.imgArr[indexPath.row]];
    cell.detail.text = self.detailArr[indexPath.row];
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"客服热线%@",self.numberArr[indexPath.row]]];
    [string addAttribute:NSForegroundColorAttributeName value:UIColor.mainColor range:NSMakeRange(4,[self.numberArr[indexPath.row] length])];
    
    cell.number.attributedText =string;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SigleBankCardVC *card = [[SigleBankCardVC alloc]init];
    // 信用卡热线/图标/名称
    card.singleArr = @[self.xinNumberArr[indexPath.row],self.imgArr[indexPath.row],self.textArr[indexPath.row]];
    card.cellArr = self.cellArr[indexPath.row];
    [self.navigationController pushViewController:card animated:YES];
}

@end
