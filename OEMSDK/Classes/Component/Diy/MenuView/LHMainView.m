//
//  LHMainView.m
//  Project
//
//  Created by SS001 on 2020/3/19.
//  Copyright © 2020 LY. All rights reserved.
//

#import "LHMainView.h"
#import "MCDataProfessor.h"

@interface LHMainView ()
@property (nonatomic, assign) CGRect myFrame;
@end

@implementation LHMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.myFrame = frame;
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgView.image = [UIImage mc_imageNamed:@"lx_home_top_banner"];
        [self addSubview:bgView];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    CGFloat viewW = self.myFrame.size.width / dataArray.count;
    CGFloat viewH = self.frame.size.height;
    CGFloat viewX = 0;
    CGFloat viewY = 0;
    for (int i = 0; i < dataArray.count; i++) {
        NSInteger columnn = [[NSString stringWithFormat:@"%@",dataArray[i][@"columnn"]] integerValue]-1;
        viewX = viewW * columnn;
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentView];
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((viewW - 50) * 0.5, (viewH - 50 - 30) * 0.5, 50, 50)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:dataArray[i][@"icon"]]];
        [contentView addSubview:imgView];
        
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.qmui_bottom, viewW, 30)];
        titleView.text = dataArray[i][@"title"];
        titleView.textColor = [UIColor whiteColor];
        titleView.font = LYFont(21);
        titleView.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:titleView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(viewW - 1, imgView.ly_y, 1, titleView.qmui_bottom - imgView.ly_y)];
        lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        [contentView addSubview:lineView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, viewW, viewH);
        btn.tag = i;
        [btn addTarget:self action:@selector(clickMainBtn:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
    }
}

- (void)clickMainBtn:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSeletedMainViewWithTag:)]) {
        [self.delegate didSeletedMainViewWithTag:sender.tag];
    }
}
@end
