//
//  TPKLifecycleMiddleware.m
//  WcbFinanceApp
//
//  Created by 金镖 on 2018/7/31.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "TPKLifecycleMiddleware.h"

@implementation TPKLifecycleMiddleware

static NSString * const kTPKJSBridgeOnWebViewActive = @"onFSWebViewActive";

- (void)setupMiddleWareFunctionMap {
    
    [self registerHandlerOnActive:^(TPKWebViewContext *context, tpk_stop stop, tpk_next goNext) {
        [context.webview callJSBridgeHandler:kTPKJSBridgeOnWebViewActive data:nil];
        goNext();
    }];
    
}

@end
