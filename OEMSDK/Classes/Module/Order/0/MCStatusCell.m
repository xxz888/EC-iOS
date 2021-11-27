//
//  MCStatusCell.m
//  MCOEM
//
//  Created by wza on 2020/4/28.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCStatusCell.h"

@implementation MCStatusCell

+ (instancetype)cellForTableView:(QMUITableView *)tableView {
    static NSString *cellID = @"MCStatusCell";
    MCStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell  = [[MCStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:({
            QMUIButton *button = [QMUIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
            [button setTitleColor:UIColorBlack forState:UIControlStateNormal];
            [button setBackgroundImage:nil forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage qmui_imageWithColor:UIColorGrayLighten] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
            self.button = button;
            button;
        })];
        [self addSubview:({
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
            line.backgroundColor = [UIColor qmui_colorWithHexString:@"f6f5ec"];
            line;
        })];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)buttonTouched:(QMUIButton *)sender {
    sender.selected = !sender.isSelected;
    self.touchBlock(sender);
}
@end
