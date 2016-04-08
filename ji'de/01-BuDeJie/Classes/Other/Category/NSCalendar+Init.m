//
//  NSCalendar+Init.m
//  日期处理
//
//  Created by 1 on 15/12/26.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "NSCalendar+Init.h"

@implementation NSCalendar (Init)
+ (instancetype)bs_calendar
{
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    } else {
        return [NSCalendar currentCalendar];
    }
//    NSCalendar *calendar = nil;
//    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
//        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
//    } else {
//        calendar = [NSCalendar currentCalendar];
//    }
//    return calendar;
}
@end
