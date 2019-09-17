//
//  UIViewController+FSUtil.m
//  FinanceApp
//
//  Created by Alex on 1/18/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "UIViewController+FSUtil.h"
#import <objc/runtime.h>

static char *FSRouterName = "FSRouterName.finance";

@implementation UIViewController (FSUtil)

+ (UIViewController*) findBestViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [UIViewController findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.selectedViewController];
        else
            return vc;
        
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
    
}

+ (UIViewController*)fs_currentViewController {
    
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController findBestViewController:viewController];
    
}


- (BOOL)fs_isModal
{
    if (self.presentingViewController.presentedViewController == self) {
        return YES;
    }
    
    if (self.navigationController != nil && self.navigationController.presentingViewController.presentedViewController == self.navigationController) {
        return YES;
    }
    
    if ([self.tabBarController.presentingViewController isKindOfClass:[UITabBarController class]]) {
        return YES;
    }
    
    return NO;
}

- (NSString *)fsRouterName
{
    return objc_getAssociatedObject(self, FSRouterName);
}

- (void)setFsRouterName:(NSString *)name
{
    objc_setAssociatedObject(self, FSRouterName, name, OBJC_ASSOCIATION_RETAIN);
}

@end
