//
//  MCSettingCommonCell.m
//  MCOEM
//
//  Created by wza on 2020/4/15.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCSettingCell.h"



@interface MCSettingCell ()



@end

@implementation MCSettingCell

+ (instancetype)cellWithTableView:(UITableView *)tableview cellID:(NSString *)cellID {
    MCSettingCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MCSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"MCSettingCommonCell";
    MCSettingCell *cell = [self cellWithTableView:tableview cellID:cellID];
    [cell addSubview:cell.subTitleLab];
    [cell.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.equalTo(cell.mas_centerY);
    }];
    return cell;
}

+ (instancetype)voiceCellWithTableView:(UITableView *)tableview {
    
    static NSString *cellID = @"MCSettingVoiceCell";
    MCSettingCell *cell = [self cellWithTableView:tableview cellID:cellID];
    
    UISwitch *ss = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 51, 31)];
    [ss setOn:!SharedDefaults.not_voice_notify];
    ss.qmui_centerY = 25;
    ss.qmui_right = SCREEN_WIDTH-15;
    [ss addTarget:cell action:@selector(switchTouched:) forControlEvents:UIControlEventValueChanged];
    [cell addSubview:ss];
    
    return cell;
}

- (void)switchTouched:(UISwitch *)sender {
    SharedDefaults.not_voice_notify = !sender.isOn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.imgView];
        [self addSubview:self.titleLab];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@50);
            make.centerY.equalTo(self);
        }];
        
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] qmui_initWithSize:CGSizeMake(20, 20)];
        _imgView.qmui_left = 15;
        _imgView.qmui_centerY = 25;
    }
    return _imgView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] qmui_initWithFont:UIFontMake(16) textColor:UIColorBlack];
    }
    return _titleLab;
}

- (UILabel *)subTitleLab {
    if (!_subTitleLab) {
        _subTitleLab = [[UILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColorGray];
    }
    return _subTitleLab;
}
@end
