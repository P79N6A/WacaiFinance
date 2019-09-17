//
//  AppDelegate+ServiceSDK.m
//  FinanceApp
//
//  Created by xingyong on 10/13/15.
//  Copyright © 2015 com.wacai.licai. All rights reserved.
//

#import "AppDelegate+ServiceSDK.h"
#import "SocialShareSDK.h"
#import "CMOOP.h"
#import "SocialShareSDK.h"
#import "EnvironmentInfo.h"
#import "WCAnalytics.h"
#import "FSOriginalLoginViewController.h"
#import "FSTabbarController.h"
#import "FSGotoUtility.h"
#import "FSPageController.h"
#import "LoginRegisterSDK.h"
#import "LKDBHelper.h"
#import "MessageCenterSDK.h"
#import <CMMonitor.h>

#import <RNBridge/RNBReactCommonSDK.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "CMCoreContext.h"
#import "CMCoreContextInfo.h"
#import "CMUIConfig.h"
#import <BBSCore/BBSSDKConfigModel.h>
#import <BBSCore/BBSHostURLSwitch.h>
#import <SdkBbs2/BBSSDK.h>
#import <FSSDKBaseViewController.h>
#import <Skyline/Skyline.h>
#import <NeutronBridge/NeutronBridge.h>
#import "FSAccountSettingsHandler.h"
#import <FSThana/FSThana.h>
#import <FSHTTPDNS.h>
#import <CMNetKit.h>
#import "FSHTTPDNSReporter.h"
#import <SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>
#import "FSHTTPDNSWhiteListManager.h"
#import <FSHiveConfig/FSHCManager.h>
#import <Neutron/TNTInvoker.h>
#import <SdkUser/LRCenterManager.h>

static NSString *const servicePhoneNumber = @"400-711-8718";

@implementation AppDelegate (ServiceSDK)

- (void)initThanaIfShould {
 
#ifdef kTestAppURL
    
    FSThana *thana = [FSThana sharedInstance];
    thana.enable = YES;
    thana.debugMode = YES;
    
#else
    
    
    BOOL shouldInitThana = [[TNTInvoker sharedInvoker] canInvokeUsingURL:[NSURL URLWithString:@"nt://WcbFinanceApp/open-thana"]];
    if (!shouldInitThana) { return; }
    FSThana *thana = [FSThana sharedInstance];
    thana.enable = YES;
    thana.debugMode = NO;
    
#endif
    
}


- (void)initAppProfile{
    [[CMAppProfile sharedInstance] setMPlatform:@"40"];
    
    [CMAppProfile sharedInstance].mAppCode = 3;
     
    [CMAppProfile sharedInstance].mPushIDBlock = ^NSString*{
        NSString *pushId = [[NSUserDefaults standardUserDefaults] objectForKey:StoreDeviceTokenStard];
        return SafeString(pushId);
    };
 
    [CMAppProfile sharedInstance].mTokenIDBlock = ^NSString*{
        return SAFE_STRING(LRManager.mRuntimeUser.mToken);
        
    };
    [CMAppProfile sharedInstance].mRefreshTokenIDBlock = ^NSString*{
        return SAFE_STRING(LRManager.mRuntimeUser.mRefreshToken);
    };
    [CMAppProfile sharedInstance].mUserIDBlock = ^NSString*{
        return SAFE_STRING(LRManager.mRuntimeUser.mUserId);
    };
    [CMAppProfile sharedInstance].mUIDBlock = ^NSString*{
        return SAFE_STRING(LRManager.mRuntimeUser.mUid);
    };
    
}

//初始化莲子埋点
- (void)initLogging{
    /*初始化埋点*/
    WCALoggingConfiguration * loggingConfiguration = [[WCALoggingConfiguration alloc] init];
    //需要被统计页面埋点的类，必须是UIViewController的子类
    loggingConfiguration.autoLoggingPageEventVCClasses = @[[CMUIViewController class],
                                                           [FSBaseViewController class],
                                                           [FSTabbarController class],
                                                           [FSPageController class],
                                                           [BBSBasicViewController class],
                                                           [FSSDKBaseViewController class]
                                                           ];
    //莲子key
    loggingConfiguration.lotuseedKey = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeLotusseedKey];
    
    loggingConfiguration.skylineEnabled = NO;
#ifdef kTestAppURL
    loggingConfiguration.debugMode = YES;
    loggingConfiguration.enableQALogging = YES;
#endif
    //32位用户id
    
    loggingConfiguration.userIDWithBolck = ^NSString *(void){
        // 不登录也是有值的
        return SAFE_STRING([LRLoginUser getRuntimeUser].mUserId);
    };
    
    
    //设备id
    loggingConfiguration.deviceID = SAFE_STRING([CMAppProfile sharedInstance].mDeviceID);
    //渠道号
    loggingConfiguration.channelID = @([CMAppProfile sharedInstance].mChannelType).stringValue;
    
    //初始化
    [WCALogging enableLoggingUsingConfiguration:loggingConfiguration];
}


- (void)initCMMonitorSDK {
    
    CM_CONTEXT.mLKDBHelper = [[LKDBHelper alloc] init];
    [CM_CONTEXT.mLKDBHelper createTableWithModelClass:[CMNetworkTransaction class]];
 
    CMMonitorConfig *config = [CMMonitorConfig  sharedConfig];
    config.trackingCrashOnDebug = NO;
    config.monitorType = CMMonitorTypeAll;
    [[CMMonitorManager sharedManager] startMonitorWithConfig:config];
    
}


- (void)initCMCore{

    FSEnvironmentType currentEnvironmentType = [[EnvironmentInfo sharedInstance] currentEnvironment];
    CM_CONTEXT.mIsTestMode = !(currentEnvironmentType == FSEnvironmentTypeOnline);
    
    [CM_CONTEXT setWithBlock:^(CMCoreContextInfo *info) {
        info.mMainWindow = self.window;
        info.mDeviceID = [CMAppProfile sharedInstance].mDeviceID;

    }];
 
    CMUIConfig* config = CM_UI_CONFIG;
    config.navigationBarTextColor = RGBColor(255, 255, 255, 1);
    config.navigationBarTextFont = [UIFont systemFontOfSize:17.0f];
    config.navigationBarBackgroundColorForDefault = [UIColor colorWithHex:0xd84a3f];
    config.navigationBarBackgroundColorForMinor = [UIColor whiteColor];
    config.navigationBarButtonTextFont = [UIFont systemFontOfSize:16];
    config.cellSeperatorColor = RGBColor(232, 235, 237, 1);
    config.disableTextAlpha = 0.5;
    
    CM_CONTEXT.mMessagePackAuthHeaderInfo = ^NSDictionary*(void) {
        NSMutableDictionary *authInfo = [NSMutableDictionary dictionary];
        if (USER_INFO.mUserUdid.length > 0) {
            authInfo[@"X-UID"] = SAFE_STRING(USER_INFO.mUserUdid);
        }
        if (USER_INFO.mUserId.length > 0) {
 
            authInfo[@"X-USERID"] = SAFE_STRING(USER_INFO.mUserId);
        }
        authInfo[@"X-ACCESS-TOKEN"] = SAFE_STRING(USER_INFO.token);
        authInfo[@"X-PLATFORM"] = SAFE_STRING([CMAppProfile sharedInstance].mPlatform);
        authInfo[@"X-APPVER"] = Release_App_Ver;
        authInfo[@"X-MC"] = @([CMAppProfile sharedInstance].mChannelType).stringValue;
        authInfo[@"X-DEVICEID"] = SAFE_STRING([CMAppProfile sharedInstance].mDeviceID);
        return authInfo;
    };
    
    [CM_CONTEXT setMHttpConnectHandleErrorCode: ^(NSInteger errorCode) {
        if (errorCode == 5005 || errorCode == 5004) {
            [CMUIDisappearView showMessage:@"登录已失效,请重新登录"];
            [USER_INFO logout];
        }
    }];
    
    CM_CONTEXT.mUserAgent = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserAgent"];
    
  
    
}


# pragma mark - RNBridge
- (void)initRNBridge {
//    [[RNBReactCommonSDK sharedSDK] setDebugging:YES];
    [[RNBReactCommonSDK sharedSDK] setupConfigurationWithFetchMode:RNBBundleFetchModeApplicationRunning andFetchInterval:30 * 60];
    
    
}


# pragma mark - SocialShareSDK
- (void)initSocialShareSDK
{
    [SDK_MGR registSDK:SOCIALSHARESDK];
    
    [SocialShareSDK setWeiboAppKey:kSinaWeiboAppKey
                         appSecret:kSinaWeiboAppSecret
                       redirectURI:kSinaWeiboAppRedirectURI
                       weiboUserID:@"1741280725"];
    
    [SocialShareSDK setWeChatAppID:kWeChatAppKey
                         appSecret:kWeChatSecert 
                       redirectURI:kTencentWeiboAppRedirectURI];
    
    [SocialShareSDK setTencentAppID:kTencentQQAppKey];
    
    UIImage *shareImage = [UIImage imageNamed:@"share-icon@3x.png"];
    
    [SOCIALSHARESDK setShareImage:shareImage];
}


- (void)initBbs2SDK
{
    BBSSDKConfigModel *model = [BBSSDKConfigModel new];
#ifdef kTestAppURL
    model.mHostType = kBBSHostURLSwitchTest;
#else
    model.mHostType = kBBSHostURLSwitchFormal;
#endif

    model.isQiantangApp = NO;
    [[BBSSDK sharedInstance] initializeSDKWithConfigModel:model];

    [SDK_MGR registSDK:[BBSSDK sharedInstance]];
}


- (void)initMessageCenter
{
 
    [SDK_MGR registSDK:MESSAGECENTER_SDK];
}

- (void)initLoginRegisterSDK {
    LRConfigModel *configModel = [[LRConfigModel alloc] init];
    // UI 配置
    configModel.mBackButton = ^() {
        UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        [returnBtn setImage:[UIImage imageNamed:@"ico_arrow_left"] forState:UIControlStateNormal];
        [returnBtn setTitle:@"返回" forState:UIControlStateNormal];
        returnBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [returnBtn setTitleColor:RGBColorHex(0x00a8ff) forState:UIControlStateNormal];
        [returnBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        return returnBtn;
    };
    configModel.mNavigationBarUIControl = ^(CMUIViewController *vc) {
        [vc setNaviBarColor:[UIColor whiteColor]];
        [vc setStatusBarStyle:UIStatusBarStyleLightContent];
        [vc setTitleColor:[UIColor blackColor]];
    };
    // 设置token过期的处理
    configModel.tokenInvalidCallBack = ^BOOL(NSInteger errorCode) {
        if (errorCode == 5004 || errorCode == 5005) {
            // Response Header 的 X-Result-Code 兜底处理，防止弹出用户中心重登录界面。
            // 由于该形式非理财接口的约定，不确定所有场景，因此静默处理，防止发生冲突。
            [USER_INFO logout];
            return YES;
        } else {
            return NO;
        }
    };
    // 登录、登出事件处理
    configModel.logoutBlock = ^{
        [USER_INFO logout];
    };
    
    [LoginRegisterSDK setLoginSuccessListener:^(LRLoginUser * _Nonnull user, BOOL isRelogin) {
        [USER_INFO updateUserInfo:user];
    }];
    
    
    [LoginRegisterSDK loadLoginRegisterWithConfig:configModel];
    [SDK_MGR registSDK:[LoginRegisterSDK loginRegisterSDK]];
}

- (void)initSkylineSDK
{
    
    //正式服 https://moblog.wacai.com/sensor/sa?project=finance
    //测试服 http://sensordata.staging.wacai.info/sensor/sa?project=skyline
    NSString *url = @"https://moblog.wacai.com/sensor/sa?project=finance";
    
    BOOL isDebugMode = NO;
    BOOL QALoggingEnabled = NO;
#ifdef kTestAppURL
    
    isDebugMode = YES;
    QALoggingEnabled = YES;
    url = @"http://sensordata.staging.wacai.info/sensor/sa?project=skyline";
#endif
    
#ifdef TestHTTPDNS
    //减少本地日志打印，便于看日志
    isDebugMode = NO;
    QALoggingEnabled = NO;
#endif
    
    SKLConfiguration *configuration = [[SKLConfiguration alloc] initWithServerURL:url isDebugMode:isDebugMode];
    
    configuration.QALoggingEnabled = QALoggingEnabled;
    configuration.appName = APP_NAME;
    
    [Skyline setupWithConfiguration:configuration];
}

- (void)initHTTPDNS
{
    [[FSDNSManager sharedInstance] start];
    
#ifdef kTestAppURL
     [[FSDNSManager sharedInstance] setDebugMode:YES];
#endif
    
    FSHTTPDNSReporter *reporter = [[FSHTTPDNSReporter alloc] init];
    [[FSDNSManager sharedInstance] setReporter:reporter];
    
//    //UIWebView, NSURLConnection
//    //[NSURLProtocol registerClass:[FSHTTPMessageProtocol class]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSArray *protocolArray = @[[FSHTTPMessageProtocol class]];
    configuration.protocolClasses = protocolArray;
    [[CMNetKitConfig sharedConfig] setSessionConfiguration:configuration];
    
}

- (void)initHiveConfig {
    HIVE_CONFIG.isDebug = [EnvironmentInfo sharedInstance].isDebugEnvironment;
}

@end
