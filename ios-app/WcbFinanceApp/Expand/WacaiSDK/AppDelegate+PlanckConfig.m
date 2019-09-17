//
//  AppDelegate+PlanckConfig.m
//  FinanceApp
//
//  Created by xingyong on 12/01/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import "AppDelegate+PlanckConfig.h"
#import "CMSDKManagerConfigModel.h"
#import "FSThemeMiddleware.h"
#import "FSLoginMiddleware.h"
#import "FSExamMiddleware.h"
#import "FSNeedLoginMiddleware.h"
#import "FSShareMiddleware.h"
#import "FSGobackMiddleware.h"
#import "FSBBSMiddleware.h"
#import "FSNavOnGoBackMiddleWare.h"
#import "TPKLifecycleMiddleware.h"
#import "FSPasswordMiddleware.h"
#import "FSLoadingMiddleware.h"
#import "FSErrorMiddleware.h"
#import "FSWeChatActionMiddleware.h"
#import "FSFaceIDMiddleware.h"

#import <i-Finance-Library/FSLocationMiddleware.h>
#import <i-Finance-Library/FSTakePhotoMiddleware.h>

#import <PlanckOfflineInit/PlanckOfflineInit.h>
#import <Planck/TPKWebviewSDK.h>



@implementation AppDelegate (PlanckConfig)

- (void)initPlanck {
    [self setupCMSDKManager];   // 关联 CMSDKManager & Planck
    [self registerMiddlewares]; // 注册 Middleware & JSBridge
    [self setupOfflinePackage]; // 启用 Planck 离线包支持
}

- (void)setupCMSDKManager {
    CM_SDK_MANAGER_CONFIG.usingPlanckWebview = YES;
    CM_SDK_MANAGER_CONFIG.createPlanckWebViewBlock = ^(NSDictionary *params){
        return [[TPKWebViewController alloc] initWithURLString:[params CM_stringForKey:@"urlString"]];
    };
}

- (void)setupOfflinePackage {
    [PlanckOfflineInit setup];
}

#pragma mark - Middleware & JSBridge

- (void)registerMiddlewares {
    [self registerDefaultMiddleware];   // 初始化内置 Middleware & JSBridge
    [self registerFinanceMiddleware];   // 注册理财 Middleware
}

- (void)registerDefaultMiddleware {
    [TPKWebviewSDK initialization];
}

- (void)registerFinanceMiddleware {
    TPKMiddleWareWrapper *wrapper = [TPKMiddleWareWrapper sharedInstance];
    TPKWebviewDomain *defaultDomain = [TPKWebviewDomain domainWithHost:@"*" path:nil];
    // JSBridge
    [wrapper registerMiddleWare:[FSNavOnGoBackMiddleWare new] InDomain:defaultDomain];
    [wrapper registerMiddleWare:[FSLoginMiddleware new] InDomain:defaultDomain];
    [wrapper registerMiddleWare:[FSPasswordMiddleware new] InDomain:defaultDomain];
    [wrapper registerMiddleWare:[FSWeChatActionMiddleware new] InDomain:defaultDomain];
    [wrapper registerMiddleWare:[FSTakePhotoMiddleware new] InDomain:defaultDomain];
    [wrapper registerMiddleWare:[FSLocationMiddleware new] InDomain:defaultDomain];
    // Middleware
    [wrapper registerMiddleWare:[FSErrorMiddleware new] InDomain:defaultDomain];
    [wrapper registerMiddleWare:[FSLoadingMiddleware new] InDomain:defaultDomain];
    [wrapper registerMiddleWare:[TPKLifecycleMiddleware new] InDomain:defaultDomain];
    [wrapper registerMiddleWare:[FSBBSMiddleware new] InDomain:defaultDomain];
    [wrapper registerMiddleWare:[FSGobackMiddleware new] InDomain:defaultDomain];
    [wrapper registerMiddleWare:[FSThemeMiddleware new] InDomain:defaultDomain];
    [wrapper registerMiddleWare:[FSExamMiddleware new] InDomain:defaultDomain];
    [wrapper registerMiddleWare:[FSShareMiddleware new] InDomain:defaultDomain];
    [wrapper registerMiddleWare:[FSNeedLoginMiddleware new] InDomain:defaultDomain];
    [wrapper registerMiddleWare:[FSFaceIDMiddleware new] InDomain:defaultDomain];
}



@end
