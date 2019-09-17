//
//  AppDelegate+FSConfig.m
//  WcbFinanceApp
//
//  Created by 叶帆 on 25/01/2018.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "AppDelegate+FSConfig.h"
#import "FSiRateDelegate.h"
#import "CustomiRate.h"
#import <FSRouter.h>
#import <LRCenterManager.h>

@implementation AppDelegate (FSConfig)

- (void)setupiRate {
    [CustomiRate sharedInstance].appStoreID = APP_ID_STORE;
    [CustomiRate sharedInstance].messageTitle = @"喜欢我，就来评分呗！";
    [CustomiRate sharedInstance].message = @"亲爱的财主，最新版挖财宝怎么样？\n如果还行，就点个赞吧！";
    [CustomiRate sharedInstance].rateButtonLabel = @"我要点赞";
    [CustomiRate sharedInstance].remindButtonLabel = @"我要吐槽";
    [CustomiRate sharedInstance].cancelButtonLabel = @"多用用再说";
    [CustomiRate sharedInstance].daysUntilPrompt = 7; //第一次弹窗在使用7天后
    [CustomiRate sharedInstance].usesUntilPrompt = 3;
    [CustomiRate sharedInstance].usesPerWeekForPrompt = 3;
    [CustomiRate sharedInstance].remindPeriod = 7; //弹窗间隔7天
    [CustomiRate sharedInstance].promptAtLaunch = NO; //启动 App 不自动弹，手动控制
    [CustomiRate sharedInstance].promptForNewVersionIfUserRated = YES; //上个版本评论过，下个版本继续弹
    [CustomiRate sharedInstance].useUIAlertControllerIfAvailable = YES;
    [CustomiRate sharedInstance].delegate = [FSiRateDelegate shareInstance];
}

//为了兼容服务窗，服务窗使用CMUIWebView，打开邀请好友需要从UA里面获取版本号
-(void)checkWebviewUserAgent {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableString *userAgentString = [[[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"] mutableCopy];
        [self appendUserAgentFiledIfNeededInUserAgent:userAgentString forFiled:@"wacai" value:[CMAppProfile sharedInstance].mAppVersion];
        [self appendUserAgentFiledIfNeededInUserAgent:userAgentString forFiled:@"platform" value:[CMAppProfile sharedInstance].mPlatform];
        [self appendUserAgentFiledIfNeededInUserAgent:userAgentString forFiled:@"mc" value:[CMAppProfile sharedInstance].mMarketCode];
        
        //这里
        NSString *nettype = nil;
        switch ([CMAppProfile sharedInstance].mNetworkStatus) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                nettype = @"wifi";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                nettype = @"3g";
                break;
            default:
                break;
        }
        
        if (nettype) {
            [self appendUserAgentFiledIfNeededInUserAgent:userAgentString forFiled:@"net" value:nettype];
        }
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"UserAgent" : userAgentString }];
    });
}

-(void)appendUserAgentFiledIfNeededInUserAgent:(NSMutableString *)userAgent forFiled:(NSString *)filed value:(NSString *)value {
    if (![userAgent containsString:filed]) {
        [userAgent appendString:[NSString stringWithFormat:@" %@/%@",filed,value]];
    }
}

#pragma mark - 解析本地路由数据
- (void)parseRouterJson {
    NSError*error = nil;
    //获取文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FSFinanceRouter"ofType:@"json"];
    //根据文件路径读取数据
    NSData *jdata = [NSData dataWithContentsOfFile:filePath];
    //格式化成json数据
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jdata options:kNilOptions error:&error];
    if (!error) {
        for (NSDictionary * dic in  jsonObject) {
            NSString *patterns = [dic fs_objectMaybeNilForKey:@"route"];
            NSString *className = [dic fs_objectMaybeNilForKey:@"viewcontroller"];
            if([className length]) {
                Class class = NSClassFromString(className);
                [[FSRouter sharedInstance] map:patterns toControllerClass:class];
            }
        }
    }
}

- (void)userDataRemoval {
    //用户数据迁移
    if ([USER_INFO.token length]) {
        
        
        if ([[LRCenterManager sharedInstance].mRuntimeUser.mToken length] <= 0) {
            LRLoginUser *loginUser = [LRLoginUser new];
            loginUser.mToken = USER_INFO.token;
            loginUser.mRefreshToken = USER_INFO.refreshToken;
            loginUser.mUserId = USER_INFO.mUserId;
            loginUser.mEmailAddress = USER_INFO.mUserEmail;
            loginUser.mMobilePhoneNumber = USER_INFO.mUserPhone;
            loginUser.mNickName = USER_INFO.mNickName;
            loginUser.mUid = USER_INFO.mUserUdid;
            [[LRCenterManager sharedInstance] updateRuntimeUser:loginUser];
        }
    }
}

- (void)requestTabData {
    [[FSRequestManager manager] getRequestURL:fs_productTab
                                   parameters:nil
                                      success:^(FSResponseData *response, id responseDic) {
                                          
                                      } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                          
                                      }];
}

@end
