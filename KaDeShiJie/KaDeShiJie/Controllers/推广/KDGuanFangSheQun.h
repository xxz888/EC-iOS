//
//  KDGuanFangSheQun.h
//  KaDeShiJie
//
//  Created by BH on 2021/10/19.
//  Copyright © 2021 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^zhidaoleBlock)();
NS_ASSUME_NONNULL_BEGIN

@interface KDGuanFangSheQun : UIView
@property (weak, nonatomic) IBOutlet UILabel *wxHaoMaLbl;
- (IBAction)zhidaoleAction:(id)sender;
@property (nonatomic ,copy)zhidaoleBlock block;

@end

NS_ASSUME_NONNULL_END
