//
//  UIWindow+ThanaMotionEvent.m
//  WcbFinanceApp
//
//  Created by tesila on 2018/12/12.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "UIWindow+ThanaMotionEvent.h"
#import <AudioToolbox/AudioServices.h>
#import <objc/runtime.h>
#import <FSThana/FSThana.h>
#import <NeutronBridge/NeutronBridge.h>

@implementation UIWindow (ThanaMotionEvent)

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)invokeThana {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"有什么问题想要反馈吗？"
                                                                   message:@"我们已自动记录错误代码，点击“提交”，工程师会尽快帮您解决。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"提交"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              [FSThana reportLogs];
                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    
    [self.rootViewController presentViewController:alert animated:YES completion:^{}];
}

#pragma mark - Motion Event
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (![FSThana sharedInstance].enable) { return; }
    
    if (motion == UIEventSubtypeMotionShake) {
        
        NSInteger shakeCount = [self shakeCount];
        NSLog(@"--** motionBegan， ShakeCount:%@", @(shakeCount));
        
        if (shakeCount >= 2) {
            [self resetShakeCount];
            [self invokeThana];
        } else {
            [self addShakeCount];
        }
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"--** motionEnded");
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"--** motionCancelled");
}


#pragma mark - Shake Count
- (void)resetShakeCount {
    NSNumber *shakeNumber = @(0);
    objc_setAssociatedObject(self, "ShakeCountKey", shakeNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addShakeCount {
    NSNumber *shakeNumber = @([self shakeCount] + 1);
    objc_setAssociatedObject(self, "ShakeCountKey", shakeNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)shakeCount {
    NSNumber *shakeNumber = objc_getAssociatedObject(self, "ShakeCountKey");
    return shakeNumber.integerValue;
}

@end
