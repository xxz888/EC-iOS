//
//  MCArticleMoreOpration.h
//  Pods
//
//  Created by wza on 2020/9/10.
//

#import <Foundation/Foundation.h>
#import "QMUIPopupContainerView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^didSelectedBlock)(NSInteger index);
@interface MCArticleMoreOpration : QMUIPopupContainerView

@property(nonatomic, copy) didSelectedBlock selectedBlock;

@end

NS_ASSUME_NONNULL_END
