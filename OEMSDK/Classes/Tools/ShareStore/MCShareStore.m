//
//  MCShareStore.m
//  MCStores
//
//  Created by Li Ping on 2019/5/23.
//  Copyright © 2019 MingChe. All rights reserved.
//

#import "MCShareStore.h"
#import <UShareUI/UShareUI.h>
#import <UMShare/UMShare.h>
#import <Photos/Photos.h>
#import <OEMSDK.h>
#import "KDShareBottomView.h"
@implementation MCShareStore

//  分享
+ (void)shareIOS:(UIImage *)image {
//    UIImage *newImg = [MCImageStore compressImageSize:image toKByte:800];
    [self shareIOS:image completionHandler:nil];
}

+ (void)shareIOS:(UIImage *)image completionHandler:(ShareHandle)handler{
//    UIImage *newImg = [MCImageStore compressImageSize:image toKByte:800];
    UIImage *newImg = [MCImageStore compressImage:image WithLength:500];
    NSArray *activityItems = @[newImg];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.modalInPopover = YES;
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,
                                         UIActivityTypePostToTwitter,
                                         UIActivityTypePostToWeibo,
                                         UIActivityTypeMail,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop,
                                         UIActivityTypeOpenInIBooks
                                         ];
    
    
    [MCLATESTCONTROLLER presentViewController:activityVC animated:YES completion:nil];
    
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            [MCToast showMessage:@"分享成功"];
        }
//        if (SharedConfig.is_share_conin) {
//            [self requetEarnCoin];
//        }
        if (handler) {        
            handler(activityVC,completed,returnedItems,activityError);
        }
    };
}

+ (void)shareWebLink:(NSArray *)items
{
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    activityVC.modalInPopover = YES;
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,
                                         UIActivityTypePostToTwitter,
                                         UIActivityTypePostToWeibo,
                                         UIActivityTypeMail,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop,
                                         UIActivityTypeOpenInIBooks
                                         ];
    
    
    [MCLATESTCONTROLLER presentViewController:activityVC animated:YES completion:nil];
    
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            [MCToast showMessage:@"分享成功"];
        }
    };
}

/// 分享后请求接口获得金币
+(void)requetEarnCoin{
    
    NSDictionary *param = @{@"share_type":@"1",@"userId":SharedUserInfo.userid};
    [MCSessionManager.shareManager mc_POST:@"/user/app/coinreward/share" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        [MCToast showMessage:[NSString stringWithFormat:@"分享成功，获得%@积分已到账",resp.result[@"coin"]]];
    }];
}


+ (void)sharePlatform:(UIImage *)image {
    
    [MCShareStore sharePlatformWithTitle:nil content:nil image:image url:nil];
}

+ (void)sharePlatformWithTitle:( NSString * _Nullable)title content:( NSString * _Nullable)content image:(UIImage * _Nullable)image url:(NSString * _Nullable)url {
    
    NSArray * titles = @[@"保存相册",@"微信",@"朋友圈",@"QQ",@"QQ空间"];
    NSArray * iconnames = @[@"mc_share_albulm",@"mc_share_wechat",@"mc_share_timeline",@"mc_share_qq",@"mc_share_qzone"];
    NSArray * platforms  = @[
                             @(UMSocialPlatformType_UserDefine_Begin + 1),
                             @(UMSocialPlatformType_WechatSession),
                             @(UMSocialPlatformType_WechatTimeLine),
                             @(UMSocialPlatformType_QQ),
                             @(UMSocialPlatformType_Qzone)
                             ];
    
    
    //  去掉icon背景
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    //  每行5列
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndBottom = 5;
    [UMSocialUIManager setPreDefinePlatforms:platforms];
    
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin + 1 withPlatformIcon:[UIImage mc_imageNamed:iconnames[0]] withPlatformName:titles[0]];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_WechatSession withPlatformIcon:[UIImage mc_imageNamed:iconnames[1]] withPlatformName:titles[1]];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_WechatTimeLine withPlatformIcon:[UIImage mc_imageNamed:iconnames[2]] withPlatformName:titles[2]];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_QQ withPlatformIcon:[UIImage mc_imageNamed:iconnames[3]] withPlatformName:titles[3]];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_Qzone withPlatformIcon:[UIImage mc_imageNamed:iconnames[4]] withPlatformName:titles[4]];
    
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        NSLog(@"SSSSSSSSSSSSSS:%@", [NSThread currentThread]);
        if (platformType == UMSocialPlatformType_UserDefine_Begin + 1) {
            [MCShareStore saveToAlbum:image];
        }
        if (platformType == UMSocialPlatformType_WechatSession) {
            [MCShareStore shareToWeChatSessionWithTitle:title content:content image:image url:url];
        }
        if (platformType == UMSocialPlatformType_WechatTimeLine) {
            [MCShareStore shareToWeChatTimeLineWithTitle:title content:content image:image url:url];
        }
        if (platformType == UMSocialPlatformType_QQ) {
            [MCShareStore shareToQQWithTitle:title content:content image:image url:url];
        }
        if (platformType == UMSocialPlatformType_Qzone) {
            [MCShareStore shareToQzoneWithTitle:title content:content image:image url:url];
        }
    }];
    
}

+ (void)saveToAlbum:(UIImage *)image {
    [MCLoading show];
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"===============%@", [NSThread currentThread]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MCLoading hidden];
            NSString *msg = @"";
            
            if (error) {
                msg = @"保存失败，请重试！";
            } else {
                msg = @"保存成功！";
            }
            [MCToast showMessage:msg];
        });
    }];
}
+ (void)saveToAlbumFenXiang:(UIImage *)image {
    [MCLoading show];
//    KDShareBottomView * bottomView = [KDShareBottomView newFromNib];
//    bottomView.codeImv.image = [MCImageStore creatShareImageWithImageFenXiang:[UIImage mc_imageNamed:@"mc_sharepop_bg"]];

//    UIImage * bottomImv =  [MCShareStore convertViewToImage:bottomView];
//    UIImage * newDownLoadImv = [MCShareStore addHeadImage:nil footImage:bottomImv toMasterImage:image];
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"===============%@", [NSThread currentThread]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MCLoading hidden];
            NSString *msg = @"";
            
            if (error) {
                msg = @"保存失败，请重试！";
            } else {
                msg = @"保存成功！";
            }
            [MCToast showMessage:msg];
        });
    }];
}
//使用该方法不会模糊，根据屏幕密度计算
+ (UIImage *)convertViewToImage:(UIView *)view {
    
    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
    
}
//  微信会话
+ (void)shareToWeChatSession:(UIImage *)image {
    
    [MCShareStore shareToWeChatSessionWithTitle:nil content:nil image:image url:nil];
}
+ (void)shareToWeChatSessionWithTitle:(NSString * _Nullable)title content:(NSString * _Nullable)content image:(UIImage * _Nullable)image url:(NSString * _Nullable)url {
    
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:[MCShareStore creatUMSocialMessageObjectWithTitle:title content:content image:image url:url] currentViewController:MCLATESTCONTROLLER completion:^(id result, NSError *error) {
        if (error) {    //失败调用系统分享
            NSLog(@"%@",error);
            [MCShareStore shareIOS:image];
        }
    }];
}

//  朋友圈
+ (void)shareToWeChatTimeLine:(UIImage *)image {
    [MCShareStore shareToWeChatTimeLineWithTitle:nil content:nil image:image url:nil];
}
+ (void)shareToWeChatTimeLineWithTitle:(NSString * _Nullable)title content:(NSString * _Nullable)content image:(UIImage * _Nullable)image url:(NSString * _Nullable)url {
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:[MCShareStore creatUMSocialMessageObjectWithTitle:title content:content image:image url:url] currentViewController:MCLATESTCONTROLLER completion:^(id result, NSError *error) {
        if (error) {    //失败调用系统分享
            [MCShareStore shareIOS:image];
        }
    }];
    
}

//  QQ
+ (void)shareToQQ:(UIImage *)image {
    [MCShareStore shareToQQWithTitle:nil content:nil image:image url:nil];
}
+ (void)shareToQQWithTitle:(NSString * _Nullable)title content:(NSString * _Nullable)content image:(UIImage * _Nullable)image url:(NSString * _Nullable)url {
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:[MCShareStore creatUMSocialMessageObjectWithTitle:title content:content image:image url:url] currentViewController:MCLATESTCONTROLLER completion:^(id result, NSError *error) {
        if (error) {    //失败调用系统分享
            [MCShareStore shareIOS:image];
        } 
    }];
}

//  空间
+ (void)shareToQzone:(UIImage *)image {
    [MCShareStore shareToQzoneWithTitle:nil content:nil image:image url:nil];
}
+ (void)shareToQzoneWithTitle:(NSString * _Nullable)title content:(NSString * _Nullable)content image:(UIImage * _Nullable)image url:(NSString * _Nullable)url {
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Qzone messageObject:[MCShareStore creatUMSocialMessageObjectWithTitle:title content:content image:image url:url] currentViewController:MCLATESTCONTROLLER completion:^(id result, NSError *error) {
        if (error) {    //失败调用系统分享
            [MCShareStore shareIOS:image];
        }
    }];
}

+ (UMSocialMessageObject *)creatUMSocialMessageObjectWithTitle:(NSString *)title content:(NSString *)content image:(UIImage *)image url:(NSString *)url {
    if (title) {
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:(image ? image : [MCImageStore getAppIcon])];
        shareObject.webpageUrl = url;
        messageObject.shareObject = shareObject;
        return messageObject;
    } else {
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        UMShareImageObject *shareObj = [[UMShareImageObject alloc] init];
        shareObj.shareImage = image ;
        
        messageObject.shareObject = shareObj;
        
        return messageObject;
    }
}



+ (void)popShareImage {
    MCPopShareController *vc = [[MCPopShareController alloc] initWithNibName:@"MCPopShareController" bundle:[NSBundle OEMSDKBundle]];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    UIViewController *current = MCLATESTCONTROLLER;
    current.definesPresentationContext = YES;
    if (current.parentViewController) {
        [current.parentViewController presentViewController:vc animated:NO completion:nil];
    } else {
        [current presentViewController:vc animated:NO completion:nil];
    }
    
}

/* Image 拼接
 * masterImage  主图片
 * headImage   头图片
 * footImage   尾图片
 */
+ (UIImage *)addHeadImage:(UIImage *)headImage footImage:(UIImage *)footImage toMasterImage:(UIImage *)masterImage {
    
    CGSize size;
    size.width = masterImage.size.width;
    
    CGFloat headHeight = !headImage? 0:size.width/headImage.size.width*headImage.size.height;
    CGFloat footHeight = !footImage? 0:size.width/footImage.size.width*footImage.size.height;
    
//    CGFloat headHeight = !headImage? 0:headImage.size.height/2.0;
//    CGFloat footHeight = !footImage? 0:footImage.size.height/2.0;
    
    size.height = masterImage.size.height + headHeight + footHeight;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    
    if (headImage)
        [headImage drawInRect:CGRectMake(0, 0, masterImage.size.width, headHeight)];
    
    
    [masterImage drawInRect:CGRectMake(0, headHeight, masterImage.size.width, masterImage.size.height)];
    
    if (footImage)
        [footImage drawInRect:CGRectMake(0, masterImage.size.height + headHeight, masterImage.size.width, footHeight)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resultImage;
}
@end
