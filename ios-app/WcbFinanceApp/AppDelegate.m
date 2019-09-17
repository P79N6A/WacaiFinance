//
//  AppDelegate.m
//  licai
//
//  Created by wac on 14-5-9.
//  Copyright (c) 2014年 com.wacai.licai. All rights reserved.
//

#import "AppDelegate.h"
#import "FinNotificationManager.h"
#import "WCALogging.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AppDelegate+FinanceSDK.h"
#import "FSRootViewController.h"
#import "EnvironmentInfo.h"
#import "AppDelegate+ServiceSDK.h"
#import "SDWebImageDownloader.h"
#import "FSTabbarData.h"

#import "NSDate+CMConvert.h"
#import "FSPopupUtils.h"
#import "KLCPopup.h"

#import "FSGestureLockViewController.h"
#import "FXBlurView.h"
#import "FSTabbarController.h"
#import "FSStringUtils.h"
#import <DFDeviceFingerPrintCollector/DFDeviceFingerPrintCollector.h>
#import <CMService/CMSPushIDRegister.h>
#import "FSTouchIDHelper.h"
#import "FSWelcomeSlidesViewController.h"
#import "CMSUserActivate.h"
#import "AppDelegate+PlanckConfig.h"
#import "WCAEvent.h"
#import "CMSPushConfig.h"
#import "CMSDKManager.h"
#import "LRCenterManager.h"
#import <PINCache/PINCache.h>
#import "LRHistoryUserManager.h"
#import "AppDelegate+FSConfig.h"
#import "FSHTTPDNSWhiteListManager.h"
#import "AppDelegate+BasicService.h"
#import <i-Finance-Library/FSSDKGotoUtility.h>



NSString *const kPushLinkUrl = @"pushLinkUrl";

@interface AppDelegate () {
    long long mLastLocalPasswordUnlockTime;
}

@property (nonatomic, assign) NSUInteger launchCount;
@property (nonatomic, strong) FXBlurView *blurView;/**< 毛玻璃View */
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) CMSPushIDRegister *pushIdRegister;
@property(nonatomic, assign) BOOL isColdLaunch;

@property (nonatomic, assign) CFTimeInterval launchTime;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#ifdef TestHTTPDNS
    //[self redirectNSlogToDocumentFolder];
#endif
    
    _launchTime = CACurrentMediaTime();

    //显示statuabar
    [application setStatusBarHidden:NO];
    //NavigationBar 设置为不透明避免布局遮挡
    [[UINavigationBar appearance] setTranslucent:NO];
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    
    
    
    [self initAppProfile];
    [self initFinanceSDK];
    
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    _isColdLaunch = YES;
    
 
    NSLog(@" launchTime 初始化之前 :  %.3f",  CACurrentMediaTime() - self.launchTime);
    [self initHTTPDNS];
    [[FSHTTPDNSWhiteListManager sharedManager] start];
 
    [self userDataRemoval];
    [self requestTabData];
    [self initCMCore];
    [self initRNBridge];
    [self initAuth];
    [self initNeutron];
    [self initTrinity];
    // initTrinity 需在 setupOfflinePackage 之前执行
    [self initPlanck];
    [self initLogging];
 
    [self checkWebviewUserAgent];

    [self initBbs2SDK];
    [self initSocialShareSDK];
    [self initMessageCenter];
    [self initLoginRegisterSDK];
    
    [self initSkylineSDK];
    [self setupiRate];
    [self parseRouterJson];
    [self initThanaIfShould];
    
    NSLog(@" launchTime 初始化sdk耗时 :  %.3f",CACurrentMediaTime() - self.launchTime);
    
    BOOL isDebugMode = [[EnvironmentInfo sharedInstance] isDebugEnvironment];
    
    [SDK_MGR setDebugMode:isDebugMode];
    
    // push 相关设置
    [self.pushIdRegister setMAppVersionBlock:^NSString * _Nonnull{
        return Release_App_Ver;
    }];
    
    [self.pushIdRegister setMUIDBlock:^NSString * _Nullable{
        return USER_INFO.mUserUdid;
    }];
    
    
    [self.pushIdRegister setMDeviceIDBlock:^NSString * _Nonnull{
        return [CMAppProfile sharedInstance].mDeviceID;
    }];
    CMS_PUSH_CONFIG.isDebugMode = isDebugMode;
    if (isDebugMode) {
        CMS_PUSH_CONFIG.requestHost = @"push-web.gongbu.k2.test.wacai.info";
    } else {
        CMS_PUSH_CONFIG.requestHost = @"blackhole.wacai.com";
    }
    CMS_PUSH_CONFIG.pushIDRegisterURLPath = @"/msg/user/pushid";
    
    // 切换用户的的时候重新上传 pushToken
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:NOTIFY_USER_SWITCHED object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        // 需要重新上传Token.
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:HadStoreDeviceToken];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //push上报开关 0 关 1 开
    
        [self.pushIdRegister userIDChanged];
      
        
    }];
 
    [self initCMMonitorSDK];
    
    //请求推送通知权限
    [self.pushIdRegister applicationRegistRemoteNotification];
    //设备指纹
    [DFDeviceFingerPrintCollector startCollect];
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    if([[[defaults dictionaryRepresentation] allKeys] containsObject:HadActive]){
        [CMSUserActivate setHasActivated:YES];
    }
    //注册用户激活
//    BOOL debug = [[EnvironmentInfo sharedInstance] currentEnvironment] != FSEnvironmentTypeOnline;
    [CMSUserActivate activateWithDebugMode:isDebugMode];

    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    if ([FSWelcomeSlidesViewController shouldShow]) {
        self.window.rootViewController = [[FSWelcomeSlidesViewController alloc] init];
    }
    else {
        [self initLastLocalPasswordUnlockTime];
        
        FSRootViewController *root  = [[FSRootViewController  alloc] init];
        self.fs_navgationController =  [[UINavigationController alloc] initWithRootViewController:root];
        self.fs_navgationController.navigationBarHidden = YES;
        
        self.window.rootViewController = self.fs_navgationController;
        
        if([self isGestureLockOn]){
            [self showGestureLock];
        }
      
    }
    
    [self.window makeKeyAndVisible];

    
    // 远程推送通知启动
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    [self handleNotificationWithUserInfo:userInfo];
    
    [self initHiveConfig];

    [UserAction skylineEvent:@"finance_wcb_app_enter_page"];
    
    NSLog(@" launchTime 总耗时 : %.3f", CACurrentMediaTime() - self.launchTime);

    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //获取url中含有的埋点信息
//    NSArray* lowCaseParams = @[@"actionid"];
//    NSDictionary* dicParams = [url.query CM_parseURLQueryStringLowCaseParams:lowCaseParams];
    
//    if ([[dicParams allKeys] containsObject:@"actionid"]) {
//        NSUInteger actionId = [dicParams[@"actionid"] integerValue];
//
//    }
    
    if ([SDK_MGR openURL:url fromViewController:[self.fs_navgationController topViewController]]) {
        return YES;
    }
    
    [self handlePushURL:url.absoluteString];
    
    return YES;
}
 
- (void)applicationWillResignActive:(UIApplication *)application
{
    [self updateLastLocalPasswordUnlockTime];
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self addBlurEffectWithFXBlurView];
    [[FinNotificationManager sharedInstance] delayGenPushNotification];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive  1111111 *************** ");
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self removeBlurEffectWithFXBlurView];

    if ([self shouldShowGestureLock]) {
        
        [self showGestureLock];
        
        NSLog(@"applicationWillEnterForeground 1111111 ================= ");
        [KLCPopup dismissAllPopups];
        [FSTouchIDHelper verifyTouchIDIfAppAvailableWithSuccessAction:^{
            [self dismissGestureLock];
        }];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications Related

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError device token 获取失败");
}


-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString* strDeviceToken = [[[deviceToken description]
                                 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                                stringByReplacingOccurrencesOfString:@" "
                                withString:@""];
    // 因为无法从 pushIdRegister 获取当前的 deviceToken， 保存一份，方便 debug
    NSLog(@"-----------strDeviceToken----------- %@",strDeviceToken);
    [[NSUserDefaults standardUserDefaults] setObject:strDeviceToken forKey:StoreDeviceTokenStard];
    
    [self.pushIdRegister applicationDidRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
 

}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification {
    
    [self handleNotificationWithUserInfo:notification.userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // App退到后台，收到推送消息，处理相关逻辑
    if (application.applicationState == UIApplicationStateActive) {
        return;
    }
     [self handleNotificationWithUserInfo:userInfo];
    //包含手势密码，并且不是冷启动app
    
}

- (void)invocationDetail:(NSString *)detailUrl{
    // 执行提前缓存下来的方法，等手势密码界面结束之后，立即执行这里
    [self clearAppIconBadge];
    
    if ([detailUrl CM_isValidString]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self gotoPushURL:detailUrl];
        });
    }
    
}

- (CMSPushIDRegister *)pushIdRegister
{
    if (!_pushIdRegister) {
        _pushIdRegister = [CMSPushIDRegister new];
    }
    return _pushIdRegister;
}

- (void)handleNotificationWithUserInfo:(NSDictionary *)userInfo{
    
    //    * 推送内容
    //    * userinfo: {
    //        *     aps = {
    //            *         alert = {
    //                *             body = "\U67e5\U770buserinfo\U7ed3\U6784";
    //                *         };
    //            *     };
    //        *     newsId = 50342a5b947f43599f21b9aaa2229c26;
    //        *     url = "wacai://usercenter";
    //        *     ...
    //        * }
    
    if ([self isUserInfoInvalid:userInfo]) {
        return;
    }
    
    [self logNotificationWithInfo:userInfo];
    
    [self clearAppIconBadge];
 
    NSString *pushUrl  = [self pushURLFromUserInfo:userInfo];
    [self handlePushURL:pushUrl];
}

- (BOOL)isUserInfoInvalid:(NSDictionary *)userInfo {
    return (!userInfo || [userInfo count] == 0);
}

- (NSString *)nativeURLInUserInfo:(NSDictionary *)userInfo {
    //如果是 native 页面的链接，会放在 url 中
    return [userInfo fs_objectMaybeNilForKey:@"url"];
}

- (NSString *)HTTPURLInUserInfo:(NSDictionary *)userInfo {
    //如果是 http 页面的链接，会放在 detail 中
    NSString *URLString = @"";
    NSInteger nDetailType = [[userInfo valueForKey:@"detail_type"] intValue];
    if (nDetailType == 0) {
        URLString = [userInfo valueForKey:@"detail"];
    }
    return URLString;
}

- (NSString *)pushURLFromUserInfo:(NSDictionary *)userInfo {
    /*
     服务端推送的格式存在 BUG：
     如果是 native 页面的链接，会放在 url 中
     如果是 http 页面的链接，会放在 detail 中
     */
    NSString *pushURL = @"";
    NSString *URLString = [self nativeURLInUserInfo:userInfo];
    if ([URLString CM_isValidString]) {
        pushURL = URLString;
    } else {
        NSString *detailURLString = [self HTTPURLInUserInfo:userInfo];
        if ([detailURLString CM_isValidString]) {
            pushURL = detailURLString;
        }
    }
    return pushURL;
}

- (void)handlePushURL:(NSString *)URL {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![URL CM_isValidString]) {
            return;
        }
        if ([self isGestureLockVCShowing]) {
            // 如果此时展示手势密码界面，延迟处理跳转
            [self savePushUrl:URL];
        }else{
            [self gotoPushURL:URL];
        }
    });
}

- (void)clearAppIconBadge {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)logNotificationWithInfo:(NSDictionary *)userInfo {
    
    NSString *newsId   = [userInfo fs_objectMaybeNilForKey:@"newsId"];
    
    WCAEvent *event  = [[WCAEvent alloc] init];
    event.eventName  = @"PushReceiveSuccess";
    if ([newsId CM_isValidString]) {
        event.attributes = @{@"newsId":newsId};
    }
    [WCALogging logEvent:event];
    
}

- (void)gotoPushURL:(NSString *)URLString {
    FSTabbarController *tabbarController = [self.fs_navgationController.viewControllers firstObject];
    [FSSDKGotoUtility openURL:URLString from:tabbarController];
}

#pragma mark - BlurView Related
- (void)addBlurEffectWithFXBlurView {
    // 创建毛玻璃效果View，通过第三方库FXBlurView
    if ([self isGestureLockOn] && ![FSStringUtils hasClickForgetBtn]) {
        if (![self existLimit]) {
            self.blurView.alpha = 1;
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.blurView];
        }
        
    }
    
}

- (void)removeBlurEffectWithFXBlurView {
    // 移除毛玻璃效果View，配合addBlurEffectWithFXBlurView使用
    if ([self isGestureLockOn] && ![FSStringUtils hasClickForgetBtn]) {
        if (![self existLimit]) {
            self.blurView.alpha = 1;
            [UIView animateWithDuration:0.5 animations:^{
                self.blurView.alpha = 0;
            } completion:^(BOOL finished) {
                [self.blurView removeFromSuperview];
            }];
        }
    }
}

/**
 *  手势限制，已经输错5次
 *
 *  @return 是否显示重新登录按钮
 */
- (BOOL)existLimit{
    NSString *limitDateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentDateLimit"];
    BOOL isExist = [limitDateStr isEqualToString:[FSStringUtils currentDateString]];
    return isExist;
}

- (FXBlurView *)blurView {
    if (!_blurView) {
        _blurView = [[FXBlurView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _blurView.blurRadius = 30.;// 模糊度
        _blurView.dynamic = NO;
        _blurView.tintColor = [UIColor clearColor];
    }
    return _blurView;
}

#pragma mark - Gesture Related
- (void)showGestureLockIfShould {
    if ([self shouldShowGestureLock]) {
        [self showGestureLock];
    }
}

- (void)showGestureLock {
    FSGestureLockViewController *lock = [[FSGestureLockViewController alloc] init];
    lock.type = FSGestureLockTypeNone;
    
    [self.fs_navgationController pushViewController:lock animated:NO];
    [self updateLastLocalPasswordUnlockTime];
}

- (BOOL)shouldShowGestureLock {
    if ([FSWelcomeSlidesViewController shouldShow]) {
        return NO;
    }
    
    if(![self isGestureLockOn]){
        return NO;
    }
    
    if ([self isGestureLockVCShowing]) {
        return NO;
    }
    
    if (![self hasReachGestureLockTime]) {
        return NO;
    }
    
    return YES;
}

// 手势密码解锁成功，隐藏视图
- (void)dismissGestureLock {
    
    [self.fs_navgationController popViewControllerAnimated:YES];
    
    NSString *pushUrl = [self pushUrl];
    
    if ([pushUrl CM_isValidString]) {
        [self invocationDetail:pushUrl];
    }
    
    [self removePushUrl];
    
    if (_isColdLaunch) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kGestureUnlockSuccessNotification" object:nil];
    }
    _isColdLaunch = NO;
}

- (BOOL)isGestureLockOn{
    NSString *savedGesturePassword = [[NSUserDefaults standardUserDefaults] objectForKey:[FSStringUtils getPasswordKey]];
    return [savedGesturePassword CM_isValidString];
}

- (BOOL)isGestureLockVCShowing{
    //当前是否在展示手势密码界面，用于防止重复弹出/阻塞必要流程
    __block BOOL isShowing  = NO;
    [self.fs_navgationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *viewController = (UIViewController *)obj;
        if ([viewController isKindOfClass:[FSGestureLockViewController class]]) {
            isShowing = YES;
            *stop = YES;
        }
    }];
    return isShowing;
}

#pragma mark - LastLocalPasswordUnlockTime Related
- (void)initLastLocalPasswordUnlockTime {
    mLastLocalPasswordUnlockTime = 0;
}

- (void)updateLastLocalPasswordUnlockTime {
    mLastLocalPasswordUnlockTime = [NSDate  CM_nowTimeIntervalSince1970];
}

- (BOOL)isLastLocalPasswordUnlockTimeValid {
    //mLastLocalPasswordTime的初始化值为0 处理首次设置手势密码时该值不存在的情况
    return mLastLocalPasswordUnlockTime > 0;
}

- (BOOL)hasReachGestureLockTime {
    NSLog(@"-------------passTime---------  %lld",mLastLocalPasswordUnlockTime);
    if ([self isLastLocalPasswordUnlockTimeValid]) {
        long long passTime = [NSDate CM_nowTimeIntervalSince1970] - mLastLocalPasswordUnlockTime;
        BOOL hasReachTime = (passTime > 60.);
        return hasReachTime;
    } else {
        return NO;
    }
}

//点击闪屏图片的跳转
- (void)launchSplashUrl:(NSString *)linkUrl{
    
    if(![linkUrl CM_isValidString]){
        return;
    }
    
    if ([self isGestureLockOn]) {
        [self savePushUrl:linkUrl];
    } else {
        [self invocationDetail:linkUrl];
    }
    
}

#pragma mark - PushURL Related
/*
 保存推送跳转url
 */
- (void)savePushUrl:(NSString *)url{
    if([url CM_isValidString]){
        [[PINCache sharedCache] setObject:url forKey:kPushLinkUrl];
    }
}
/*
 获取已经保存的跳转url
 
 */
- (NSString *)pushUrl{
    return  [[PINCache sharedCache] objectForKey:kPushLinkUrl];
}
/*
 删除保存的跳转url
 
 */
- (void)removePushUrl{
    [[PINCache sharedCache] removeObjectForKey:kPushLinkUrl];
}


// 将NSlog打印信息保存到Document目录下的文件中
- (void)redirectNSlogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"aaa.log"];// 注意不是NSData!
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    // 先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

@end
