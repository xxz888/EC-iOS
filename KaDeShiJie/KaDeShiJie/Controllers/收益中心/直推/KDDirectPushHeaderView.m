//
//  KDDirectPushHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDDirectPushHeaderView.h"
#import "KDDirectPushChoseStatusView.h"

@interface KDDirectPushHeaderView ()
@property (weak, nonatomic) IBOutlet QMUIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *textView;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) QMUIPopupMenuView *menuView;
@end

@implementation KDDirectPushHeaderView

- (QMUIPopupMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[QMUIPopupMenuView alloc] init];
        _menuView.sourceRect = CGRectMake(SCREEN_WIDTH - 115, 0, 150, NavigationContentTop+45);
        _menuView.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
        _menuView.maskViewBackgroundColor = UIColorMaskWhite;// 使用方法 2 并且打开了 automaticallyHidesWhenUserTap 的情况下，可以修改背景遮罩的颜色
        _menuView.shouldShowItemSeparator = YES;
        __weak __typeof(self)weakSelf = self;
        _menuView.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {
            // 利用 itemConfigurationHandler 批量设置所有 item 的样式
            aItem.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            aItem.highlightedBackgroundColor = [UIColor mainColor];
            [aItem.button setTitleColor:UIColorBlack forState:UIControlStateNormal];
        };
        
        QMUIPopupMenuButtonItem *item1 = [QMUIPopupMenuButtonItem itemWithImage:nil title:@"  全部" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
            self.status = @"  全部";
            [self.statusBtn setTitle:@"全部" forState:UIControlStateNormal];
            if ([self.delegate respondsToSelector:@selector(directPushHeaderViewChoseStatus:)]) {
                [self.delegate directPushHeaderViewChoseStatus:@"0"];
            }
            [aItem.menuView hideWithAnimated:YES];
        }];
        
        QMUIPopupMenuButtonItem *item2 = [QMUIPopupMenuButtonItem itemWithImage:nil title:@"已注册" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
            
            self.status = @"已注册";
            [self.statusBtn setTitle:self.status forState:UIControlStateNormal];
            if ([self.delegate respondsToSelector:@selector(directPushHeaderViewChoseStatus:)]) {
                [self.delegate directPushHeaderViewChoseStatus:@"1"];
            }
            [aItem.menuView hideWithAnimated:YES];
        }];
        
        QMUIPopupMenuButtonItem *item3 = [QMUIPopupMenuButtonItem itemWithImage:nil title:@"已实名" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
            
            self.status = @"已实名";
            [self.statusBtn setTitle:self.status forState:UIControlStateNormal];
            if ([self.delegate respondsToSelector:@selector(directPushHeaderViewChoseStatus:)]) {
                [self.delegate directPushHeaderViewChoseStatus:@"2"];
            }
            [aItem.menuView hideWithAnimated:YES];
        }];
        
        QMUIPopupMenuButtonItem *item4 = [QMUIPopupMenuButtonItem itemWithImage:nil title:@"已认证" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
            
            self.status = @"已认证";
            [self.statusBtn setTitle:self.status forState:UIControlStateNormal];
            if ([self.delegate respondsToSelector:@selector(directPushHeaderViewChoseStatus:)]) {
                [self.delegate directPushHeaderViewChoseStatus:@"4"];
            }
            [aItem.menuView hideWithAnimated:YES];
        }];
        
        QMUIPopupMenuButtonItem *item5 = [QMUIPopupMenuButtonItem itemWithImage:nil title:@"已激活" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
            self.status = @"已激活";
            [self.statusBtn setTitle:self.status forState:UIControlStateNormal];
            if ([self.delegate respondsToSelector:@selector(directPushHeaderViewChoseStatus:)]) {
                [self.delegate directPushHeaderViewChoseStatus:@"3"];
            }
            [aItem.menuView hideWithAnimated:YES];
        }];
        
//        QMUIPopupMenuButtonItem *item5 = [QMUIPopupMenuButtonItem itemWithImage:nil title:@"未实名" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
//
//            self.status = @"未实名";
//            [self.statusBtn setTitle:self.status forState:UIControlStateNormal];
//            if ([self.delegate respondsToSelector:@selector(directPushHeaderViewChoseStatus:)]) {
//                [self.delegate directPushHeaderViewChoseStatus:@"4"];
//            }
//            [aItem.menuView hideWithAnimated:YES];
//        }];
        
        _menuView.items = @[item1, item2, item3, item4, item5];
    }
    return _menuView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.statusBtn.imagePosition = QMUIButtonImagePositionRight;
    self.bgView.layer.cornerRadius = 10;
    self.status = @"  全部";
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDDirectPushHeaderView" owner:nil options:nil] lastObject];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

- (IBAction)clickStatusBtn:(id)sender {
    __weak typeof(self) weakSelf = self;
    self.menuView.itemConfigurationHandler = ^(QMUIPopupMenuView * _Nonnull aMenuView, __kindof QMUIPopupMenuButtonItem * _Nonnull aItem, NSInteger section, NSInteger index) {
        if ([aItem.title isEqualToString:weakSelf.status]) {
            aItem.backgroundColor = [UIColor mainColor];
            [aItem.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            aItem.backgroundColor = [UIColor whiteColor];
            [aItem.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    };
    [self.menuView showWithAnimated:YES];
}

- (IBAction)searchTextAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(directPushHeaderViewSearchText:)]) {
        [self.delegate directPushHeaderViewSearchText:self.textView.text];
    }
}
@end
