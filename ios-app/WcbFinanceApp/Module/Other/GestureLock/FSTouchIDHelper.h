//
//  FSTouchIDHelper.h
//  FinanceApp
//
//  Created by 叶帆 on 9/2/16.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FSTouchIDStatus) {
    FSTouchIDStatusCompletelyAvailable,//Touch ID在App和系统中均完全可用
    FSTouchIDStatusAppAvailable,//Touch ID在App内可用
    FSTouchIDStatusSystemAvailable,//Touch ID在系统中可用
    FSTouchIDStatusAppOff,//用户关闭App内的指纹验证功能
    FSTouchIDStatusGestureLockout,//手势密码超过最大尝试次数
    FSTouchIDStatusClickForgetBtn,//点击了忘记密码，让重新登录按钮

    FSTouchIDStatusUnsupported,//对应LAErrorTouchIDNotAvailable
    FSTouchIDStatusSystemLockout,//对应LAErrorTouchIDLockout
    FSTouchIDStatusPasscodeNotSet,//对应LAErrorPasscodeNotSet
    FSTouchIDStatusNotEnrolled,//对应LAErrorTouchIDNotEnrolled
    FSTouchIDStatusUnknownError,//对应LAErrorInvalidContext及其他未知错误
    FSTouchIDStatusVerifyPassed,//Touch ID验证通过
    FSTouchIDStatusVerifyFailed,//Touch ID验证失败
    FSTouchIDStatusVerifyUserCancel,//Touch ID验证被用户取消
};

typedef void(^FSTouchIDSuccessBlock)();

@interface FSTouchIDHelper : NSObject

+ (FSTouchIDStatus)verifyTouchIDIfAppAvailableWithSuccessAction:(FSTouchIDSuccessBlock)successBlock;

+ (BOOL)isDeviceSupported;
+ (FSTouchIDStatus)checkTouchIDStatusOfSystem;



+ (BOOL)isTouchIDOfAppOn;
+ (void)switchTouchIDOfAppOn;
+ (void)switchTouchIDOfAppOff;
@end
