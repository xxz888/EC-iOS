//
//  MCAccreditation2ViewController.m
//  OEMSDK
//
//  Created by apple on 2020/10/30.
//

#import "MCAccreditation2ViewController.h"
#import "UIViewController+ImagePicker.h"
#import "liveness/Liveness.h"
#import "KDLoginTool.h"
#import "DDPhotoViewController.h"
#import "KDCommonAlert.h"
#import <MeiQiaSDK/MQDefinition.h>

#define ZhengMian_FailString @"身份证正面识别失败"
#define FanMian_FailString   @"身份证反面识别失败"

#define ZhengMian @"身份证正面"
#define FanMian   @"身份证反面"
@interface MCAccreditation2ViewController ()<LivenessDetectDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(strong,nonatomic)NSString * address;

@property(assign,nonatomic)NSString * zhengmianfanmian;

@end

@implementation MCAccreditation2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
}
-(void)setUI{
    ViewRadius(self.fanImv,5);
    ViewRadius(self.zhengImv,5);
    [self setNavigationBarTitle:@"实名认证" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    //选择省
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhengmianAction:)];
    [self.zhengImv addGestureRecognizer:tap1];
    //选择市
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fanmianAction:)];
    [self.fanImv addGestureRecognizer:tap2];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"客服" forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleLabel.font = LYFont(14);
    shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);


    shareBtn.frame = CGRectMake(SCREEN_WIDTH - 70, StatusBarHeightConstant + 12, 70, 22);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
}
-(void)clickRightBtnAction{
    [MCServiceStore pushMeiqiaVC];
}
-(void)showSheet:(NSString *)zhengfan{
    UIViewController *current = MCLATESTCONTROLLER;
    __weak __typeof(self)weakSelf = self;
    self.zhengmianfanmian = zhengfan;

    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied) {
            [MCToast showMessage:@"请在设置-隐私-相机界面，打开相机权限"];
            return;
        }
        
        //调用身份证大小的相机
        DDPhotoViewController *vc = [[DDPhotoViewController alloc] init];
 
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.imageblock = ^(UIImage *image) {
           
            if ([zhengfan isEqualToString:ZhengMian]) {
                //向服务器上传身份证正面
                [weakSelf upLoadZhengMian:image];
            }else{
                //向服务器上传身份证反面
                [weakSelf upLoadFanMian:image];
            }
        };
        [self presentViewController:vc animated:YES completion:nil];
    }];
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        [current presentViewController:pickerImage animated:YES completion:nil];
    }];
    [alertVc addAction:cancle];
    [alertVc addAction:camera];
    [alertVc addAction:picture];
    [current presentViewController:alertVc animated:YES completion:nil];
}
#pragma mark Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        if ([self.zhengmianfanmian isEqualToString:ZhengMian]) {
            //向服务器上传身份证正面
            [self upLoadZhengMian:image];
        }else{
            //向服务器上传身份证反面
            [self upLoadFanMian:image];
        }
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -----------点击上传身份证正面照片---------------
-(void)zhengmianAction:(id)sender{
    [self showSheet:ZhengMian];
}
#pragma mark -----------向服务器上传身份证正面---------------


-(void)upLoadZhengMian:(UIImage *)img{
    __weak __typeof(self)weakSelf = self;
    //身份证上传
    NSArray *images = @[img];
    NSArray *imageNames = @[@"bankFile"];
    NSURLSessionDataTask * _Nullable extractedExpr = [MCSessionManager.shareManager mc_UPLOAD:@"/notice/app/tysj/IDOCR/distinguish" parameters:nil images:images remoteFields:imageNames imageNames:imageNames imageScale:1.0f imageType:nil ok:^(MCNetResponse * _Nonnull resp) {
        MCLog(@"成功，%@",resp.result);
        if ([resp.code isEqualToString:@"000000"] && [resp.result[@"data"][@"side"] isEqualToString:@"front"]) {
            NSDictionary * dic = resp.result[@"data"];
            weakSelf.nameTf.text = dic[@"info"][@"name"];
            weakSelf.idTf.text = dic[@"info"][@"number"];
            weakSelf.zhengImv.image = img;
            weakSelf.address = dic[@"info"][@"address"];
        }else{
            [MCToast showMessage:ZhengMian_FailString];
            weakSelf.zhengImv.image = [UIImage mc_imageNamed:@"KD_Accreditation1"];
        }
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCToast showMessage:resp.messege];

    } failure:^(NSError * _Nonnull error) {
        //MCLog(@"%@",error);
        [MCToast showMessage:ZhengMian_FailString];
    }];
    extractedExpr;
}
#pragma mark -----------点击上传身份证反面照片---------------
-(void)fanmianAction:(id)sender{
    [self showSheet:FanMian];
}
#pragma mark -----------向服务器上传身份证反面---------------
-(void)upLoadFanMian:(UIImage *)img{
    __weak __typeof(self)weakSelf = self;
    //身份证上传
    NSArray *images = @[img];
    NSArray *imageNames = @[@"bankFile"];
    [MCSessionManager.shareManager mc_UPLOAD:@"/notice/app/tysj/IDOCR/distinguish" parameters:nil images:images remoteFields:imageNames imageNames:imageNames imageScale:1.0f imageType:nil ok:^(MCNetResponse * _Nonnull resp) {
        if ([resp.code isEqualToString:@"000000"] && [resp.result[@"data"][@"side"] isEqualToString:@"back"]) {
            NSDictionary * dic = resp.result[@"data"];
            weakSelf.fanImv.image = img;
        }else{
            [MCToast showMessage:FanMian_FailString];
            weakSelf.fanImv.image = [UIImage mc_imageNamed:@"KD_Accreditation2"];
        }
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCToast showMessage:resp.messege];
    } failure:^(NSError * _Nonnull error) {
        [MCToast showMessage:FanMian_FailString];
    }];
}
- (BOOL)image:(UIImage*)image1 isEqualTo:(UIImage*)image2{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    return[data1 isEqual:data2];
}
#pragma mark -----------点击完成跳转活物识别界面---------------
- (IBAction)finishAction:(id)sender {
    
    //监测身份证正面
    if ([self image:self.zhengImv.image isEqualTo:[UIImage mc_imageNamed:@"KD_Accreditation1"]]) {
        [MCToast showMessage:@"请上传身份证正面照"];
        return;
    }
    //监测身份证反面
    if ([self image:self.fanImv.image isEqualTo:[UIImage mc_imageNamed:@"KD_Accreditation2"]]) {
        [MCToast showMessage:@"请上传身份证反面照"];
        return;
    }
    //监测姓名
    if ([self.nameTf.text isEqualToString:@""]) {
        [MCToast showMessage:@"请输入正确的姓名"];
        return;
    }
    //监测身份证号
    if ([self.idTf.text isEqualToString:@""] || [self.idTf.text length] != 18) {
        [MCToast showMessage:@"请输入正确的身份证号"];
        return;
    }

    /*******************************
    // UI设置，默认不用设置
    NSDictionary *uiConfig = @{
       @"bottomAreaBgColor":@"026a86"    //屏幕下方颜色 026a86
       ,@"noticeTextColor":@"FFFFFF"     //动画上方动作提示文字颜色 FFFFFF
       ,@"noticeTextSize":@"21"          // 动画上方动作提示文字大小 21
                                   
       ,@"navTitleColor": @"FFFFFF"      // 导航栏标题颜色 FFFFFF
       ,@"navBgColor": @"0186aa"         // 导航栏背景颜色 0186aa
       ,@"navTitle": @"活体检测"          // 导航栏标题 活体检测
       ,@"navTitleSize":@"20"            // 导航栏标题大小 20
                                   
       ,@"roundBgColor": @"004b5e"        // 动画倒计时 进度条背景色 004b5e
       ,@"roundProgressColor": @"ed7d00" // 动画倒计时 进度条颜色 ed7d00
    };
    *******************************/
    // UI设置，默认不用设置
    NSDictionary *uiConfig = @{
       @"bottomAreaBgColor":@"F08300"    //屏幕下方颜色 026a86
       ,@"navTitleColor": @"FFFFFF"      // 导航栏标题颜色 FFFFFF
       ,@"navBgColor": @"F08300"         // 导航栏背景颜色 0186aa
       ,@"navTitle": @"人脸识别"          // 导航栏标题 活体检测
       ,@"navTitleSize":@"18"            // 导航栏标题大小 20
    };
    NSDictionary *param = @{@"actions":@"1279", @"actionsNum":@"3",
                            @"uiConfig":uiConfig};
#if TARGET_IPHONE_SIMULATOR  //模拟器

#else if TARGET_OS_IPHONE      //真机
    
    [[Liveness shareInstance] startProcess:self withParam:param withDelegate:self];
#endif
}
#pragma mark -----------活物识别完成,回调到这个界面---------------
- (void)onLiveDetectCompletion:(NSDictionary *)result{
    //code=0 代表监测成功
    __weak __typeof(self)weakSelf = self;
    if ([result[@"code"] integerValue] == 0) {
        NSString *code = [result objectForKey:@"code"];
        // 错误信息
        NSString *msg = [result objectForKey:@"msg"];
        NSString *base64String = [result objectForKey:@"passFace"];
        // 将base64字符串转为NSData
        NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64String options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
        // 将NSData转为UIImage
        UIImage *decodedImage = [UIImage imageWithData: decodeData];
        //身份证上传
        
        NSArray *images     = @[decodedImage,self.zhengImv.image,self.fanImv.image];
        NSArray *imageNames = @[@"faceFile",@"backFile",@"headFile"];
        
        [MCSessionManager.shareManager mc_UPLOAD:@"/user/app/oss/picture" parameters:nil images:images remoteFields:imageNames imageNames:imageNames imageScale:1.f imageType:nil ok:^(MCNetResponse * _Nonnull resp) {
            if ([resp.code isEqualToString:@"000000"]) {
                [weakSelf requestIDCardContrast:base64String];
            }else{
                [MCToast showMessage:resp.messege];
            }
        } other:^(MCNetResponse * _Nonnull resp) {
            //MCLog(@"%@",resp.result);
        } failure:^(NSError * _Nonnull error) {
            //MCLog(@"%@",error);
        }];
        

    }else{
        [MCToast showMessage:result[@"msg"]];
    }
}
-(void)requestIDCardContrast:(NSString *)base64String{
    //身份证上传
//    NSArray *images     = @[decodedImage];
//    NSArray *imageNames = @[@"File"];
    
    base64String = [NSString stringWithFormat:@"data:image/jpg;base64,%@",base64String];
    __weak typeof(self) weakSelf = self;
    [MCSessionManager.shareManager mc_POST:@"/user/app/tysj/IDCard/contrast" parameters:@{@"idcard":self.idTf.text,@"name":self.nameTf.text,@"image":base64String,@"address":self.address} ok:^(MCNetResponse * _Nonnull resp) {
        if ([resp.code isEqualToString:@"000000"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FIRSTSHIMING"];
            [[KDLoginTool shareInstance] getChuXuCardData:NO];
            
        }else{
            [MCToast showMessage:resp.messege];
        }

    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        [MCToast showMessage:resp.messege];
    }];
    
    
//
//    [MCSessionManager.shareManager mc_UPLOAD:@"/notice/app/tysj/IDCard/contrast" parameters:@{@"idcard":self.idTf.text,@"name":self.nameTf.text} images:images remoteFields:imageNames imageNames:imageNames imageScale:0.0001 imageType:nil ok:^(MCNetResponse * _Nonnull resp) {
//        if ([resp.code isEqualToString:@"000000"]) {
//            QMUIModalPresentationViewController * alert = [[QMUIModalPresentationViewController alloc]init];
//            KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
//            [commonAlert initKDCommonAlertTitle:@"" content:@"实名成功！" leftBtnTitle:@"" rightBtnTitle:@"确定" ];
//            alert.contentView = commonAlert;
//            commonAlert.middleActionBlock = ^{
//                [alert hideWithAnimated:YES completion:nil];
//            };
//            [alert showWithAnimated:YES completion:nil];
//            [[KDLoginTool shareInstance] getChuXuCardData:NO];
//        }else{
//            [MCToast showMessage:resp.messege];
//        }
//    } other:^(MCNetResponse * _Nonnull resp) {
//        //MCLog(@"%@",resp.result);
//    } failure:^(NSError * _Nonnull error) {
//        //MCLog(@"%@",error);
//    }];
    
    

}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err){NSLog(@"json解析失败：%@",err);return nil;}
    return dic;
}

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
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 4. 设置代理
    ipc.delegate = self;
    // 5. modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}

@end
