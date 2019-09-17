//
//  AppDelegate+ServiceSDK.h
//  FinanceApp
//
//  Created by xingyong on 10/13/15.
//  Copyright © 2015 com.wacai.licai. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (ServiceSDK)

/**
 *  初始化AppProfile 全局有效
 */
- (void)initAppProfile;

/**
 *  实例化分享SDK
 */
- (void)initSocialShareSDK;
/**
 *  实例化核心库
 */
- (void)initCMCore;

// 初始化钱堂sdk
- (void)initBbs2SDK;

- (void)initMessageCenter;

- (void)initLoginRegisterSDK;

/**
 初始化监控SDK
 */
- (void)initCMMonitorSDK;


- (void)initRNBridge;

- (void)initLogging;

/**
 初始化神策
*/
- (void)initSkylineSDK;

- (void)initThanaIfShould;

/**
 初始化HTTPDNS
*/
- (void)initHTTPDNS;

- (void)initHiveConfig;

 

@end
