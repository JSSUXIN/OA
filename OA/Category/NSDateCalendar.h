//
//  NSDateCalendar.h
//  OA
//
//  Created by Elon Musk on 16/7/15.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateCalendar : NSObject


+ (NSDate *)getNowTime;//当前时间

+ (NSDate *)getTimeWithDate:(NSDate *)date;//获取时间


+ (NSInteger)getNowMonthWithDate:(NSDate *)date;//获取当前时间当前月

+ (NSInteger)getDayOfWeekWithDate:(NSDate *)date;

+ (NSDate *)getThisMondayWithDate:(NSDate *)date;//获取本周一date

+ (NSDate *)getThisSundayWithDate:(NSDate *)date;//获取本周日date

+ (NSDate *)getNextMondayWithDate:(NSDate *)date;//下周一date

+ (NSString *)getWeekStringWithInteger:(NSInteger)number;//返回具体星期几

@end
