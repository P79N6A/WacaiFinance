//
//  FSHiveConfigEvent.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/12/26.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSHiveConfigEvent.h"
#import <FSThana/FSThana.h>

@implementation FSHiveConfigEvent

+ (void)hiveConfigEvent:(NSString *)key errorType:(FSHiveConfigErrorType)errorType
{
    if(key.length == 0)
    {
        return;
    }
    
    NSString *typeString = @"";
    if (errorType == FSHiveConfigErrorTypeNet) {
        typeString = @"net_error";
    } else if (errorType == FSHiveConfigErrorTypeData) {
        typeString = @"config_error";
    }
    
    NSDictionary *params = @{@"lc_error_key":key,
                             @"lc_error_type":typeString};
    
    [[UserActionStatistics sharedInstance] skylineEvent:@"finance_wcb_hive_error" attributes:params];
    NSString *thangLog = [NSString stringWithFormat:@"hiveConfig_%@_%@", key, typeString];
    [FSThana log:thangLog];
}

@end
