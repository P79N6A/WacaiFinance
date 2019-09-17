//
//  FSWcbFinanceAppRouter.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/6/20.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSWcbFinanceAppRouter.h"
#import <NeutronBridge/NeutronBridge.h>
#import "AppDelegate.h"
#import "FSTabbarController.h"
#import <NativeQS/NQSParser.h>
#import <CMNSString/NSString+CMUtil.h>
#import <i-Finance-Library/FSSDKGotoUtility.h>

@implementation FSWcbFinanceAppRouter

#pragma mark - 货架
+ (UIViewController *_Nullable)financeAppH5FundShelfWithQS:(NSString *_Nullable)qs context:(TNTRoutingContext *_Nullable)context
{
    
    NSString *source = [NSString stringWithFormat:@"%@", @"nt://sdk-fund-wax/fund-shelf?wacaiClientNav=0"];
    NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:context.fromViewController];
    [ns pageForNtWithSource:source
                     onDone:^(UIViewController *vc) {
                         
                         UIViewController *tmp = vc ?: [UIViewController new];
                         
                         UIViewController *container = [[UIViewController alloc] init];
                         container.view.bounds = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                         
                         tmp.view.frame = CGRectMake(0, -FS_StatusBarHeight, ScreenWidth, ScreenHeight - FS_NavigationBarHeight + FS_StatusBarHeight - FS_TabbarHeight);
                         tmp.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
                         
                         [container addChildViewController:tmp];
                         [container.view addSubview:tmp.view];
                         
                         [tmp didMoveToParentViewController:container];
                     } onError:^(NSError * _Nullable error) {
                         
                     }];
    
    return nil;
}

+ (UIViewController *)switchToFundShelfWithQS:(NSString *)qs context:(TNTRoutingContext *)context {
    extern NSString *FSSDKHomeFindMoreFundNotification;
    [[NSNotificationCenter defaultCenter] postNotificationName:FSSDKHomeFindMoreFundNotification object:nil];
    return nil;
}

#pragma mark - 设置
+ (UIViewController *)gotoFSCustomerServiceWithQS:(NSString *)qs context:(TNTRoutingContext *)context {
    NSDictionary *params = @{
                             @"hostAddress":    @"https://help.wacai.com/help/customerCenter/common/entrance",
                             @"entranceID":     @"2003",
                             @"platform":       CM_APP_PROFILE.mPlatform
                             };
    NSString *source = [NSString stringWithFormat:@"%@?%@", @"nt://custom-center/custom-center-page", [NQSParser queryStringifyObject:params]];

    NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:context.fromViewController];
    [ns ntWithSource:source
  fromViewController:context.fromViewController
          transiaion:NTBViewControllerTransitionPush
              onDone:^(NSString * _Nullable result) {
                  NSDictionary * info = [result CM_JsonStringToDictionary];
                  NSString *url = [info CM_stringForKey:@"url"];
                  [FSSDKGotoUtility openURL:url from:[self tabBarController]];
              } onError:^(NSError * _Nullable error) {
                  
              }];
    
   
    return nil;
}

+ (UIViewController *)gotoFSAccountInfoWithQS:(NSString *)qs context:(TNTRoutingContext *)context {
    NSString *wacaifinanceURL = @"wacaifinance://accountInfo";
    [FSSDKGotoUtility openURL:wacaifinanceURL from:[self tabBarController]];
    return nil;
}


+ (UIViewController *)gotoFSBindingInfoWithQS:(NSString *)qs context:(TNTRoutingContext *)context {
    NSString *wacaifinanceURL = @"wacaifinance://bindingInfo";
    [FSSDKGotoUtility openURL:wacaifinanceURL from:[self tabBarController]];
    return nil;
}

+ (UIViewController *)gotoFSPwdManagementWithQS:(NSString *)qs context:(TNTRoutingContext *)context {
    NSString *wacaifinanceURL = @"wacaifinance://passwordManage";
    [FSSDKGotoUtility openURL:wacaifinanceURL from:[self tabBarController]];
    return nil;
}

+ (UIViewController *)gotoHelpFeedbackWithQS:(NSString *)qs context:(TNTRoutingContext *)context {
    NSString *wacaifinanceURL = @"wacaifinance://gotofaq";
    [FSSDKGotoUtility openURL:wacaifinanceURL from:[self tabBarController]];
    return nil;
}

+ (UIViewController *)gotoAboutUsWithQS:(NSString *)qs context:(TNTRoutingContext *)context {
    NSString *wacaifinanceURL = @"wacaifinance://contactUs";
    [FSSDKGotoUtility openURL:wacaifinanceURL from:[self tabBarController]];
    return nil;
}

+ (UIViewController *)gotoMoreSettingsWithQS:(NSString *)qs context:(TNTRoutingContext *)context {
    NSString *wacaifinanceURL = @"wacaifinance://moresettings";
    [FSSDKGotoUtility openURL:wacaifinanceURL from:[self tabBarController]];
    return nil;
}

+ (UIViewController *)tabBarController {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *controllers = appdelegate.fs_navgationController.viewControllers;
    FSTabbarController *tabBarController = (FSTabbarController *)[controllers firstObject];
    return tabBarController;
}


#pragma mark - Thana
+ (UIViewController *)openThanaWithQS:(NSString *)qs context:(TNTRoutingContext *)context {
    // 由于统跳 Android & iOS 对 Ping 的实现不一致
    // iOS 实现空方法仅用于灰度可 Ping 通，无实际意义
    return nil;
}

#pragma mark - GotoUtility
+ (UIViewController *_Nullable)switchTabToHomeWithQS:(NSString *_Nullable)qs context:(TNTRoutingContext *_Nullable)context {
    NSString* index = @"";
    NSString* pagePrefix = @"index=";
    if ([qs hasPrefix:pagePrefix]) {
        index = [qs substringFromIndex:[pagePrefix length]];
    }
    if ([index CM_isValidString]) {
        [FSGotoUtility jumpToHome:index.integerValue];
    }
    
    
    return nil;
}

@end
