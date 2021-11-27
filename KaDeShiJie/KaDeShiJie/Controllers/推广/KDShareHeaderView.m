//
//  KDShareHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/8.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDShareHeaderView.h"
#import "KDWXViewController.h"
#import "KDGuanFangSheQun.h"

@interface KDShareHeaderView ()
@property (weak, nonatomic) IBOutlet UIStackView *centerView;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tuiguang1Imv;
@property (weak, nonatomic) IBOutlet UIImageView *tuiguang2Imv;
@property(nonatomic, strong) QMUIModalPresentationViewController * alertCroller;
@property(nonatomic, strong) KDGuanFangSheQun * kdGuanFangSheQun;

@end

@implementation KDShareHeaderView

- (KDGuanFangSheQun *)kdGuanFangSheQun {
    if (!_kdGuanFangSheQun) {
        _kdGuanFangSheQun = [[NSBundle mainBundle] loadNibNamed:@"KDGuanFangSheQun" owner:nil options:nil].lastObject;
        __weak typeof(self) weakSelf = self;
        _kdGuanFangSheQun.block = ^{
            [weakSelf.alertCroller hideWithAnimated:YES completion:nil];
        };
    }
    return _kdGuanFangSheQun;
}
- (QMUIModalPresentationViewController *)alertCroller {
    if (!_alertCroller) {
        _alertCroller = [[QMUIModalPresentationViewController alloc] init];
        _alertCroller.contentView = self.kdGuanFangSheQun;
        __weak __typeof(self)weakSelf = self;
        _alertCroller.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
            weakSelf.kdGuanFangSheQun.frame = CGRectMake((self.frame.size.width-266)/2, NavigationContentTop+50, 266, 253);
            [weakSelf.kdGuanFangSheQun setCenterY:weakSelf.centerY];
        };
    }
    return _alertCroller;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    for (QMUIButton *btn in self.centerView.subviews) {
        btn.imagePosition = QMUIButtonImagePositionTop;
    }
    self.tuiguang1Imv .userInteractionEnabled=YES;
    UITapGestureRecognizer *disPhoneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disPhoneClicktuiguang1Imv)];
    [self.tuiguang1Imv addGestureRecognizer:disPhoneTap];
    
    
    self.tuiguang2Imv .userInteractionEnabled=YES;
    UITapGestureRecognizer *disPhoneTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disPhoneClicktuiguang2Imv)];
    [self.tuiguang2Imv addGestureRecognizer:disPhoneTap1];
    

}
-(void)disPhoneClicktuiguang1Imv{
    [self.alertCroller showWithAnimated:YES completion:nil];

//    [self.viewController.navigationController pushViewController:[KDWXViewController new] animated:YES];
}
-(void)disPhoneClicktuiguang2Imv{
    [MCPagingStore pagingURL:rt_news_list withUerinfo:@{@"classification":@"推广物料"}];
}

-(UIViewController*)viewController{

    for(UIView*next =self.superview;next;next = next.superview){

        UIResponder*nextResponder = [next nextResponder];

        if([nextResponder isKindOfClass:[UIViewController class]]){

            return(UIViewController*)nextResponder;

        }

    }

    return nil;

}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"KDShareHeaderView" owner:nil options:nil];
        self = [views lastObject];
    }
    return self;
}


- (IBAction)topAction:(UIButton *)sender {
    NSString *title = sender.currentTitle;
    if ([title isEqualToString:@"分享素材"]) {
        [MCPagingStore pagingURL:rt_share_article];
    } else if ([title isEqualToString:@"推广二维码"]) {
        [MCPagingStore pagingURL:rt_share_single];
    } else if ([title isEqualToString:@"收益规则"]) {
        [MCPagingStore pushWebWithTitle:title classification:@"功能跳转"];
    }
}

- (void)setContent:(NSDictionary *)content
{
    _content = content;
    
    self.yearLabel.attributedText = [self getAttsWithString:content[@"anniversary"] firstString:@""];
    NSInteger person = [content[@"registerNumber"] intValue];
    NSString *personStr = nil;
    if (person < 10000) {
        personStr = [NSString stringWithFormat:@"%ld", (long)person];
    } else if (person < 100000000) {
        personStr = [NSString stringWithFormat:@"%.2f万", person / 10000.0];
    } else {
        personStr = [NSString stringWithFormat:@"%.2f亿", person / 100000000.0];
    }
    personStr = [personStr containsString:@".00"] ? [personStr replaceAll:@".00" target:@""] : personStr;
    self.personLabel.attributedText = [self getAttsWithString:personStr firstString:@""];
    NSInteger money = [content[@"tradingVolume"] intValue];
    NSString *moneyStr = nil;
    if (money < 10000) {
        moneyStr = [NSString stringWithFormat:@"%ld", (long)money];
    } else if (money < 100000000) {
        moneyStr = [NSString stringWithFormat:@"%.2f万", money / 10000.0];
    } else {
        moneyStr = [NSString stringWithFormat:@"%.2f亿", money / 100000000.0];
    }
    moneyStr = [moneyStr containsString:@".00"] ? [moneyStr replaceAll:@".00" target:@""] : moneyStr;
    self.moneyLabel.attributedText = [self getAttsWithString:moneyStr firstString:@""];
}

- (NSMutableAttributedString *)getAttsWithString:(NSString *)first firstString:(NSString *)last
{
    NSString *fullString = [NSString stringWithFormat:@"%@%@", first,last];
    NSMutableAttributedString *atts = [[NSMutableAttributedString alloc] initWithString:fullString];
    [atts addAttribute:NSForegroundColorAttributeName value:[UIColor mainColor] range:NSMakeRange(0, first.length)];
    return atts;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    

}
@end
