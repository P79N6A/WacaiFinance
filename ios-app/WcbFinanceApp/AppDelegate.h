//
//  AppDelegate.h
//  licai
//
//  Created by wac on 14-5-9.
//  Copyright (c) 2014年 com.wacai.licai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

extern NSString *const kPushLinkUrl;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;


@property (nonatomic, strong) UINavigationController *fs_navgationController;


- (void)showGestureLockIfShould;
- (void)dismissGestureLock;
- (void)launchSplashUrl:(NSString *)linkUrl;

@end
