//
//  PlanModel.h
//  OA
//
//  Created by Elon Musk on 16/7/13.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "BaseHandler.h"

@interface PlanModel : BaseHandler

@property (nonatomic,copy) NSString *planContent;
@property (nonatomic,copy) NSString *reportContent;


+(PlanModel *)parseWeekPlanWithDic:(NSDictionary *)dic;

+(NSArray *)parseDayPlanWithArray:(NSArray *)ary;

@end
