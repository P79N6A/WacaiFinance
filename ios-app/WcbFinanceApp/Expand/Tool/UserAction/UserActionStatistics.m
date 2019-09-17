//
//  UserActionStatistics.m
//  wacai365
//
//  Created by wacai on 13-11-19.
//  Copyright (c) 2013年 wacai365. All rights reserved.
//

#import "UserActionStatistics.h"
#import "WCALogging.h"
#import "WCAEvent.h"

#import <Skyline/Skyline.h>
#import <i-Finance-Library/FSEventStatisticsAction.h>

@implementation UserActionStatistics

+ (UserActionStatistics*)sharedInstance {
    static UserActionStatistics* userAction = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userAction = [[self alloc] init];
    });
    
    return userAction;
}


- (void)skylineEvent:(NSString *)eventName
{
    [FSEventAction skylineEvent:eventName attributes:nil];
}

- (void)skylineEvent:(NSString *)eventName attributes:(NSDictionary *)attributes
{
    [FSEventAction skylineEvent:eventName attributes:attributes];
}

@end
