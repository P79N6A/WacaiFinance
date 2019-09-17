//
//  UserActionStatisticsForRN.m
//  FinanceApp
//
//  Created by luowen on 16/11/2.
//  Copyright © 2016年 com.hangzhoucaimi.finance. All rights reserved.
//

#import "UserActionStatisticsForRN.h"
#import "WCAEvent.h"
#import "WCALogging.h"

@implementation UserActionStatisticsForRN

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(actionLog:(NSUInteger)mid)
{
//    [UserAction actionLog:mid];
}

RCT_EXPORT_METHOD(actionLogWith:(NSUInteger)mid event:(NSString *)event)
{
//    [UserAction actionLog:mid event:event];
}

RCT_EXPORT_METHOD(WACLogWithEventName:(NSString *)eventName attributes:(NSDictionary *)attributes)
{
    WCAEvent *logEvent = [[WCAEvent alloc] init];
    logEvent.eventName = eventName;
    logEvent.attributes = attributes;
    [WCALogging logEvent:logEvent];
}

@end
