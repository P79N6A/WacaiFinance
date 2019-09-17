//
//  FSTouchIDHelper.m
//  FinanceApp
//
//  Created by 叶帆 on 9/2/16.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSTouchIDHelper.h"
#import "FSStringUtils.h"
#import "CMUIDisappearView.h"
//#import "WacUtil.h"
@import LocalAuthentication;

@implementation FSTouchIDHelper


//检查挖财宝App中的Touch ID状态
+ (FSTouchIDStatus)checkTouchIDStatusOfApp {
    if (![FSTouchIDHelper isTouchIDOfAppOn]) {
        return FSTouchIDStatusAppOff;
    }
    
    if ([FSTouchIDHelper isGesturePwdOverLimited]) {
        return FSTouchIDStatusGestureLockout;
    }
    
    if([FSStringUtils hasClickForgetBtn]){
        return FSTouchIDStatusClickForgetBtn;
    }
    return FSTouchIDStatusAppAvailable;
}

//调用iOS API检查Touch ID状态
+ (FSTouchIDStatus)checkTouchIDStatusOfSystem {
    if (!IOS8_ATLEAST) {
        return FSTouchIDStatusUnsupported;
    }
    
    LAContext *context = [[LAContext alloc] init];
    NSLog(@"content :: %@", context);
    NSError *error;
    BOOL success = [context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (success) {
        //系统返回Touch ID可用
        return FSTouchIDStatusSystemAvailable;
    } else {
        //系统返回Touch ID不可用
        switch (error.code) {
            case LAErrorPasscodeNotSet:
                return FSTouchIDStatusPasscodeNotSet;
                break;
            case LAErrorTouchIDNotAvailable:
                return FSTouchIDStatusUnsupported;
                break;
            case LAErrorTouchIDNotEnrolled:
                return FSTouchIDStatusNotEnrolled;
                break;
            case LAErrorTouchIDLockout:
                return FSTouchIDStatusSystemLockout;
                break;
            case LAErrorInvalidContext:
                return FSTouchIDStatusUnknownError;
                break;
            default:
                return FSTouchIDStatusUnknownError;
                break;
        }
    }
}

//设备是否支持Touch ID
+ (BOOL)isDeviceSupported {
    if(FS_iPhoneX){
        return YES;
    }else{
        FSTouchIDStatus status = [FSTouchIDHelper checkTouchIDStatusOfSystem];
        return (status != FSTouchIDStatusUnsupported) && (status != FSTouchIDStatusUnknownError);
    }
   
}

//用户是否关闭App内的指纹验证功能
+ (BOOL)isTouchIDOfAppOn {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *touchIDStatus = [userDefault objectForKey:[FSStringUtils getTouchIDStatusKey]];
    if([touchIDStatus CM_isEqualsIgnoreCase:@"On"]) {
        return YES;
    } else {
        return NO;
    }
}

//手势密码是否超过最大尝试次数
+ (BOOL)isGesturePwdOverLimited {
    NSString *limitDateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentDateLimit"];
    return [limitDateStr isEqualToString:[FSStringUtils currentDateString]];
}

+ (FSTouchIDStatus)verifyTouchIDIfAppAvailableWithSuccessAction:(FSTouchIDSuccessBlock)successBlock {
    if (!IOS8_ATLEAST) {
        return FSTouchIDStatusUnsupported;
    }
    
    __block FSTouchIDStatus result;
    if ([FSTouchIDHelper checkTouchIDStatusOfApp] == FSTouchIDStatusAppAvailable) {
        LAContext *context = [[LAContext alloc] init];
        NSLog(@"------context------- %@",context);
        context.localizedFallbackTitle = @"";
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:FS_iPhoneX ? @"通过验证面容解锁挖财宝":@"通过验证指纹解锁挖财宝"
                          reply:^(BOOL success, NSError * _Nullable error) {
                              if (success) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      successBlock();
                                      result = FSTouchIDStatusVerifyPassed;
                                  });
                              } else {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      switch (error.code) {
                                          case LAErrorPasscodeNotSet:
                                              result = FSTouchIDStatusPasscodeNotSet;
                                              break;
                                          case LAErrorTouchIDNotAvailable:
                                              result = FSTouchIDStatusUnsupported;
                                              break;
                                          case LAErrorTouchIDNotEnrolled:
                                              result = FSTouchIDStatusNotEnrolled;
                                              break;
                                          case LAErrorTouchIDLockout:
                                              result = FSTouchIDStatusSystemLockout;
                                              [CMUIDisappearView showMessage:FS_iPhoneX ? @"面容验证超过限制次数":@"指纹验证超过限制次数"];
                                              break;
                                          case LAErrorAuthenticationFailed:
                                              result = FSTouchIDStatusVerifyFailed;
                                              [CMUIDisappearView showMessage:FS_iPhoneX ? @"面容解锁验证失败":@"指纹解锁验证失败"];
                                              break;
                                          case LAErrorUserCancel:
                                              result = FSTouchIDStatusVerifyUserCancel;
                                              break;
                                          default:
                                              result = FSTouchIDStatusVerifyFailed;
                                              [CMUIDisappearView showMessage:FS_iPhoneX ? @"面容解锁异常，请重启后再试":@"指纹解锁异常，请重启后再试"];
                                              break;
                                      }
                                  });
                              }
                              
                          }];
        
    } else {
        result = FSTouchIDStatusVerifyFailed;
    }
    return result;
}

+ (void)switchTouchIDOfAppOn {
    if ([FSTouchIDHelper checkTouchIDStatusOfSystem] == FSTouchIDStatusUnsupported) {
        return;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"On" forKey:[FSStringUtils getTouchIDStatusKey]];
    [userDefault synchronize];
 }

+ (void)switchTouchIDOfAppOff {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"Off" forKey:[FSStringUtils getTouchIDStatusKey]];
    [userDefault synchronize];
 }

@end
