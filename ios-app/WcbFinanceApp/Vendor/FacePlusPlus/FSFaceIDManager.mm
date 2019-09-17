//
//  FSFaceIDManager.m
//  WcbFinanceApp
//
//  Created by tesila on 2019/7/1.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSFaceIDManager.h"
#import <CMNSString/CMNSString.h>
#import <CMUIViewController/CMUIViewController.h>
#import <i-Finance-Library/FSEventStatisticsAction.h>
#if !TARGET_IPHONE_SIMULATOR
#import <MGFaceIDLiveDetect/MGFaceIDLiveDetect.h>
#endif

@implementation FSFaceIDManager

#if TARGET_IPHONE_SIMULATOR
+ (void)startDetectWithBizToken:(NSString *)bizToken controller:(UIViewController *)controller callback:(FSFaceIDLiveDetectResultBlock)callback {
    if (callback) {
        FSFaceIDLiveDetectError *error = [FSFaceIDLiveDetectError errorWithType:9999
                                                                        message:@"模拟器不支持该功能！"];
        callback(error, @"");
    }
}

#else

+ (void)startDetectWithBizToken:(NSString *)bizToken controller:(UIViewController *)controller callback:(FSFaceIDLiveDetectResultBlock)callback {
    // Init Detect Manager
    MGFaceIDLiveDetectError* error = nil;
    MGFaceIDLiveDetectManager* detectManager = [self detectManagerWithBizToken:bizToken error:&error];
    if (error || !detectManager) {
        FSFaceIDLiveDetectError *fsError = [FSFaceIDLiveDetectError errorWithType:error.errorType message:error.errorMessageStr];
        if (callback) {
            callback(fsError, @"");
        }
        [self logError:fsError];
        return;
    }
    
    // Start Detecting
    [detectManager startMGFaceIDLiveDetectWithCurrentController:controller ?: [CMUIViewController CM_curViewController]
                                                       callback:^(MGFaceIDLiveDetectError *error, NSData *deltaData, NSString *bizTokenStr, NSDictionary *extraOutDataDict) {
                                                           FSFaceIDLiveDetectError *fsError = [FSFaceIDLiveDetectError errorWithType:error.errorType message:error.errorMessageStr];
                                                           NSString *resultString = [self convertData:deltaData];
                                                           if (callback) {
                                                               callback(fsError, resultString);
                                                           }
                                                       }];
}

+ (MGFaceIDLiveDetectManager *)detectManagerWithBizToken:(NSString *)bizToken error:(MGFaceIDLiveDetectError **)error {
    MGFaceIDLiveDetectManager* detectManager = [[MGFaceIDLiveDetectManager alloc] initMGFaceIDLiveDetectManagerWithBizToken:bizToken
                                                                                                                   language:MGFaceIDLiveDetectLanguageCh
                                                                                                                networkHost:@"https://api.megvii.com"
                                                                                                                  extraData:nil
                                                                                                                      error:error];
    
    MGFaceIDLiveDetectCustomConfigItem* customConfigItem = [[MGFaceIDLiveDetectCustomConfigItem alloc] init];
    [detectManager setMGFaceIDLiveDetectCustomUIConfig:customConfigItem];
    [detectManager setMGFaceIDLiveDetectPhoneVertical:MGFaceIDLiveDetectPhoneVerticalFront];
    
    return detectManager;
}

+ (NSString *)convertData:(NSData *)resultData {
    return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
}

+ (void)logError:(FSFaceIDLiveDetectError *)error {
    NSDictionary *params = @{
                             @"lc_error_code" : @(error.errorType),
                             @"lc_error_msg": error.errorMessageStr ?: @""
                             };
    [FSEventAction skylineEvent:@"finance_wcb_faceid_setup" attributes:params];
}
#endif

@end
