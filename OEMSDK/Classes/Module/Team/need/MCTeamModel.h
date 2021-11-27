//
//  MCTeamModel.h
//  MCOEM
//
//  Created by wza on 2020/5/11.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 团队模型
 */
@interface MCTeamTodayModel: NSObject
@property (nonatomic, assign) NSInteger realName;
@property (nonatomic, assign) NSInteger directPush;
@property (nonatomic, assign) NSInteger betweenPush;
@property (nonatomic, assign) NSInteger vip;
@end

@interface MCTeamYestodayModel: NSObject
@property (nonatomic, assign) NSInteger realName;
@property (nonatomic, assign) NSInteger directPush;
@property (nonatomic, assign) NSInteger betweenPush;
@property (nonatomic, assign) NSInteger vip;
@end

@interface MCTeamAllModel: NSObject
@property (nonatomic, assign) NSInteger realName;
@property (nonatomic, assign) NSInteger directPush;
@property (nonatomic, assign) NSInteger betweenPush;
@property (nonatomic, assign) NSInteger vip;
@end

@interface MCTeamModel : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *Gradepreuids;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *GradesonIds;
@property (nonatomic, copy) NSString *TrueFalseBuy;

@property (nonatomic, strong) MCTeamTodayModel *all;
@property (nonatomic, strong) MCTeamYestodayModel *yesterday;
@property (nonatomic, strong) MCTeamAllModel *today;
@end

NS_ASSUME_NONNULL_END
