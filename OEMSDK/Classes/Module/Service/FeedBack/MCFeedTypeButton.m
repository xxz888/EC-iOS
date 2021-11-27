//
//  MCFeedTypeButton.m
//  Pods
//
//  Created by wza on 2020/8/19.
//

#import "MCFeedTypeButton.h"

@implementation MCFeedTypeButton

- (void)didInitialize {
    [super didInitialize];
    self.imagePosition = QMUIButtonImagePositionLeft;
    [self setImage:[UIImage mc_imageNamed:@"kf_check_no"] forState:UIControlStateNormal];
    [self setImage:[[UIImage mc_imageNamed:@"kf_check_yes"] imageWithColor:BCFI.color_main] forState:UIControlStateSelected];
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self setTitleColor:[UIColor qmui_colorWithHexString:@"#292C32"] forState:UIControlStateNormal];
    self.spacingBetweenImageAndTitle = 10;
}

@end
