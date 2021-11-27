//
//  KDProvisionsTopView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/9.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDProvisionsTopView.h"

@interface KDProvisionsTopView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *desView;

@end

@implementation KDProvisionsTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDProvisionsTopView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)setModel:(KDChosePayTypeModel *)model
{
    _model = model;
    
    self.nameView.text = model.name;
    self.desView.text = model.des;
    self.iconView.image = model.icon;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
}
@end
