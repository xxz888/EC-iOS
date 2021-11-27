//
//  KDCreditExtensionHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDCreditExtensionHeaderView.h"
#import "KDSearchView.h"

@interface KDCreditExtensionHeaderView ()<KDSearchViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@end

@implementation KDCreditExtensionHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    KDSearchView *searchV = [[KDSearchView alloc] initWithFrame:CGRectMake(0, 0, self.searchView.ly_width, self.searchView.ly_height)];
    searchV.delegate = self;
    [self.searchView addSubview:searchV];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDCreditExtensionHeaderView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 289);
}

- (IBAction)btnAction:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.lineView.centerX = sender.centerX;
    }];
    
    if (self.selectIndex) {
        self.selectIndex(sender.tag - 100);
    }
}

#pragma mark - KDSearchViewDelegate
- (void)inputTextFieldString:(NSString *)searchText
{
    if (self.searchCredit) {
        self.searchCredit(searchText);
    }
}
@end
