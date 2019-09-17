//
//  FinNotificationBody.m
//  FinanceApp
//
//  Created by new on 15/1/31.
//  Copyright (c) 2015年 com.wacai.licai. All rights reserved.
//

#import "FinNotificationBody.h"

@implementation FinNotificationBody

@synthesize mNotifyTitle;
@synthesize mNotifyUrl;

- (instancetype)initWithDic:(NSDictionary*)dic {
    self = [self init];
    if (self) {
        self.mNotifyTitle = [dic objectForKey:@"title"];
        self.mNotifyUrl = [dic objectForKey:@"url"];
    }
    
    return self;
}

@end
