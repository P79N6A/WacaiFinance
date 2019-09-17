//
//  FinanceCompile.h
//  FinanceApp
//
//  Created by new on 15/1/29.
//  Copyright (c) 2015年 com.wacai.licai. All rights reserved.
//

#ifndef FinanceApp_FinanceCompile_h
#define FinanceApp_FinanceCompile_h

#define FINANCE_APP_ID  3       // App Id ： 挖财 0; 钱管家 1; 挖财宝 3.

//mc
#define MARKET_MC_91 @"21000005"
#define MARKET_MC_TONGBUTUI @"21000076"
#define MARKET_MC_PP @"21000099"
#define MARKET_MC_ITUNES @"21000020"
#define MARKET_MC_ITUNES_PRO @"21000120"
#define MARKET_MC_ITUNES_HELPER @"2100001f"
#define MARKET_MC_SIKAI @"2100000c"


//渠道标示
#define CURRENT_CHANNEL MARKET_MC_ITUNES


#define kDevicePlatform   40

#define Release_App_Ver [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]


/*
 
 OK，以下是各个平台登录SDK相关信息：
 QQ互联：
 APPID：101116723
 APP KEY：700037f6db9feb6e4cb24d8f56c9b137
 
 新浪微博开放平台：
 APP KEY：873583833
 APP SECRET: 01cdaf01c6682703e57855271d4dd11a
 
 腾讯微博开放平台：
 APP KEY：801514156
 APP SECRET: 7b95419620474b5ff606f3b2d32dab4d
 */



/**
 
 系统配置。
 */

#define SinaWeiboSdkVersion                @"2.0"
#define kSinaWeiboSDKErrorDomain           @"SinaWeiboSDKErrorDomain"
#define kSinaWeiboSDKErrorCodeKey          @"SinaWeiboSDKErrorCodeKey"
#define kSinaWeiboSDKAPIDomain             @"https://open.weibo.cn/2/"
#define kSinaWeiboSDKOAuth2APIDomain       @"https://open.weibo.cn/2/oauth2/"
#define kSinaWeiboWebAuthURL               @"https://open.weibo.cn/2/oauth2/authorize"
#define kSinaWeiboWebAccessTokenURL        @"https://open.weibo.cn/2/oauth2/access_token"
#define kSinaWeiboAppAuthURL_iPhone        @"sinaweibosso://login"
#define kSinaWeiboUserInfoURL              @"https://api.weibo.com/2/users/show.json"

#define kSinaWeiboSSOScheme                @"sinaweibosso"



#define kSinaWeiboAppKey                   @"873583833"
#define kSinaWeiboAppSecret                @"01cdaf01c6682703e57855271d4dd11a"
#define kSinaWeiboAppRedirectURI           @"http://www.wacai.com"


#define TencentWeiboSdkVersion             @"2.0"
#define kTencentWeiboSDKErrorDomain        @"TCSDKErrorDomain"
#define kTencentWeiboSDKErrorCodeKey       @"TCSDKErrorCodeKey"
#define kTencentWeiboSDKAPIDomain          @"https://open.t.qq.com/api/"
#define kTencentWeiboWebAuthURL            @"https://open.t.qq.com/cgi-bin/oauth2/authorize/ios"
#define kTencentWeiboWebAccessTokenURL     @"https://open.t.qq.com/cgi-bin/oauth2/access_token"
#define kTencentWeiboUserInfoURL           @"http://open.t.qq.com/api/user/info?"

#define kTencentWeiboAppKey                @"801514156"
#define kTencentWeiboAppSecret             @"7b95419620474b5ff606f3b2d32dab4d"
#define kTencentWeiboAppRedirectURI        @"http://www.wacai.com"

#define kTencentQQSDKAPIDomain             @"https://graph.qq.com/api/"
#define kTencentQQWebAuthURL               @"https://graph.qq.com/oauth2.0/authorize"
#define kTencentQQWebAccessTokenURL        @"https://graph.qq.com/oauth2.0/token"
#define kTencentQQUserIdURL                @"https://graph.z.qq.com/moc2/me"
#define kTencentQQAppRedirectURI           @"http://www.wacai.com"
#define kTencentQQUserInfoURL              @"https://openmobile.qq.com/user/get_simple_userinfo"

#define kTencentQQAppKey                   @"101116723"
#define kTencentQQAppSecret                @"700037f6db9feb6e4cb24d8f56c9b137"

#define kWeChatAppKey  @"wxbffe0f7eec657d7a"
#define kWeChatSecert @"5cba8c479d478a6d4d0ddd264d3c5585"//@"79b36715d5e116771e36c29ea13b2c09"

//APP id在appstore中
#define APP_ID_STORE 891192948

#define APP_DOWNLOAD_PATH @"https://itunes.apple.com/cn/app/wa-cai-bao/id891192948?mt=8"
 


#endif
