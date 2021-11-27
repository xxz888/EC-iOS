//
//  CommonRealnameVC.m
//  Project
//
//  Created by 熊凤伟 on 2018/3/22.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "MCManualRealNameController.h"
#import "LYImageMagnification.h"// 查看图片大图

#define kViewColor [UIColor colorWithRed:210/255.0 green:210/255.0 blue:220/255.0 alpha:1.0]

static const CGFloat margin = 10;

@interface MCManualRealNameController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate>

/** 姓名输入框 */
@property (nonatomic, weak) UITextField *nameTF;
/** 身份证号输入框 */
@property (nonatomic, weak) UITextField *idCardTF;

/** 正面拍摄按钮 */
@property (nonatomic, weak) UIButton *frontPhotoButton;
/** 反面拍摄按钮 */
@property (nonatomic, weak) UIButton *backPhotoButton;
/** 人物照拍摄按钮 */
@property (nonatomic, weak) UIButton *personPhotoButton;

/** imageOne */
@property (nonatomic, strong) UIImage *imageOne;
/** imageTwo */
@property (nonatomic, strong) UIImage *imageTwo;
/** imageThree */
@property (nonatomic, strong) UIImage *imageThree;

/** index(0-正面拍摄按钮 1-反面拍摄按钮 2-人物拍摄按钮) */
@property (nonatomic, assign) NSInteger index;

@end

@implementation MCManualRealNameController

#pragma mark --- LIFE
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 主界面
    [self setupMainView];
}
#pragma mark --- SET UP VIEW
//------ 主界面 ------//
- (void)setupMainView {
    
    // 0. 初始值
    
    [self setNavigationBarTitle:@"实名认证" tintColor:MAINCOLOR];
    self.imageOne = nil;
    self.imageTwo = nil;
    self.imageThree = nil;
    
    // 容器
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop)];
    scrollView.directionalLockEnabled = YES;// 单一方向滚动
    scrollView.pagingEnabled = NO;// 翻页
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    [self.view addSubview:scrollView];
    
    // 1. 用户名/身份证
    // 用户名
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(margin, margin, scrollView.width - margin * 2, 40)];
    nameView.layer.cornerRadius = 6;
    nameView.layer.masksToBounds = YES;
    nameView.layer.borderColor = kViewColor.CGColor;
    nameView.layer.borderWidth = 1;
    [scrollView addSubview:nameView];
    
    UILabel *nameTitleLabel = [self labelWithFrame:CGRectMake(0, 0, 80, nameView.height) text:@"用户名" textColor:[UIColor darkGrayColor] textAlignment:(NSTextAlignmentCenter) font:[UIFont systemFontOfSize:14]];
    
    [nameView addSubview:nameTitleLabel];
    UIView *nameLineView = [[UIView alloc] initWithFrame:CGRectMake(nameTitleLabel.right, 5, 1, nameView.height - 10)];
    nameLineView.backgroundColor = kViewColor;
    [nameView addSubview:nameLineView];
    UITextField *nameTF = [[UITextField alloc] initWithFrame:CGRectMake(nameLineView.right + 5, 0, nameView.width - nameLineView.right - 5 - margin, nameView.height)];
    nameTF.textColor = [UIColor lightGrayColor];
    nameTF.textAlignment = NSTextAlignmentLeft;
    nameTF.font = [UIFont systemFontOfSize:12];
    nameTF.tintColor = [UIColor lightGrayColor];
    nameTF.placeholder = @"请输入真实姓名";
    nameTF.keyboardType = UIKeyboardTypeDefault;
    nameTF.delegate = self;
    [nameView addSubview:nameTF];
    self.nameTF = nameTF;
    //身份证号
    UIView *cardNoView = [[UIView alloc] initWithFrame:CGRectMake(nameView.left, nameView.bottom + margin, nameView.width, nameView.height)];
    cardNoView.layer.cornerRadius = 6;
    cardNoView.layer.masksToBounds = YES;
    cardNoView.layer.borderColor = kViewColor.CGColor;
    cardNoView.layer.borderWidth = 1;
    [scrollView addSubview:cardNoView];
    UILabel *cardNoTitleLabel = [self labelWithFrame:CGRectMake(0, 0, 80, nameView.height) text:@"身份证" textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:14]];
    [cardNoView addSubview:cardNoTitleLabel];
    UIView *cardNoLineView = [[UIView alloc] initWithFrame:CGRectMake(cardNoTitleLabel.right, 5, 1, cardNoView.height - 10)];
    cardNoLineView.backgroundColor = kViewColor;
    [cardNoView addSubview:cardNoLineView];
    UITextField *idCardTF = [[UITextField alloc] initWithFrame:CGRectMake(cardNoLineView.right + 5, 0, cardNoView.width - cardNoLineView.height - 5 - margin, cardNoView.height)];
    idCardTF.textColor = [UIColor lightGrayColor];
    idCardTF.textAlignment = NSTextAlignmentLeft;
    idCardTF.font = [UIFont systemFontOfSize:12];
    idCardTF.tintColor = [UIColor lightGrayColor];
    idCardTF.placeholder = @"请输入身份证号";
    idCardTF.keyboardType = UIKeyboardTypeDefault;
    idCardTF.delegate = self;
    [cardNoView addSubview:idCardTF];
    self.idCardTF = idCardTF;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cardNoView.bottom + margin, scrollView.width, 10)];
    lineView.backgroundColor = kViewColor;
    [scrollView addSubview:lineView];
    
    // 2. 拍摄区
    // 头部文字
    NSString *headerMessage = @"请拍摄如下照片用于认证，可点击放大查看示例\n（上传图片占用较大流量，建议使用WiFi）";
    UILabel *headerMessageLabel = [self labelWithFrame:CGRectMake(margin, lineView.bottom, scrollView.width - margin * 2, 60) text:headerMessage textColor:[UIColor lightGrayColor] textAlignment:(NSTextAlignmentCenter) font:[UIFont systemFontOfSize:12]];
    headerMessageLabel.numberOfLines = 0;
    [scrollView addSubview:headerMessageLabel];
    // 示例图片
    CGFloat showImageMargin = 10;
    CGFloat showImageW = (SCREEN_WIDTH - showImageMargin * 4) / 3;
    CGFloat showImageH = showImageW - 20;
    NSArray *showImageArr = @[@"common_shiming_01_new", @"common_shiming_02_new", @"common_shiming_03_new"];
    for (int i = 0; i < showImageArr.count; i++) {
        UIButton *tempButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        tempButton.frame = CGRectMake(showImageMargin + (showImageW + showImageMargin) * i, headerMessageLabel.bottom, showImageW, showImageH);
        [tempButton setImage:[UIImage mc_imageNamed:showImageArr[i]] forState:(UIControlStateNormal)];
        [tempButton addTarget:self action:@selector(showImageButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [scrollView addSubview:tempButton];
    }
    // 箭头
    UIImageView *downArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake((scrollView.width - 20) / 2, headerMessageLabel.bottom + showImageH + 5, 20, 25)];
    downArrowImageView.image = [UIImage mc_imageNamed:@"common_shiming_down"];
    [scrollView addSubview:downArrowImageView];
    // 拍摄按钮
    CGFloat buttonMargin = 10;
    CGFloat buttonW = (SCREEN_WIDTH - buttonMargin * 4) / 3;
    CGFloat buttonH = buttonW;
    UIButton *frontPhotoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    frontPhotoButton.frame = CGRectMake(buttonMargin, downArrowImageView.bottom + 5, buttonW, buttonH);
    frontPhotoButton.tag = 0;
    [frontPhotoButton setImage:[UIImage mc_imageNamed:@"common_realname_add_01"] forState:(UIControlStateNormal)];
    [frontPhotoButton addTarget:self action:@selector(photoButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [scrollView addSubview:frontPhotoButton];
    self.frontPhotoButton = frontPhotoButton;
    UIButton *backPhotoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backPhotoButton.frame = CGRectMake(frontPhotoButton.right + buttonMargin, frontPhotoButton.top, frontPhotoButton.width, frontPhotoButton.height);
    backPhotoButton.tag = 1;
    [backPhotoButton setImage:[UIImage mc_imageNamed:@"common_realname_add_02"] forState:(UIControlStateNormal)];
    [backPhotoButton addTarget:self action:@selector(photoButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [scrollView addSubview:backPhotoButton];
    self.backPhotoButton = backPhotoButton;
    UIButton *personPhotoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    personPhotoButton.frame = CGRectMake(backPhotoButton.right + buttonMargin, backPhotoButton.top, backPhotoButton.width, backPhotoButton.height);
    personPhotoButton.tag = 2;
    [personPhotoButton setImage:[UIImage mc_imageNamed:@"common_realname_add_03"] forState:(UIControlStateNormal)];
    [personPhotoButton addTarget:self action:@selector(photoButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [scrollView addSubview:personPhotoButton];
    self.personPhotoButton = personPhotoButton;
    
    // 3. 底部说明文字
    NSString *bottomMessage = @"•请保证您的年龄符合18-80周岁\n•必须上传身份证的正反面\n•手持证件照片需拍到持有人五官，请勿佩戴眼镜、帽子等遮罩物\n•未达到示例标准、照片不清晰、经过编辑处理等非正常拍摄都不予通过";
    CGFloat bottomMessageH = [self stringHeightWithString:bottomMessage width:scrollView.width - margin * 2 font:[UIFont systemFontOfSize:12]];
    UILabel *bottomMessageLabel = [self labelWithFrame:CGRectMake(margin, personPhotoButton.bottom + margin, scrollView.width - margin * 2, bottomMessageH) text:bottomMessage textColor:MAINCOLOR textAlignment:(NSTextAlignmentLeft) font:[UIFont systemFontOfSize:12]];
    bottomMessageLabel.numberOfLines = 0;
    [scrollView addSubview:bottomMessageLabel];
    
    // 4. 提交按钮
    UIButton *submitButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    submitButton.frame = CGRectMake(margin, bottomMessageLabel.bottom + 20, scrollView.width - margin * 2, 40);
    submitButton.backgroundColor = MAINCOLOR;
    submitButton.layer.cornerRadius = 6;
    submitButton.layer.masksToBounds = YES;
    submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [submitButton setTitle:@"提交" forState:(UIControlStateNormal)];
    [submitButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [scrollView addSubview:submitButton];
    
    // 修改容器高度
    //scrollView.contentSize = CGSizeMake(ScreenWidth, submitButton.LY_bottom + margin);
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,CGRectGetMaxY(submitButton.frame)+NavigationContentTop + margin);
}

- (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)alignment font:(UIFont *)font {
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.text = text;
    lab.textColor = textColor;
    lab.textAlignment = alignment;
    lab.font = font;
    return lab;
}

- (CGFloat)stringHeightWithString:(NSString *)string width:(CGFloat)width font:(UIFont *)font {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.height;
}

//textField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField isExclusiveTouch]) {
        [textField resignFirstResponder];
    }
    return YES;
}





#pragma mark --- TARGET METHOD
/// 1. 示例图片按钮点击事件
- (void)showImageButtonClick:(UIButton *)sender {
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 0, 0)];
    tempImageView.image = sender.imageView.image;
    [LYImageMagnification scanBigImageWithImageView:tempImageView alpha:.6];
}
/// 2. 拍摄按钮点击事件
- (void)photoButtonClick:(UIButton *)sender {
    
    self.index = sender.tag;
    
    // 拍照
    [self getImageFromIpc];
}
/// 3. 提交按钮点击事件
- (void)submitButtonClick
{
    //百度人脸
//    [self baiduFace];
//    return;
    
    
    
    // 判断
    if (self.nameTF.text.length == 0 || self.idCardTF.text.length == 0) {
        return;
    }
    if (self.imageOne == nil || self.imageTwo == nil || self.imageThree == nil) {
        [self showAlertWithMessage:@"请上传图片！"];
        return;
    }
    
    // 请求提交
    [self requestDataForCheckInputInfo];
}
#pragma mark --- DELEGATE


#pragma mark --- PRIVATE METHOD
#pragma mark --- 调用系统相册的方法
- (void)getImageFromIpc {
    
    // 1. 判断是否可以打开相册
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        return;
    }
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    // 3. 设置打开照片相册类型(显示所有相薄)
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 4. 设置代理
    ipc.delegate = self;
    // 5. modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}
#pragma mark --- UIImagePickerControllerDelegate代理方法
// 1. 选择图片时调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 设置图片
    if (self.index == 0) {
        self.imageOne = info[UIImagePickerControllerOriginalImage];
        [self.frontPhotoButton setImage:info[UIImagePickerControllerOriginalImage] forState:(UIControlStateNormal)];
    }
    if (self.index == 1) {
        self.imageTwo = info[UIImagePickerControllerOriginalImage];
        [self.backPhotoButton setImage:info[UIImagePickerControllerOriginalImage] forState:(UIControlStateNormal)];
    }
    if (self.index == 2) {
        self.imageThree = info[UIImagePickerControllerOriginalImage];
        [self.personPhotoButton setImage:info[UIImagePickerControllerOriginalImage] forState:(UIControlStateNormal)];
    }
}
// 2. 取消选择时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- SET DATA
//------ 传入姓名身份证号数据请求(用来判定是否可以上传图片) ------//
- (void)requestDataForCheckInputInfo {
    
    NSString *tempCard = [self.idCardTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    /* token  realname:真实姓名  idcard:身份证号  */
    NSDictionary *param = @{@"realname":self.nameTF.text, @"idcard":tempCard};
    __weak __typeof(self)weakSelf = self;
    [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/paymentchannel/app/realname/auth/%@",TOKEN] parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        if (resp.result && [resp.result intValue] == 1) {   //可以上传图片
            [weakSelf requestDataForUploadImages];
        } else {
            [MCToast showMessage:resp.messege];
        }
    }];
    
}
//------ 上传图片 ------//
- (void)requestDataForUploadImages {
    NSString *phone = SharedUserInfo.phone;
    NSDictionary *uploadDic = @{@"phone":phone, @"brandId":SharedConfig.brand_id};
    NSArray *imagesArr = @[self.imageOne, self.imageTwo, self.imageThree];
    __weak __typeof(self)weakSelf = self;
    [MCSessionManager.shareManager mc_UPLOAD:@"" parameters:uploadDic images:imagesArr remoteFields:nil imageNames:nil imageScale:0.0001 imageType:nil ok:^(MCNetResponse * _Nonnull resp) {
        [MCToast showMessage:@"提交成功，请耐心等待审核通过"];
//        [weakSelf.navigationController popViewControllerAnimated:YES];
        [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_user_realname];
    } other:nil failure:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)baiduFace {
    NSArray *images = @[self.imageOne,self.imageTwo,self.imageThree];
    NSArray *imageNames = @[@"idCardTop",@"idCardBack",@"imageFace"];
    [MCSessionManager.shareManager mc_UPLOAD:@"/paymentgateway/baidu/idcard/getScore" parameters:nil images:images remoteFields:imageNames imageNames:imageNames imageScale:0.0001 imageType:nil ok:^(MCNetResponse * _Nonnull resp) {
        MCLog(@"成功，%@",resp.result);
        [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_user_realname];
    } other:^(MCNetResponse * _Nonnull resp) {
        //MCLog(@"%@",resp.result);
    } failure:^(NSError * _Nonnull error) {
        //MCLog(@"%@",error);
    }];
}

@end
