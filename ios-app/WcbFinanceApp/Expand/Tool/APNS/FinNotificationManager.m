//
//  FinNotificationManager.m
//  FinanceApp
//
//  Created by new on 15/1/31.
//  Copyright (c) 2015年 com.wacai.licai. All rights reserved.
//

#import "FinNotificationManager.h"
#import "AppDelegate.h"
#import "FSTabbarController.h"
#import <i-Finance-Library/FSSDKGotoUtility.h>
#define WacNotifKeyURL @"url"

#define LOCAL_PUSH_NOTIFYACTION_DEFAY_SECONDS 600

typedef enum {
    kPushDetailOpenURL = 0,//打开一个网页
}PushDetailType;

@interface FinNotificationManager ()

// 当应用在前台接收到push时，把push中得userInfo信息保存进mDelayPushArray，以便于应用退后台时把push注册进本地消息中心
@property (nonatomic, strong) NSMutableArray* mDelayPushArray;

@end

@implementation FinNotificationManager

@synthesize mDelayPushArray;

+ (FinNotificationManager*)sharedInstance {
    static FinNotificationManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        mDelayPushArray = [NSMutableArray array];
    }
    return self;
}

- (void)parserNotification:(NSDictionary*)userInfo isDelayLaunch:(BOOL)isDelayLaunch {
    if (!isDelayLaunch && UIApplicationStateActive == [UIApplication sharedApplication].applicationState) {
        NSLog(@"Receive notification while active");
        if (nil != userInfo) {
            [mDelayPushArray addObject:userInfo];
        }
    } else {
        NSLog(@"Receive notification while background");
         
        [self handle:userInfo];
    }
}

- (void)handle:(NSDictionary*)userInfo {
    if (nil == userInfo) {
        return;
    }
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    UITabBarController *rootTabBar =(UITabBarController *)delegate.mRootViewController;
    UINavigationController *nav = delegate.fs_navgationController;
    
    //跳转应用内界面,关于wacai跳转的
    NSString* strURL = [userInfo CM_stringForKey:WacNotifKeyURL];
    if ([strURL CM_isValidString]) {
//        NSURL* wacaiURL = [self safeURLWithString:strURL];
//        if ([FINANCE_OPEN isValidateSchema:wacaiURL]) {
//            [FINANCE_OPEN openURL:wacaiURL];
//        }
//        else {
//            [self jumpToWebView:strURL];
//        }
        
        [FSSDKGotoUtility openURL:strURL from:nav];
        return;
    }
    
    // 弹出一个web页面
    PushDetailType nDetailType = [userInfo CM_intForKey:@"detail_type"];
    if (nDetailType == kPushDetailOpenURL) {
        NSString* httpURL = [userInfo CM_stringForKey:@"detail"];
        if ([httpURL CM_isValidString]) {
//            [self jumpToWebView:httpURL];
            
            [FSSDKGotoUtility openURL:httpURL from:nav];
            return;
        }
    }
}

//- (void) jumpToWebView:(NSString*) strURL {
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    UITabBarController *rootTabBar =(UITabBarController *)delegate.mRootViewController;
//    UINavigationController *nav = (UINavigationController *)rootTabBar.selectedViewController;
//    [FinSDKOpen openUrl:strURL byController:nav.visibleViewController];
//}

- (void)delayGenPushNotification {
    for (NSDictionary *userInfo in mDelayPushArray) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:LOCAL_PUSH_NOTIFYACTION_DEFAY_SECONDS];
        notification.fireDate = pushDate;
        notification.soundName = UILocalNotificationDefaultSoundName;
        /*
         * 推送内容
         * userinfo: {
         *     aps = {
         *         alert = {
         *             body = "\U67e5\U770buserinfo\U7ed3\U6784";
         *         };
         *     };
         *     newsId = 50342a5b947f43599f21b9aaa2229c26;
         *     url = "wacai://usercenter";
         *     ...
         * }
         */
        NSLog(@"%@",userInfo);
        NSString *body = ((userInfo[@"aps"])[@"alert"])[@"body"];
        notification.alertBody = body;
        notification.userInfo = userInfo;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    [mDelayPushArray removeAllObjects];
}

#pragma mark -- Helper Methods

- (NSURL*)safeURLWithString:(NSString *)URLString {
    NSURL* retURL = [NSURL URLWithString:URLString];
    if (retURL == nil) {
        NSString* encodeURLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        retURL = [NSURL URLWithString:encodeURLString];
    }
    
    return retURL;
}

@end
