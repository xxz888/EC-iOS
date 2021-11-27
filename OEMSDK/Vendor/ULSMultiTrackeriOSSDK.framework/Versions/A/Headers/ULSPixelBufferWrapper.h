//
//  ULSPixelBufferWrapper.h
//  ULSVideoTrackerDemo
//
//  Created by Feng Chen on 2017/10/25.
//  Copyright © 2017年 ULSee Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreVideo/CoreVideo.h>

@interface ULSPixelBufferWrapper : NSObject
-(instancetype)init;
-(void)rotateLeftFlipHorizontal:(CVPixelBufferRef)pixelBuffer videoAngles:(int)angels;
-(void)releaseBuffer;
-(CVPixelBufferRef)getPixelBuffer;

//internal use only
-(id)getInternalObject;
@end
