//
//  MCTXManager.m
//  MCOEM
//
//  Created by wza on 2020/4/7.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCTXManager.h"
#import "NSBundle+changeBundleId.h"
//#import <AuthSDK/AuthSDK.h>

static MCTXManager *_singleManager = nil;

@interface MCTXManager ()

//<AuthSDKDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//
//@property(nonatomic, copy) MCTXCallBack callBack;
//@property(nonatomic, strong) UIImage *bestImage;    //记录刷脸最清晰的照片

//@property(nonatomic, strong) AuthSDK *auth;
//@property(nonatomic, copy) NSString *bizToken;


@end

@implementation MCTXManager
//- (AuthSDK *)auth {
//    if (!_auth) {
//        _auth = [[AuthSDK alloc] init];
//    }
//    return _auth;
//}
//+ (instancetype)shared {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken,^{
//        _singleManager = [[super alloc] init];
//    });
//    return _singleManager;
//}
//
//- (void)startBankOcrCompletion:(MCTXCallBack)callBack {
//    self.callBack = callBack;
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    picker.allowsEditing = NO;
//    picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
//
//    [MCLATESTCONTROLLER.navigationController presentViewController:picker animated:YES completion:nil];
//}
//- (void)startFaceEngineCompletion:(MCTXCallBack)callBack {
//    self.callBack = callBack;
//
//    __weak __typeof(self)weakSelf = self;
//    [self mc_getTXParametersCompletion:^(NSDictionary *reponse) {
//        NSString *bizToken = [reponse objectForKey:@"bizToken"];
//        if (!bizToken || ![bizToken isKindOfClass:[NSString class]] || bizToken.length < 1) {
//            return;
//        }
//        weakSelf.bizToken = bizToken;
//        MCLog(@"bizToken:%@",bizToken);
//        MCLog(@"MCLATESTCONTROLLER:%@",MCLATESTCONTROLLER);
//
//        [weakSelf.auth startAuthWithToken:bizToken parent:MCLATESTCONTROLLER delegate:weakSelf];
//
//        MCLog(@"******************************");
//    }];
//
//
//}
//
//#pragma mark - 从接口请求腾讯的配置参数
//- (void)mc_getTXParametersCompletion:(void(^)(NSDictionary *reponse))completion {
//    [MCSessionManager.shareManager mc_POST:@"/user/app/get/udun/realname/detectAuth" parameters:nil ok:^(MCNetResponse * _Nonnull okResponse) {
//        completion(okResponse.result);
//    } other:^(MCNetResponse * _Nonnull resp) {
//        [MCLoading hidden];
//        [MCToast showMessage:resp.messege];
//        MCTXResult *rr = [[MCTXResult alloc] init];
//        rr.error = [NSError errorWithDomain:resp.messege code:resp.code.intValue userInfo:nil];
//        self.callBack(rr);
//    } failure:^(NSError * _Nonnull error) {
//        [MCLoading hidden];
//        [MCToast showMessage:[NSString stringWithFormat:@"%ld\n%@", (long)error.code, error.localizedFailureReason]];
//        MCTXResult *rr = [[MCTXResult alloc] init];
//        rr.error = error;
//        self.callBack(rr);
//    }];
//}
//#pragma mark - 上传银行卡图片
//- (void)uploadBankImage:(UIImage *)image {
//
//    [MCSessionManager.shareManager mc_UPLOAD:@"/paymentchannel/app/auth/bankcardocr" parameters:@{@"brandId":SharedConfig.brand_id} images:@[image] remoteFields:@[@"bankFile"] imageNames:@[@"bankFile"] imageScale:0.0001 imageType:nil ok:^(MCNetResponse * _Nonnull resp) {
//        //MCLog(@"%@",resp.result);
//        MCTXResult *result = [MCTXResult new];
//        result.brankCardNo = [NSString stringWithFormat:@"%@",resp.result[@"cardNum"]];
//        result.cardImg = image;
//        self.callBack(result);
//    } other:^(MCNetResponse * _Nonnull resp) {
//        [MCLoading hidden];
//        [MCToast showMessage:resp.messege];
//        MCTXResult *rr = [[MCTXResult alloc] init];
//        rr.error = [NSError errorWithDomain:resp.messege code:resp.code.intValue userInfo:nil];
//        self.callBack(rr);
//    } failure:^(NSError * _Nonnull error) {
//        [MCLoading hidden];
//        [MCToast showMessage:[NSString stringWithFormat:@"%ld\n%@", (long)error.code, error.localizedFailureReason]];
//        MCTXResult *rr = [[MCTXResult alloc] init];
//        rr.error = error;
//        self.callBack(rr);
//    }];
//}
//#pragma mark - AuthSDKDelegate
//- (void)onResultBack:(NSDictionary *)result {
//    if ([[result objectForKey:@"errorcode"] intValue] == 0) {   //成功
//       /*二次实名传参*/
//        NSString *isWhether =  [[NSUserDefaults standardUserDefaults] objectForKey:@"WHETHER"];
//          NSDictionary *param = [NSDictionary dictionary];
//          if ([isWhether isEqualToString:@"1"]) {
//              param = @{@"bizToken":self.bizToken,@"isReRealName":isWhether};
//          }else{
//              param = @{@"bizToken":self.bizToken};
//          }
//        /**/
//
//        [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/get/udun/realname/getDetectInfo/%@",TOKEN] parameters:param ok:^(MCNetResponse * _Nonnull resp) {
//            //成功
//            [MCModelStore.shared reloadUserInfo:nil];
//            self.callBack([MCTXResult new]);
//        } other:^(MCNetResponse * _Nonnull resp) {
//            [MCLoading hidden];
//            [MCToast showMessage:resp.messege];
//            MCTXResult *rr = [[MCTXResult alloc] init];
//            rr.error = [NSError errorWithDomain:resp.messege code:resp.code.intValue userInfo:nil];
//            self.callBack(rr);
//        } failure:^(NSError * _Nonnull error) {
//            [MCLoading hidden];
//            [MCToast showMessage:[NSString stringWithFormat:@"%ld\n%@", (long)error.code, error.localizedFailureReason]];
//            MCTXResult *rr = [[MCTXResult alloc] init];
//            rr.error = error;
//            self.callBack(rr);
//        }];
//    } else {
//        [MCToast showMessage:@"实名失败，请重试！"];
//        MCTXResult *rr = [[MCTXResult alloc] init];
//        rr.error = [NSError errorWithDomain:@"实名失败，请重试！" code:0 userInfo:nil];
//        self.callBack(rr);
//    }
//}
//
//#pragma mark - ImagePicker
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
//    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
//
//    if (img) {
//        //压缩到
//        UIImage *copressionImg = [MCImageStore compressImage:img WithLength:100];
//        [picker dismissViewControllerAnimated:YES completion:nil];
//        [self uploadBankImage:copressionImg];
//    }
//}

@end


@implementation MCTXResult
@end
