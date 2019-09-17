//
//  FSShareMiddleware.m
//  FinanceApp
//
//  Created by xingyong on 01/04/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSShareMiddleware.h"
#import "CMSDKManager.h"
#import "NSURL+CMURL.h"

@implementation FSShareMiddleware
// 处理scheme为 wacaimsupermarket://share
-(void)setupMiddleWareFunctionMap {
    
    [self registerHandlerOnURLLoad:^BOOL(TPKWebViewContext *context, NSString *URLString, tpk_stop stop) {
        
        NSURL *URL = [NSURL URLWithString:URLString];
        NSDictionary *params = [URL CM_URLQuery];
        NSString *host = URL.host;
        
        if ([host isEqualToString:@"share"]) {
            
            NSString *url = [URLString stringByReplacingOccurrencesOfString:@"wacaimsupermarket" withString:@"wacai"];
            
            // 将挖财宝自定义的字段转换成 SocialShareSDK 可以处理的字段，添加在最后
            NSMutableDictionary *legacyDic = [NSMutableDictionary dictionary];
            if ([[params allKeys] containsObject:@"image"]) {
                legacyDic[@"imgurl"] = [params[@"image"] CM_urlEncoded];
            }
            if ([[params allKeys] containsObject:@"desc"]) {
                legacyDic[@"description"] = [params[@"desc"] CM_urlEncoded];
            }
            url = [url CM_URLAppendQueryByDictionary:legacyDic];
            
            [SDK_MGR openURL:[NSURL URLWithString:url] fromViewController:context.webview];
            
            if (stop) stop();
            return NO;
        }
        
        return YES;
    }];
}



@end
