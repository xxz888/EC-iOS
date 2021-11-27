//
//  MCArticlesCell.m
//  MCOEM
//
//  Created by wza on 2020/5/12.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCArticlesCell.h"
#import "LYImageMagnification.h"
#import "MCArticleMoreOpration.h"

@interface MCArticlesCell ()

@property (weak, nonatomic) IBOutlet UILabel *dayLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgV1;
@property (weak, nonatomic) IBOutlet UIImageView *imgV2;
@property (weak, nonatomic) IBOutlet UIImageView *imgV3;
@property (weak, nonatomic) IBOutlet UIImageView *imgV4;
@property (weak, nonatomic) IBOutlet UIImageView *imgV5;
@property (weak, nonatomic) IBOutlet UIImageView *imgV6;
@property (weak, nonatomic) IBOutlet UIImageView *imgV7;
@property (weak, nonatomic) IBOutlet UIImageView *imgV8;
@property (weak, nonatomic) IBOutlet UIImageView *imgV9;

//@property (weak, nonatomic) IBOutlet QMUIButton *saveButton;
//@property (weak, nonatomic) IBOutlet QMUIButton *cpButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHW4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHW7;

@property(nonatomic, strong) MCArticleModel *model;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property(nonatomic, strong) MCArticleMoreOpration *moreOptationView;

@end

@implementation MCArticlesCell
- (MCArticleMoreOpration *)moreOptationView {
    if (!_moreOptationView) {
        _moreOptationView = [[MCArticleMoreOpration alloc] initWithFrame:CGRectMake(0, 0, 192, 40)];
        _moreOptationView.automaticallyHidesWhenUserTap = YES;
        _moreOptationView.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionLeft;
        _moreOptationView.sourceView  = self.moreBtn;
        __weak __typeof(self)weakSelf = self;
        _moreOptationView.selectedBlock = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf saveAction];
            } else {
                [weakSelf cpAction];
            }
        };
    }
    return _moreOptationView;
}
+ (instancetype)cellWithTableview:(UITableView *)tableview articleModel:(MCArticleModel *)model {
    static NSString *cellID = @"MCArticlesCell";
    MCArticlesCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:cellID];
        cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    }
    cell.model = model;
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.imgHW.constant = 104*MCSCALE;
 

    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
    UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
    UITapGestureRecognizer *tap8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
    UITapGestureRecognizer *tap9 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];

    [self.imgV1 addGestureRecognizer:tap1];
    [self.imgV2 addGestureRecognizer:tap2];
    [self.imgV3 addGestureRecognizer:tap3];
    [self.imgV4 addGestureRecognizer:tap4];
    [self.imgV5 addGestureRecognizer:tap5];
    [self.imgV6 addGestureRecognizer:tap6];
    [self.imgV7 addGestureRecognizer:tap7];
    [self.imgV8 addGestureRecognizer:tap8];
    [self.imgV9 addGestureRecognizer:tap9];

    self.imgV1.layer.cornerRadius = 5;
    self.imgV2.layer.cornerRadius = 5;
    self.imgV3.layer.cornerRadius = 5;
    self.imgV4.layer.cornerRadius = 5;
    self.imgV5.layer.cornerRadius = 5;
    self.imgV6.layer.cornerRadius = 5;
    self.imgV7.layer.cornerRadius = 5;
    self.imgV8.layer.cornerRadius = 5;
    self.imgV9.layer.cornerRadius = 5;

}
- (void)imgTap:(UITapGestureRecognizer *)tap {
    UIImageView *imgView = (UIImageView *)tap.view;
    if (imgView && imgView.image) {
        [LYImageMagnification scanBigImageWithImageView:imgView alpha:1];
    }
}
- (void)setModel:(MCArticleModel *)model {
    _model = model;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.create_time.longLongValue/1000];
    NSDateFormatter *f1 = [[NSDateFormatter alloc] init];
    f1.dateFormat = @"yyyy/MM/dd";
    self.dayLab.text = [f1 stringFromDate:date];
    
    NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
    f2.dateFormat = @"HH:mm";
    self.timeLab.text = [f2 stringFromDate:date];
    
    self.contentLab.text = model.content;
    
    if (model.img_url.count == 9) {
        self.imgHW.constant = 104*MCSCALE;
        self.imgV1.hidden = NO;
        self.imgV2.hidden = NO;
        self.imgV3.hidden = NO;
        self.imgV4.hidden = NO;
        self.imgV5.hidden = NO;
        self.imgV6.hidden = NO;
        self.imgV7.hidden = NO;
        self.imgV8.hidden = NO;
        self.imgV9.hidden = NO;

        
        [self.imgV1 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[0]] placeholderImage:SharedAppInfo.icon];
        [self.imgV2 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[1]] placeholderImage:SharedAppInfo.icon];
        [self.imgV3 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[2]] placeholderImage:SharedAppInfo.icon];
        [self.imgV4 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[3]] placeholderImage:SharedAppInfo.icon];
        [self.imgV5 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[4]] placeholderImage:SharedAppInfo.icon];
        [self.imgV6 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[5]] placeholderImage:SharedAppInfo.icon];
        [self.imgV7 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[6]] placeholderImage:SharedAppInfo.icon];
        [self.imgV8 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[7]] placeholderImage:SharedAppInfo.icon];
        [self.imgV9 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[8]] placeholderImage:SharedAppInfo.icon];

        self.imgV1.superview.hidden = NO;
        self.imgV4.superview.hidden = NO;
        self.imgV7.superview.hidden = NO;
        
    }else if (model.img_url.count == 8) {
        self.imgHW.constant = 104*MCSCALE;
        self.imgV1.hidden = NO;
        self.imgV2.hidden = NO;
        self.imgV3.hidden = NO;
        self.imgV4.hidden = NO;
        self.imgV5.hidden = NO;
        self.imgV6.hidden = NO;
        self.imgV7.hidden = NO;
        self.imgV8.hidden = NO;
        self.imgV9.hidden = NO;
        [self.imgV9 sd_setImageWithURL:@"" placeholderImage:nil];
        self.imgV9.userInteractionEnabled = NO;
        
        [self.imgV1 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[0]] placeholderImage:SharedAppInfo.icon];
        [self.imgV2 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[1]] placeholderImage:SharedAppInfo.icon];
        [self.imgV3 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[2]] placeholderImage:SharedAppInfo.icon];
        [self.imgV4 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[3]] placeholderImage:SharedAppInfo.icon];
        [self.imgV5 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[4]] placeholderImage:SharedAppInfo.icon];
        [self.imgV6 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[5]] placeholderImage:SharedAppInfo.icon];
        [self.imgV7 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[6]] placeholderImage:SharedAppInfo.icon];
        [self.imgV8 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[7]] placeholderImage:SharedAppInfo.icon];

        self.imgV1.superview.hidden = NO;
        self.imgV4.superview.hidden = NO;
        self.imgV7.superview.hidden = NO;
        
    }else if (model.img_url.count == 7) {
        self.imgHW.constant = 104*MCSCALE;
        self.imgV1.hidden = NO;
        self.imgV2.hidden = NO;
        self.imgV3.hidden = NO;
        self.imgV4.hidden = NO;
        self.imgV5.hidden = NO;
        self.imgV6.hidden = NO;
        self.imgV7.hidden = NO;
        self.imgV8.hidden = NO;
        [self.imgV8 sd_setImageWithURL:@"" placeholderImage:nil];
        self.imgV8.userInteractionEnabled = NO;
        self.imgV9.hidden = NO;
        [self.imgV9 sd_setImageWithURL:@"" placeholderImage:nil];
        self.imgV9.userInteractionEnabled = NO;
        
        [self.imgV1 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[0]] placeholderImage:SharedAppInfo.icon];
        [self.imgV2 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[1]] placeholderImage:SharedAppInfo.icon];
        [self.imgV3 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[2]] placeholderImage:SharedAppInfo.icon];
        [self.imgV4 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[3]] placeholderImage:SharedAppInfo.icon];
        [self.imgV5 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[4]] placeholderImage:SharedAppInfo.icon];
        [self.imgV6 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[5]] placeholderImage:SharedAppInfo.icon];
        [self.imgV7 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[6]] placeholderImage:SharedAppInfo.icon];

        self.imgV1.superview.hidden = NO;
        self.imgV4.superview.hidden = NO;
        self.imgV7.superview.hidden = NO;
        
    }else if (model.img_url.count == 6) {
        self.imgHW.constant = 104*MCSCALE;
        self.imgV1.hidden = NO;
        self.imgV2.hidden = NO;
        self.imgV3.hidden = NO;
        self.imgV4.hidden = NO;
        self.imgV5.hidden = NO;
        self.imgV6.hidden = NO;
      
        self.imgV7.hidden = YES;
        self.imgV8.hidden = YES;
        self.imgV9.hidden = YES;

        
        [self.imgV1 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[0]] placeholderImage:SharedAppInfo.icon];
        [self.imgV2 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[1]] placeholderImage:SharedAppInfo.icon];
        [self.imgV3 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[2]] placeholderImage:SharedAppInfo.icon];
        [self.imgV4 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[3]] placeholderImage:SharedAppInfo.icon];
        [self.imgV5 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[4]] placeholderImage:SharedAppInfo.icon];
        [self.imgV6 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[5]] placeholderImage:SharedAppInfo.icon];

        self.imgV1.superview.hidden = NO;
        self.imgV4.superview.hidden = NO;
        self.imgV7.superview.hidden = YES;
        
    }else if (model.img_url.count == 5) {
        self.imgHW.constant = 104*MCSCALE;
        self.imgV1.hidden = NO;
        self.imgV2.hidden = NO;
        self.imgV3.hidden = NO;
        self.imgV4.hidden = NO;
        self.imgV5.hidden = NO;
        
        self.imgV6.hidden = NO;
        [self.imgV6 sd_setImageWithURL:@"" placeholderImage:nil];
        self.imgV6.userInteractionEnabled = NO;
        self.imgV7.hidden = YES;
        self.imgV8.hidden = YES;
        self.imgV9.hidden = YES;

        
        [self.imgV1 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[0]] placeholderImage:SharedAppInfo.icon];
        [self.imgV2 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[1]] placeholderImage:SharedAppInfo.icon];
        [self.imgV3 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[2]] placeholderImage:SharedAppInfo.icon];
        [self.imgV4 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[3]] placeholderImage:SharedAppInfo.icon];
        [self.imgV5 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[4]] placeholderImage:SharedAppInfo.icon];
        
        self.imgV1.superview.hidden = NO;
        self.imgV4.superview.hidden = NO;
        self.imgV7.superview.hidden = YES;
        
    }else if (model.img_url.count == 4) {
        self.imgHW.constant = 104*MCSCALE;
        self.imgV1.hidden = NO;
        self.imgV2.hidden = NO;
        self.imgV3.hidden = YES;
        self.imgV4.hidden = NO;
        self.imgV5.hidden = NO;
        
        self.imgV6.hidden = YES;
        self.imgV7.hidden = YES;
        self.imgV8.hidden = YES;
        self.imgV9.hidden = YES;

        
        [self.imgV1 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[0]] placeholderImage:SharedAppInfo.icon];
        [self.imgV2 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[1]] placeholderImage:SharedAppInfo.icon];
        [self.imgV4 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[2]] placeholderImage:SharedAppInfo.icon];
        [self.imgV5 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[3]] placeholderImage:SharedAppInfo.icon];
        
        self.imgV1.superview.hidden = NO;
        self.imgV4.superview.hidden = NO;
        self.imgV7.superview.hidden = YES;
        
    } else if (model.img_url.count == 3) {
        self.imgHW.constant = 104*MCSCALE;
        self.imgV1.hidden = NO;
        self.imgV2.hidden = NO;
        self.imgV3.hidden = NO;
        self.imgV4.hidden = YES;
        
        self.imgV5.hidden = YES;
        self.imgV6.hidden = YES;
        self.imgV7.hidden = YES;
        self.imgV8.hidden = YES;
        self.imgV9.hidden = YES;
        
        [self.imgV1 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[0]] placeholderImage:SharedAppInfo.icon];
        [self.imgV2 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[1]] placeholderImage:SharedAppInfo.icon];
        [self.imgV3 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[2]] placeholderImage:SharedAppInfo.icon];
        
        self.imgV1.superview.hidden = NO;
        self.imgV4.superview.hidden = YES;
        self.imgV7.superview.hidden = YES;

    } else if (model.img_url.count == 2) {
        self.imgHW.constant = 104*MCSCALE;
        
        self.imgV1.hidden = NO;
        self.imgV2.hidden = NO;
        self.imgV3.hidden = YES;
        self.imgV4.hidden = YES;
        self.imgV5.hidden = YES;
        self.imgV6.hidden = YES;
        self.imgV7.hidden = YES;
        self.imgV8.hidden = YES;
        self.imgV9.hidden = YES;
        
        [self.imgV1 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[0]] placeholderImage:SharedAppInfo.icon];
        [self.imgV2 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[1]] placeholderImage:SharedAppInfo.icon];
        
        self.imgV1.superview.hidden = NO;
        self.imgV4.superview.hidden = YES;
        self.imgV7.superview.hidden = YES;

    } else if (model.img_url.count == 1) {
        self.imgHW.constant = 104 * MCSCALE;//213*MCSCALE;
        self.imgV1.hidden = NO;
        
        self.imgV2.hidden = YES;
        self.imgV3.hidden = YES;
        self.imgV4.hidden = YES;
        self.imgV5.hidden = YES;
        self.imgV6.hidden = YES;
        self.imgV7.hidden = YES;
        self.imgV8.hidden = YES;
        self.imgV9.hidden = YES;
        
        [self.imgV1 sd_setImageWithURL:[self commonChangeImgUrlAction:model.img_url[0]] placeholderImage:SharedAppInfo.icon];
        
        self.imgV1.superview.hidden = NO;
        self.imgV4.superview.hidden = YES;
        self.imgV7.superview.hidden = YES;

    } else {
        self.imgV1.hidden = YES;
        self.imgV2.hidden = YES;
        self.imgV3.hidden = YES;
        self.imgV4.hidden = YES;
        
        self.imgV5.hidden = YES;
        self.imgV6.hidden = YES;
        self.imgV7.hidden = YES;
        self.imgV8.hidden = YES;
        self.imgV9.hidden = YES;
        
        self.imgV1.superview.hidden = YES;
        self.imgV3.superview.hidden = YES;
        self.imgV7.superview.hidden = YES;

    }
    
}
-(NSURL *)commonChangeImgUrlAction:(NSString *)imgUrl{
    if ([imgUrl containsString:@"?"]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@&token=%@",imgUrl,TOKEN]];
    }
    return [NSURL URLWithString:imgUrl];
}
- (void)saveAction {
    if (self.model.img_url.count == 9) {
        [MCShareStore saveToAlbum:self.imgV1.image];
        [MCShareStore saveToAlbum:self.imgV2.image];
        [MCShareStore saveToAlbum:self.imgV3.image];
        [MCShareStore saveToAlbum:self.imgV4.image];
        [MCShareStore saveToAlbum:self.imgV5.image];
        [MCShareStore saveToAlbum:self.imgV6.image];
        [MCShareStore saveToAlbum:self.imgV7.image];
        [MCShareStore saveToAlbum:self.imgV8.image];
        [MCShareStore saveToAlbum:self.imgV9.image];
    }else if (self.model.img_url.count == 8) {
        [MCShareStore saveToAlbum:self.imgV1.image];
        [MCShareStore saveToAlbum:self.imgV2.image];
        [MCShareStore saveToAlbum:self.imgV3.image];
        [MCShareStore saveToAlbum:self.imgV4.image];
        [MCShareStore saveToAlbum:self.imgV5.image];
        [MCShareStore saveToAlbum:self.imgV6.image];
        [MCShareStore saveToAlbum:self.imgV7.image];
        [MCShareStore saveToAlbum:self.imgV8.image];
    }else if (self.model.img_url.count == 7) {
        [MCShareStore saveToAlbum:self.imgV1.image];
        [MCShareStore saveToAlbum:self.imgV2.image];
        [MCShareStore saveToAlbum:self.imgV3.image];
        [MCShareStore saveToAlbum:self.imgV4.image];
        [MCShareStore saveToAlbum:self.imgV5.image];
        [MCShareStore saveToAlbum:self.imgV6.image];
        [MCShareStore saveToAlbum:self.imgV7.image];
    }else if (self.model.img_url.count == 6) {
        [MCShareStore saveToAlbum:self.imgV1.image];
        [MCShareStore saveToAlbum:self.imgV2.image];
        [MCShareStore saveToAlbum:self.imgV3.image];
        [MCShareStore saveToAlbum:self.imgV4.image];
        [MCShareStore saveToAlbum:self.imgV5.image];
        [MCShareStore saveToAlbum:self.imgV6.image];
    }else if (self.model.img_url.count == 5) {
        [MCShareStore saveToAlbum:self.imgV1.image];
        [MCShareStore saveToAlbum:self.imgV2.image];
        [MCShareStore saveToAlbum:self.imgV3.image];
        [MCShareStore saveToAlbum:self.imgV4.image];
        [MCShareStore saveToAlbum:self.imgV5.image];
    }else if (self.model.img_url.count == 4) {
        [MCShareStore saveToAlbum:self.imgV1.image];
        [MCShareStore saveToAlbum:self.imgV2.image];
        [MCShareStore saveToAlbum:self.imgV4.image];
        [MCShareStore saveToAlbum:self.imgV5.image];
    }else if (self.model.img_url.count == 3) {
        [MCShareStore saveToAlbum:self.imgV1.image];
        [MCShareStore saveToAlbum:self.imgV2.image];
        [MCShareStore saveToAlbum:self.imgV3.image];
    } else if (self.model.img_url.count == 2) {
        [MCShareStore saveToAlbum:self.imgV1.image];
        [MCShareStore saveToAlbum:self.imgV2.image];
    } else if (self.model.img_url.count == 1) {
        [MCShareStore saveToAlbum:self.imgV1.image];
    } else {
        [MCToast showMessage:@"暂无可保存图片"];
    }
}
- (void)cpAction {
    if (self.model.content && self.model.content.length > 0) {
        UIPasteboard.generalPasteboard.string = self.model.content;
        [MCToast showMessage:@"文案已复制到剪切板"];
    }
}
- (IBAction)moreBtnTouched:(UIButton *)sender {
    [self.moreOptationView showWithAnimated:YES];
}

@end
