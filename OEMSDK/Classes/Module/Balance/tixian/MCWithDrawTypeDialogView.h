//
//  MCWithDrawTypeDialogView.h
//  Pods
//
//  Created by wza on 2020/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MCWithDrawTypeDialogViewDelegate <NSObject>

- (void)withdrawTypeDialogviewOnChanged:(nullable NSString *)type;

@end

@interface MCWithDrawTypeDialogView : UIView

@property(nonatomic, weak) id <MCWithDrawTypeDialogViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
