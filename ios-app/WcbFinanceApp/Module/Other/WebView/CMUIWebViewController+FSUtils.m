//
//  CMUIWebViewController+FSUtils.m
//  FinanceApp
//
//  Created by xingyong on 06/04/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import "CMUIWebViewController+FSUtils.h"
#import "JRSwizzle.h"
#import "CMSDKManager.h"

@implementation CMUIWebViewController (FSUtils)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//         webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
        SEL originalSelector = @selector(canInterceptRequest:navigationType:);
        SEL swizzledSelector = @selector(swiz_canInterceptRequest:navigationType:);
        
        NSError *error = nil;
        [self jr_swizzleMethod:originalSelector withMethod:swizzledSelector error:&error];
        
        if (error!= nil) {
            NSLog(@"------------CMUIWebViewController hook---------- %@",error);
        }
    });
}


#pragma mark - Method Swizzling


- (BOOL)swiz_canInterceptRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = [request.URL relativeString];
    NSLog(@"URL = %@", url);

    NSString *host = request.URL.host;
    NSString *query = SAFE_STRING(request.URL.query);
    NSDictionary *params = [query CM_parseURLQueryString];
    
    
    if ([host isEqualToString:@"share"]) {
        // 把 wacaimsupermarket 替换成 wacai，使用 SocialShareSDK 来处理
        url = [url stringByReplacingOccurrencesOfString:@"wacaimsupermarket" withString:@"wacai"];
        
        // 将挖财宝自定义的字段转换成 SocialShareSDK 可以处理的字段，添加在最后
        NSMutableDictionary *legacyDic = [NSMutableDictionary new];
        if ([[params allKeys] containsObject:@"image"]) {
            legacyDic[@"imgurl"] = [params[@"image"] CM_urlEncoded];
        }
        if ([[params allKeys] containsObject:@"desc"]) {
            legacyDic[@"description"] = [params[@"desc"] CM_urlEncoded];
        }
        url = [url CM_URLAppendQueryByDictionary:legacyDic];
        
        [SDK_MGR openURL:[NSURL URLWithString:url] fromViewController:self];
        
        return YES;
    }
    
    
    return [self swiz_canInterceptRequest:request navigationType:navigationType];

    
}
@end
