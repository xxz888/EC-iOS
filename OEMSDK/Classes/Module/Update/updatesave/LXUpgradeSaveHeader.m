//
//  LXUpgradeSaveHeader.m
//  Project
//
//  Created by Li Ping on 2019/7/22.
//  Copyright © 2019 LY. All rights reserved.
//

#import "LXUpgradeSaveHeader.h"
#import "UIColor+ColorChange.h"
#import "UIImage+GIF.h"
#import "MCGradientView.h"


@interface LXUpgradeSaveHeader ()

@property (nonatomic, copy) NSArray <MCProductModel *> * grades ;

@property (nonatomic, strong) UIColor *fColor;
@property (nonatomic, strong) UIColor *tColor;

@end


@implementation LXUpgradeSaveHeader

- (instancetype)initWithGrades:(NSArray <MCProductModel *> *)grades {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 197)];
    if (self) {
        self.grades = grades;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
   
    
    for (int i = 0; i<self.grades.count; i++) {
        MCProductModel *model = self.grades[i];
        //  勋章
        UIImageView *gradeImgV = [[UIImageView alloc] initWithImage:[UIImage mc_imageNamed:[NSString stringWithFormat:@"lx_grade_%d", model.grade.intValue]]];
        [self addSubview:gradeImgV];
        //  柱形
        MCGradientView *vv = [[MCGradientView alloc] init];
        vv.mainColor = MAINCOLOR;
        vv.startPoint = CGPointMake(0, 0);
        vv.endPoint = CGPointMake(0, 1);
        vv.startSaturation = 0.5;
        vv.endSaturation = 1.5;
        [vv reloadAppearance];
        vv.tag = 8000+i;
        [self addSubview:vv];
        
        
        
        //  底线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = vv.endColor;
        [self addSubview:line];
        //  等级名称
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.text = model.name;
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:10];
        nameLab.textColor = [UIColor colorWithHexString:@"#434343"];
        [self addSubview:nameLab];
        
        CGFloat lineW = (SCREEN_WIDTH - 26)/self.grades.count;  //  线宽
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(lineW));
            make.height.equalTo(@(2));
            make.bottom.equalTo(self).offset(-67);
            make.left.equalTo(self).offset(13+lineW*i);
        }];
        
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line).offset(8);
            make.centerX.equalTo(line);
        }];
        
        CGFloat vvH = 75;
        for (int j = i; j< self.grades.count - 1; j++) {
            vvH *= 0.6;
        }
        
        [vv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(23));
            make.bottom.equalTo(line);
            make.centerX.equalTo(line);
            make.height.equalTo(@(vvH));
        }];
        
        [gradeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(vv.mas_top).offset(-14);
            make.centerX.equalTo(vv);
            make.height.equalTo(@35);
            make.width.equalTo(@30);
        }];
        
    }
    
    
    MCLog(@"当前等级:%@",SharedUserInfo.grade);
    for (int i = 0; i<self.grades.count; i++) {
        MCProductModel *mm = self.grades[i];
        if ([mm.grade isEqualToString:SharedUserInfo.grade]) {
            //  当前手指
            UIImageView *fingerImgV = [[UIImageView alloc] init];
            NSURL *url = [[NSBundle OEMSDKBundle] URLForResource:@"za_upgrade_point" withExtension:@"gif"];
            fingerImgV.image = [UIImage sd_imageWithGIFData:[NSData dataWithContentsOfURL:url]];
            [self addSubview:fingerImgV];
            
            //  “当前等级”
            UILabel *cc = [[UILabel alloc] init];
            cc.text = @"当前等级";
            cc.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
            cc.textColor = [UIColor colorWithHexString:@"#434343"];
            [self addSubview:cc];
            
            UIView *vv = [self viewWithTag:8000+i];
            
            [fingerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(vv);
                make.top.equalTo(vv.mas_bottom).offset(28);
                make.width.height.equalTo(@(30*MCSCALE));
            }];
            
            if ((i == self.grades.count - 1) && (i != 0)) {
                [cc mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(fingerImgV);
                    make.right.equalTo(fingerImgV.mas_left).offset(-0);  //左侧
                }];
            } else {
                [cc mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(fingerImgV);
                    make.left.equalTo(fingerImgV.mas_right).offset(0);    //右侧
                }];
            }
            
            break;
            
        }
    }
    
    
    
}



@end
