//
//  MCAccreditation1ViewController.m
//  AFNetworking
//
//  Created by apple on 2020/10/30.
//

#import "MCAccreditation1ViewController.h"
#import "MCProtocolViewController.h"
#import "UILabel+Extension.h"
@interface MCAccreditation1ViewController ()

@end

@implementation MCAccreditation1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    [self setNavigationBarTitle:@"授权" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    UIImage *hlImg = [[UIImage mc_imageNamed:@"card_yes"] imageWithColor: UIColor.mainColor];
    [self.selectBtn setImage:hlImg forState:UIControlStateSelected];
    [self.selectBtn setImage:[UIImage mc_imageNamed:@"card_no"] forState:UIControlStateNormal];

    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.userXieYiLbl.text];
    NSRange range1 = [[str string] rangeOfString:@"《用户信息授权协议》"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor mainColor] range:range1];
    self.userXieYiLbl.attributedText = str;
    
    //创建手势 使用initWithTarget:action:的方法创建
    self.userXieYiLbl.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickUserXieYiLbl:)];
    //别忘了添加到testView上
    [self.userXieYiLbl addGestureRecognizer:tap];
    
    self.agreeBtn.selected = NO;
}
-(void)clickUserXieYiLbl:(id)sender{
    MCProtocolViewController * vc = [MCProtocolViewController new];
    vc.whereCome = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark ---------选择勾选的按钮---------
- (IBAction)selectAction:(id)sender {
    [self.selectBtn setSelected:!self.selectBtn.selected];
    [self.agreeBtn setBackgroundImage:self.selectBtn.selected ?
    [UIImage mc_imageNamed:@"KD_BindCardBtn"] : [UIImage mc_imageNamed:@""] forState:UIControlStateNormal];
    self.agreeBtn.userInteractionEnabled = self.selectBtn.selected;
}
#pragma mark ---------同意到下一步的按钮---------
- (IBAction)agreeAction:(id)sender {
    [MCPagingStore pagingURL:rt_card_vc2];
}
@end
