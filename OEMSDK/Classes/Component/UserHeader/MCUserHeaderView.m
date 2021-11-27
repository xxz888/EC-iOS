//
//  MCUserHeaderView.m
//  Project
//
//  Created by Li Ping on 2019/5/31.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCUserHeaderView.h"
#import "UIButton+WebCache.h"


static NSString * api_getheadpath = @"/user/app/headportrait/getby/phone";
static NSString * api_uploadhead = @"/user/app/headportrait/updateby/phone";

@interface MCUserHeaderView() <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *headerButton;


@end

@implementation MCUserHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width / 2;
    [self addSubview:self.headerButton];
    [self fetchHeaderPath];
}

- (UIButton *)headerButton {
    if (!_headerButton) {
        _headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerButton.frame = self.bounds;
        _headerButton.imageView.contentMode = 2;
        [_headerButton setBackgroundImage:BCFI.image_logo forState:UIControlStateNormal];
//        [_headerButton setImage:[MCImageStore getAppIcon] forState:UIControlStateNormal];
        [_headerButton addTarget:self action:@selector(onHeaderTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerButton;
}

- (void)fetchHeaderPath {
    
    [MCSessionManager.shareManager mc_POST:api_getheadpath parameters:@{@"phone":SharedUserInfo.phone, @"brandId":SharedConfig.brand_id} ok:^(MCNetResponse * _Nonnull resp) {
        SharedUserInfo.headImvUrl = resp.result;
        [self.headerButton sd_setImageWithURL:[NSURL URLWithString:resp.result] forState:UIControlStateNormal];
    }];
}

- (void)onHeaderTouched:(UIButton *)sender {
    [self showSheet];
}
-(void)showSheet {
    UIViewController *current = MCLATESTCONTROLLER;
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        [current presentViewController:imagePicker animated:YES completion:nil];
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


- (void)uploadHeader:(UIImage *)image picker:(UIImagePickerController *)picker {
    
    NSDictionary *param = @{@"phone":SharedUserInfo.phone,
                            @"brandId":SharedConfig.brand_id
                            };
    
    [MCSessionManager.shareManager mc_UPLOAD:api_uploadhead parameters:param images:@[image] remoteFields:@[@"image"] imageNames:nil imageScale:1 imageType:nil ok:^(MCNetResponse * _Nonnull resp) {
        
        [self.headerButton setImage:image forState:UIControlStateNormal];
        [MCToast showMessage:resp.messege];
        [picker dismissViewControllerAnimated:YES completion:nil];
    } other:nil failure:nil];
}

#pragma mark Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"]) {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self uploadHeader:image picker: picker];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
