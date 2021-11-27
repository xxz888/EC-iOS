//
//  NSBundle+wgSubBundle.m
//  Pods
//
//  Created by wza on 2020/7/2.
//

#import "NSBundle+wgSubBundle.h"
#import "MCNewsCell.h"

@implementation NSBundle (wgSubBundle)

+ (instancetype)wg_subBundleWithBundleName:(NSString *)bundleName targetClass:(Class)targetClass{
    //并没有拿到子bundle
    NSBundle *bundle = [NSBundle bundleForClass:targetClass];
    //在这个路径下找到子bundle的路径
    NSString *path = [bundle pathForResource:bundleName ofType:@"bundle"];
    //根据路径拿到子bundle
    return path?[NSBundle bundleWithPath:path]:[NSBundle mainBundle];
    
    /*
     这种方式也可以
     NSBundle *bundle = [NSBundle bundleForClass:targetClass];
     NSURL *url = [bundle URLForResource:bundleName withExtension:@"bundle"];
     return path?[NSBundle bundleWithURL:url]:[NSBundle mainBundle];
     */
}

+ (instancetype)OEMSDKBundle {
    // xib文件都放到./Resource文件夹下
    NSBundle *sdkBundle = [NSBundle wg_subBundleWithBundleName:@"OEMSDK" targetClass:[MCNewsCell class]];
    return sdkBundle;
}

@end
