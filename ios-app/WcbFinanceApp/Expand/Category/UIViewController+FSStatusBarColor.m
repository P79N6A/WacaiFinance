//
//  UIViewController+FSStatusBarColor.m
//  WcbFinanceApp
//
//  Created by xingyong on 2018/5/22.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "UIViewController+FSStatusBarColor.h"
#import <objc/runtime.h>

@implementation UIViewController (FSStatusBarColor)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(statusBar_viewWillAppear:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}
#pragma mark - Method Swizzling
- (void)statusBar_viewWillAppear:(BOOL)animated {
    [self statusBar_viewWillAppear:animated];
    
    if ([self isKindOfClass:NSClassFromString(@"FSTradeListViewController")] ||
        [self isKindOfClass:NSClassFromString(@"FSPositionDetailViewController")] ||
        [self isKindOfClass:NSClassFromString(@"FSMoneyViewController")] ||
        [self isKindOfClass:NSClassFromString(@"FSCommonPageController")]) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
 
}

@end
