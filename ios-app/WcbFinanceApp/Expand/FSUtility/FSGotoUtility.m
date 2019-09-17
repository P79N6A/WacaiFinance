//
//  FSGotoUtility.m
//  FinanceApp
//
//  Created by xingyong on 2/2/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSGotoUtility.h"
#import "CMSDKManager.h"
#import "FSOriginalLoginViewController.h"
#import "FSLoginManager.h"
#import "AppDelegate.h"
#import "FSTabbarController.h"
#import "FSRouter.h"
#import "FSTabbarController.h"
#import "TPKWebViewController.h"
#import "LRCenterManager.h"
#import "NSURL+CMURL.h"
#import <NeutronBridge/NeutronBridge.h>
#import "FSAssetViewController.h"
#import "UIViewController+FSUtil.h"

@implementation FSGotoUtility

+ (void)gotoLoginViewController:(UIViewController *)baseViewController success:(CompletionBlock)success
{
    [self gotoLoginViewController:baseViewController success:success cancel:nil];
}



+ (void)gotoLoginViewController:(UIViewController *)baseViewController success:(CompletionBlock)success cancel:(CancelBlock)cancel
{
    if (!baseViewController) {
   
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSArray *controllers = appdelegate.fs_navgationController.viewControllers;
        FSTabbarController *tabBarController = (FSTabbarController *)[controllers firstObject];
        
        baseViewController = tabBarController;
    }
    
    NSString *comeFrom;
    if(baseViewController.fsRouterName)
    {
        comeFrom = baseViewController.fsRouterName;
    }
    else
    {
        comeFrom = @"others";
    }
    
    [UserAction skylineEvent:@"finance_wcb_login_enter_page"];
    
    UIViewController *vc = [[FSLoginManager manager] loginViewControllerSuccess:success cancel:cancel comeFrom:comeFrom];
    [baseViewController presentViewController:vc animated:YES completion:nil];
}

#pragma mark -- tabbar switch
+ (void)jumpToHome:(NSUInteger)selectedTabIndex {
    

    FSTabbarController *tabBarController = [[self class] currentTabbarController];
    
    UIViewController* tabBarItemController = tabBarController.selectedViewController;
    
     
    UIViewController* presentedViewController = [self presentedTopViewController:tabBarItemController];
 
    BOOL havePresented = (presentedViewController != tabBarItemController);
    if (havePresented) {
        [presentedViewController dismissViewControllerAnimated:YES completion:^{
            // 有多个Presented界面盖在上面时，递归调用.
            [self jumpToHome:selectedTabIndex];
        }];
    } else {
        [self popToHome:selectedTabIndex curTabViewController:tabBarItemController];
    }
}

+ (FSTabbarController *)currentTabbarController{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *controllers = appdelegate.fs_navgationController.viewControllers;
    FSTabbarController *tabBarController = (FSTabbarController *)[controllers firstObject];
   
    return tabBarController;
}


+ (UIViewController*)presentedTopViewController:(UIViewController*)viewController {
    UIViewController *topController = viewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

+ (void)popToHome:(long)newSelectTabIndex curTabViewController:(UIViewController*)tabBarItemController {
     FSTabbarController *tabBarController = [[self class] currentTabbarController];

    BOOL needSwitchTab = newSelectTabIndex != tabBarController.selectedIndex && newSelectTabIndex < [tabBarController.childViewControllers count];
    UINavigationController* tabNavigationController = [tabBarItemController isKindOfClass:[UINavigationController class]] ? (UINavigationController*)tabBarItemController : tabBarItemController.navigationController;
    if (tabNavigationController.viewControllers.count > 1) {
        // 如果需要切换Tab, 那么不可以使用动画，因为动画不是同步的操作.
        [tabNavigationController popToRootViewControllerAnimated:!needSwitchTab];
    }
 
    
    if (needSwitchTab) {
 
        [tabBarController setSelectedIndex:newSelectTabIndex];
        
    }
}


+ (void)pushViewController:(UIViewController *)targetViewController
{

    FSTabbarController *tabBarController = [[self class] currentTabbarController];

    UINavigationController *selectedViewController = tabBarController.selectedViewController;
    [selectedViewController pushViewController:targetViewController animated:YES];
    
}

+ (void)gotoGestureLockViewController:(UINavigationController *)navgationController
                                 type:(FSGestureLockType)type
                             animated:(BOOL)animated{
    FSGestureLockViewController *lock = [[FSGestureLockViewController alloc] init];
    lock.type = type;
    [navgationController pushViewController:lock animated:animated];
    
}

@end
