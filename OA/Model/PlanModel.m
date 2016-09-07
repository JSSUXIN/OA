//
//  PlanModel.m
//  OA
//
//  Created by Elon Musk on 16/7/13.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "PlanModel.h"

@implementation PlanModel

-(instancetype)init{
    self = [super init];
    if (self) {
        _reportContent = @"";
        _planContent = @"";
    }
    return self;
}

+(PlanModel *)parseWeekPlanWithDic:(NSDictionary *)dic{
    PlanModel *model = [[PlanModel alloc]init];
    model.planContent = [NSString isNull:dic[@"p_Content"]];
    model.reportContent = [NSString isNull:dic[@"p_SumUp"]];
    return model;
}

+(NSArray *)parseDayPlanWithArray:(NSArray *)ary{
    NSMutableArray *mulary = [NSMutableArray array];
    for (NSDictionary *dic in ary) {
        PlanModel *model = [[PlanModel alloc]init];
        model.planContent = [NSString isNull:dic[@"d_DayPlan"]];
        model.reportContent = [NSString isNull:dic[@"d_DayReport"]];
        [mulary addObject:model];
    }
    return mulary;
}


@end
