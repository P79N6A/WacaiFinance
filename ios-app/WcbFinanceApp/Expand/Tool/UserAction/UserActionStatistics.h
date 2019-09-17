//
//  UserActionStatistics.h
//  wacai365
//
//  Created by wacai on 13-11-19.
//  Copyright (c) 2013年 wacai365. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UserAction [UserActionStatistics sharedInstance]
 
@interface UserActionStatistics : NSObject

+ (UserActionStatistics*)sharedInstance;

- (void)skylineEvent:(NSString *)eventName;
- (void)skylineEvent:(NSString *)eventName attributes:(NSDictionary *)attributes;

@end
