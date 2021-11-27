//
//  OneOnlineCell.m
//  JFB
//
//  Created by Shao Wei Su on 2017/7/31.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "OneOnlineCell.h"

@implementation OneOnlineCell


+ (instancetype)cellFromTableView:(UITableView *)tableview {
    static NSString *cellId = @"procell";
     OneOnlineCell *cell = [tableview dequeueReusableCellWithIdentifier:cellId];
     if (!cell) {
         cell = [[OneOnlineCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellId];
     }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 如果提供的图片不是正方形,用此代码调整
        //        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        // 文字颜色
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.textColor = [UIColor darkGrayColor];
        // 右箭头
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // 点击状态
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


// 重布局子控件
- (void)layoutSubviews {
    
    [super layoutSubviews];
    if (self.imageView.image == nil) return;// 如果没自定义图片,不调整
    // imageView
    self.imageView.qmui_top = 10;// 图片上边距
    self.imageView.qmui_height = self.contentView.qmui_height - 2 * 10;// 图片高
    self.imageView.qmui_width = self.imageView.qmui_height;// 宽高相等
    // label
    self.textLabel.qmui_left = self.imageView.qmui_right + 10;
    self.textLabel.qmui_top = 0;
    self.textLabel.qmui_height = self.contentView.qmui_height;
}

@end
