//
//  PlanNet.h
//  OA
//
//  Created by Elon Musk on 16/7/13.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "BaseHandler.h"

@interface PlanNet : BaseHandler

+ (void)excuteGetCheckLowWithUid:(NSString *)uid
                         success:(SuccessBlock)success
                          failed:(FailedBlock)failed;


+ (void)excuteGetWeekPlanWithUid:(NSString *)uid
                       startTime:(NSString *)startTime
                         endTime:(NSString *)endTIme
                         success:(SuccessBlock)success
                          failed:(FailedBlock)failed;

+ (void)excuteGetDayPlanWithUid:(NSString *)uid
                       startTime:(NSString *)startTime
                         endTime:(NSString *)endTIme
                         success:(SuccessBlock)success
                          failed:(FailedBlock)failed;

+(void)excutePostPlanWithUid:(NSString *)uid
                   startTime:(NSString *)startTime
                     endTime:(NSString *)endTime
                    weekPlan:(NSString *)weekPlan
                  weekReport:(NSString *)weekReport
                dayPlanArray:(NSArray *)dayPlanArray
                     success:(SuccessBlock)success
                      failed:(FailedBlock)failed;




@end
