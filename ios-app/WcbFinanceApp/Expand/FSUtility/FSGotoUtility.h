//
//  FSGotoUtility.h
//  FinanceApp
//
//  Created by xingyong on 2/2/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSGestureLockViewController.h"
#import "FSLoginManager.h"

@interface FSGotoUtility : NSObject

+ (void)gotoLoginViewController:(UIViewController *)baseViewController success:(CompletionBlock)success;
+ (void)gotoLoginViewController:(UIViewController *)baseViewController success:(CompletionBlock)success cancel:(CancelBlock)cancel;

+ (void)gotoGestureLockViewController:(UINavigationController *)navgationController
                                 type:(FSGestureLockType)type
                             animated:(BOOL)animated;

+ (void)jumpToHome:(NSUInteger)selectedTabIndex;


@end
