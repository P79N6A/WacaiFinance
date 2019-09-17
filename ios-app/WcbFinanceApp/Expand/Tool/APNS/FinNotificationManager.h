//
//  FinNotificationManager.h
//  FinanceApp
//
//  Created by new on 15/1/31.
//  Copyright (c) 2015年 com.wacai.licai. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  主要是处理远程Push与本地Notification.
 *
 */

@interface FinNotificationManager : NSObject

+ (FinNotificationManager*)sharedInstance;

// 参数isDelayLaunch: 是否是在延迟执行启动时就应该执行的launch option.
- (void)parserNotification:(NSDictionary*)userInfo isDelayLaunch:(BOOL)isDelayLaunch;

// 如果在应用程序前台收到消息，则在进入后台时生成本地Push.
- (void)delayGenPushNotification;

- (void)handle:(NSDictionary*)userInfo;

@end
