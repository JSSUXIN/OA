//
//  NSDateCalendar.m
//  OA
//
//  Created by Elon Musk on 16/7/15.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "NSDateCalendar.h"

@implementation NSDateCalendar

 + (NSDate *)getNowTime{// 获取当前时区当前时间
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localDate = [date dateByAddingTimeInterval: interval];
    return localDate;
}

+ (NSDate *)getTimeWithDate:(NSDate *)date{//获取时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localDate = [date dateByAddingTimeInterval: interval];
    return localDate;
}

+ (NSInteger)getNowMonthWithDate:(NSDate *)date{//获取当前时间当前月
    NSDateComponents *dateComponent = [self getComponentWithDate:date];
    NSInteger month = [dateComponent month];
    return month;
}

+ (NSInteger)getDayOfWeekWithDate:(NSDate *)date{//获取今天周几---(0-6   周日-周六)
    NSDateComponents *dateComponent = [self getComponentWithDate:date];
    NSInteger week = [dateComponent weekday];
    if (week ==1) {
        week = 7;
    }else{
        week--;
    }
    return week;
}


+ (NSDateComponents *)getComponentWithDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday| NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    return dateComponent;
}

+ (NSDate *)getThisMondayWithDate:(NSDate *)date{//本周一date
    NSInteger dayOfWeek = [self getDayOfWeekWithDate:date];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;

    NSDate *monday = [[NSDate alloc] initWithTimeInterval:-(secondsPerDay*(dayOfWeek-1)) sinceDate:date];
    return monday;
}

+(NSDate *)getThisSundayWithDate:(NSDate *)date{//本周日date
    NSDate *monday = [self getThisMondayWithDate:date];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *sunday = [[NSDate alloc] initWithTimeInterval:(secondsPerDay*6) sinceDate:monday];
    return sunday;
}

+(NSDate *)getNextMondayWithDate:(NSDate *)date{//下周一date
    NSDate *sunday = [self getThisSundayWithDate:date];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *nextMonday = [[NSDate alloc] initWithTimeInterval:secondsPerDay sinceDate:sunday];
    return nextMonday;
}

+ (NSString *)getWeekStringWithInteger:(NSInteger)number{
    NSString *string;
    switch (number) {
        case 0:
            string = @"星期天";
            break;
        case 1:
            string = @"星期一";
            break;
        case 2:
            string = @"星期二";
            break;
        case 3:
            string = @"星期三";
            break;
        case 4:
            string = @"星期四";
            break;
        case 5:
            string = @"星期五";
            break;
        case 6:
            string = @"星期六";
            break;
        default:
            break;
    }
    return string;
}

@end
