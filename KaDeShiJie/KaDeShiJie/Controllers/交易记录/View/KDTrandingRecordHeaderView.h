//
//  KDTrandingRecordView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/23.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KDTrandingRecordHeaderViewDelegate <NSObject>

- (void)headerViewDelegateWithTime:(NSString *_Nonnull)time;
- (void)headerViewDelegateWithType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_BEGIN

@interface KDTrandingRecordHeaderView : UIView


@property (nonatomic, weak) id<KDTrandingRecordHeaderViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
