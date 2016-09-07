//
//  PlanNet.m
//  OA
//
//  Created by Elon Musk on 16/7/13.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "PlanNet.h"
#import "ElonHTTPSession.h"
#import "CheckLowModel.h"
#import "PlanModel.h"

@implementation PlanNet
//下级列表
+ (void)excuteGetCheckLowWithUid:(NSString *)uid
                         success:(SuccessBlock)success
                          failed:(FailedBlock)failed
{
    NSString *urlEndString = [NSString stringWithFormat:@"Plan/GetSubordinate?uid=%@",uid];
    [ElonHTTPSession requestWithRequestType:HTTPSRequestTypeGet
                                  urlString:HTTP_CONECT(BASE_URL,urlEndString)
                                  paraments:nil
                              completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
                                  NSLog(@"下级列表——————object = %@  ,,,error = %@",object,error);
                                  if ([object isKindOfClass:[NSArray class]]) {
                                     NSArray *array =  [CheckLowModel mj_objectArrayWithKeyValuesArray:object];
                                      success(array);
                                  }
                                  else{
                                      failed(error);
                                  }
                              }];
}
//查看周计划
+ (void)excuteGetWeekPlanWithUid:(NSString *)uid
                       startTime:(NSString *)startTime
                         endTime:(NSString *)endTIme
                         success:(SuccessBlock)success
                          failed:(FailedBlock)failed{
    NSString *urlEndString = [NSString stringWithFormat:@"Plan/GetWeekPlan?dt=%@&ds=%@&uid=%@",startTime,endTIme,uid];
    [ElonHTTPSession requestWithRequestType:HTTPSRequestTypeGet
                                  urlString:HTTP_CONECT(BASE_URL, urlEndString)
                                  paraments:nil
                              completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
                                  NSLog(@"周计划——————object = %@  ,,,error = %@",object,error);
                                  if ([object isKindOfClass:[NSDictionary class]]) {
                                      PlanModel *model = [PlanModel parseWeekPlanWithDic:(NSDictionary *)object];
                                      success(model);
                                  }else{
                                      failed(@"error");
                                  }
                              }];
}

//查看每日计划
+ (void)excuteGetDayPlanWithUid:(NSString *)uid
                      startTime:(NSString *)startTime
                        endTime:(NSString *)endTIme
                        success:(SuccessBlock)success
                         failed:(FailedBlock)failed{
    NSString *urlEndString = [NSString stringWithFormat:@"Plan/GetDayPlan?dt=%@&ds=%@&uid=%@",startTime,endTIme,uid];
    [ElonHTTPSession requestWithRequestType:HTTPSRequestTypeGet
                                  urlString:HTTP_CONECT(BASE_URL, urlEndString)
                                  paraments:nil
                              completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
                                  NSLog(@"日计划——————object = %@  ,,,error = %@",object,error);
                                  if ([object isKindOfClass:[NSArray class]]) {
                                      NSArray *array = [PlanModel parseDayPlanWithArray:(NSArray *)object];
                                      success(array);
                                  }else{
                                      failed(@"error");
                                  }
                              }];
    

}
//保存周计划
+(void)excutePostPlanWithUid:(NSString *)uid
                   startTime:(NSString *)startTime
                     endTime:(NSString *)endTime
                    weekPlan:(NSString *)weekPlan
                  weekReport:(NSString *)weekReport
                dayPlanArray:(NSArray *)dayPlanArray
                     success:(SuccessBlock)success
                      failed:(FailedBlock)failed{
    NSString *urlEndString = [NSString stringWithFormat:@"Plan/SetDayPlan?uid=%@",uid];
    NSMutableArray *mulArray = [NSMutableArray array];
    for (NSInteger i = 0; i<dayPlanArray.count; i++) {
        PlanModel *model = dayPlanArray[i];
        NSDictionary *dic = @{@"a":model.planContent,
                              @"b":model.reportContent,
                              @"s":@"sNone"};
        [mulArray addObject:dic];
    }
    NSDictionary *params =@{
        @"start": startTime,
        @"end": endTime,
        @"a": weekPlan,
        @"b": weekReport,
        @"days":mulArray};
    NSLog(@"params = %@",params);
    [ElonHTTPSession requestWithRequestType:HTTPSRequestTypePost
                                  urlString:HTTP_CONECT(BASE_URL, urlEndString)
                                  paraments:params
                              completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
                                  if (object&&(error == NULL)) {
                                      success(@"OK");
                                  }else{
                                      failed(@"error");
                                  }
                                  NSLog(@"上传计划——————object = %@  ,,,error = %@",object,error);
                              }];
}


@end
