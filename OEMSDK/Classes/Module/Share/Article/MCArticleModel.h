//
//  MCArticleModel.h
//  MCOEM
//
//  Created by wza on 2020/5/12.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCArticleModel : NSObject

@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *remarks1;
@property (nonatomic, copy) NSString *brand_id;

@property (nonatomic, strong) NSArray<NSString *> *img_url;

@end

NS_ASSUME_NONNULL_END

