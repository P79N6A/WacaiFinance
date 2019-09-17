//
//  CustomiRate.m
//  FinanceApp
//
//  Created by 叶帆 on 7/14/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "CustomiRate.h"
#import <objc/message.h>

@interface CustomiRate ()

@property (nonatomic, strong) id visibleAlert;

@end



@implementation CustomiRate

- (void)promptForRating {
    if (!self.visibleAlert)
    {
        NSString *message = self.ratedAnyVersion? self.updateMessage: self.message;
        
#if TARGET_OS_IPHONE
        
        UIViewController *topController = [UIApplication sharedApplication].delegate.window.rootViewController;
        while (topController.presentedViewController)
        {
            topController = topController.presentedViewController;
        }
        
        if ([UIAlertController class] && topController && self.useUIAlertControllerIfAvailable)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.messageTitle message:message preferredStyle:UIAlertControllerStyleAlert];
            
            //rate action
            [alert addAction:[UIAlertAction actionWithTitle:self.rateButtonLabel style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
                [self call_didDismissAlert:alert withButtonAtIndex:0];
            }]];
            
            //remind action
            if ([self showRemindButton])
            {
                [alert addAction:[UIAlertAction actionWithTitle:self.remindButtonLabel style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
                    [self call_didDismissAlert:alert withButtonAtIndex:[self showCancelButton]? 2: 1];
                }]];
            }
            
            //cancel action
            if ([self showCancelButton])
            {
                [alert addAction:[UIAlertAction actionWithTitle:self.cancelButtonLabel style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
                    [self call_didDismissAlert:alert withButtonAtIndex:1];
                }]];
            }
            
            self.visibleAlert = alert;
            
            //get current view controller and present alert
            [topController presentViewController:alert animated:YES completion:NULL];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.messageTitle
                                                            message:message
                                                           delegate:(id<UIAlertViewDelegate>)self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:self.rateButtonLabel, nil];
            if ([self showCancelButton])
            {
                [alert addButtonWithTitle:self.cancelButtonLabel];
                alert.cancelButtonIndex = 1;
            }
            
            if ([self showRemindButton])
            {
                [alert addButtonWithTitle:self.remindButtonLabel];
            }
            
            self.visibleAlert = alert;
            [self.visibleAlert show];
        }
        
#else
        
        //only show when main window is available
        if (self.onlyPromptIfMainWindowIsAvailable && ![[NSApplication sharedApplication] mainWindow])
        {
            [self performSelector:@selector(promptForRating) withObject:nil afterDelay:0.5];
            return;
        }
        
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = self.messageTitle;
        alert.informativeText = message;
        [alert addButtonWithTitle:self.rateButtonLabel];
        if ([self showCancelButton])
        {
            [alert addButtonWithTitle:self.cancelButtonLabel];
        }
        if ([self showRemindButton])
        {
            [alert addButtonWithTitle:self.remindButtonLabel];
        }
        
        self.visibleAlert = alert;
        
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9
        
        if (![alert respondsToSelector:@selector(beginSheetModalForWindow:completionHandler:)])
        {
            [alert beginSheetModalForWindow:[NSApplication sharedApplication].mainWindow
                              modalDelegate:self
                             didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                                contextInfo:nil];
        }
        else
            
#endif
            
        {
            [alert beginSheetModalForWindow:[NSApplication sharedApplication].mainWindow completionHandler:^(NSModalResponse returnCode) {
                [self didDismissAlert:alert withButtonAtIndex:returnCode - NSAlertFirstButtonReturn];
            }];
        }
        
#endif
        
        //inform about prompt
        [self.delegate iRateDidPromptForRating];
        [[NSNotificationCenter defaultCenter] postNotificationName:iRateDidPromptForRating
                                                            object:nil];
    }
    
}

- (void)call_didDismissAlert:(__unused id)alertView withButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    id target = self;
    SEL selector = @selector(didDismissAlert:withButtonAtIndex:);
    typedef void (*MethodType)(id, SEL, __unused id, NSInteger);
    MethodType methodToCall = (MethodType)[target methodForSelector:selector];
    if ([self respondsToSelector:@selector(didDismissAlert:withButtonAtIndex:)]) {
        methodToCall(target, selector, alertView, buttonIndex);
    }
#pragma clang diagnostic pop
}

- (BOOL)showRemindButton
{
    return [self.remindButtonLabel length];
}

- (BOOL)showCancelButton
{
    return [self.cancelButtonLabel length];
}



@end
