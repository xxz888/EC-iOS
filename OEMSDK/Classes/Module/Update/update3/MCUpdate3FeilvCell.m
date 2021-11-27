//
//  MCUpdate3FeilvCell.m
//  Pods
//
//  Created by wza on 2020/7/31.
//

#import "MCUpdate3FeilvCell.h"

@implementation MCUpdate3FeilvCell

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"MCUpdate3FeilvCell";
    MCUpdate3FeilvCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableview registerClass:[MCUpdate3FeilvCell class] forCellReuseIdentifier:cellID];
        cell = [[MCUpdate3FeilvCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupSubViews {
    self.feilvLab1 = [self creatLab];
    self.feilvLab2 = [self creatLab];
    UIStackView *stack = [[UIStackView alloc] init];
    [stack addArrangedSubview:self.feilvLab1];
    [stack addArrangedSubview:self.feilvLab2];
    stack.spacing = 10;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.distribution = UIStackViewDistributionFillEqually;
    [self.contentView addSubview:stack];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 15, 0, 15);
    
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(padding);
    }];
}

- (QMUIMarqueeLabel *)creatLab {
    QMUIMarqueeLabel *lab = [[QMUIMarqueeLabel alloc] init];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = [UIColor darkTextColor];
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

@end
