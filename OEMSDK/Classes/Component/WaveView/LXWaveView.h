
#import <UIKit/UIKit.h>

@interface LXWaveView : UIView
/*
 波的数量
 */
@property (nonatomic, assign) NSInteger waveNum;
@end

#pragma mark - 波浪模型
@interface LXWaveModel : NSObject
/*
 x偏移
 */
@property (nonatomic, assign) CGFloat offsetX;

/*
 速度
 */
@property (nonatomic, assign) CGFloat waveSpeed;

/*
layer
 */
@property (nonatomic, strong) CAShapeLayer *waveLayer;

@end
