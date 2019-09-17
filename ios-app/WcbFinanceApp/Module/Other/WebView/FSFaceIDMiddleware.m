//
//  FSFaceIDMiddleware.m
//  WcbFinanceApp
//
//  Created by tesila on 2019/7/2.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSFaceIDMiddleware.h"
#import "FSFaceIDManager.h"
#import <i-Finance-Library/FSEventStatisticsAction.h>

// 说明文档 http://git.caimi-inc.com/client/finance-discussion/issues/275

static NSString *const kFSMegLiveStill = @"megLiveStill";

@implementation FSFaceIDMiddleware

- (void)setupMiddleWareFunctionMap {
    [self registerJSBridgeForKey:kFSMegLiveStill handler:^(TPKWebViewContext *context, NSDictionary *data, WVJBResponseCallback responseCallback, tpk_stop stop, tpk_next next) {
        NSDictionary *params =  [data CM_dictionaryForKey:@"params"];
        NSString *bizToken = [params CM_stringForKey:@"bizToken"];
        [FSFaceIDManager startDetectWithBizToken:bizToken controller:context.webview callback:^(FSFaceIDLiveDetectError * _Nonnull error, NSString * _Nonnull resultString) {
            
            NSUInteger code     = error.errorType;
            NSString *message   = error.errorMessageStr ?: @"";
            NSDictionary *data  = @{
                                    @"identifiedData" : resultString ?: @""
                                    };
            NSDictionary *responseDic = @{
                                          @"code"   : @(code),
                                          @"msg"    : message,
                                          @"data"   : data
                                          };
            responseCallback(responseDic);
            
            NSDictionary *params = @{
                                     @"lc_error_code"   : @(code),
                                     @"lc_error_msg"    : message,
                                     };
            [FSEventAction skylineEvent:@"finance_wcb_faceid_result" attributes:params];
            
        }];
        
        stop();
    }];
}

@end
