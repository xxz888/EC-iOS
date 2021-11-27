//
//  MCFeedBackHeader.h
//  Pods
//
//  Created by wza on 2020/8/19.
//

#import <UIKit/UIKit.h>
#import "MCFeedTypeButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCFeedBackHeader : UIView
@property (weak, nonatomic) IBOutlet MCFeedTypeButton *button1;
@property (weak, nonatomic) IBOutlet MCFeedTypeButton *button2;
@property (weak, nonatomic) IBOutlet MCFeedTypeButton *button3;

@property (weak, nonatomic) IBOutlet QMUITextView *textView;
@property (weak, nonatomic) IBOutlet QMUITextField *textField;


@end

NS_ASSUME_NONNULL_END
