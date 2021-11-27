//
//  KDWXViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/14.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDWXViewCell.h"

@interface KDWXViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation KDWXViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 10;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"wx";
    KDWXViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDWXViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModel:(KDWXModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.groupName;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.qrcodeId]];
}
- (IBAction)saveImgAction:(id)sender {
    [MCShareStore saveToAlbum:self.imgView.image];
}
@end
