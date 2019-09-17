//
//  FSNeedLoginMiddleware.m
//  FundApp
//
//  Created by luowen on 2017/3/14.
//  Copyright © 2017年 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSNeedLoginMiddleware.h"
#import "CMAppProfile.h"

@implementation FSNeedLoginMiddleware
// 处理详情界面，未登录无法查看部分内容的case
-(void)setupMiddleWareFunctionMap {
    
    [self registerHandlerOnURLLoad:^BOOL(TPKWebViewContext *context, NSString *URLString, tpk_stop stop) {
        NSLog(@"--------------URLString-------- %@",URLString);

        if ([URLString containsString:@"token_failure=1"]) {
            [USER_INFO logout];
            
            [FSGotoUtility gotoLoginViewController:context.webview success:^{
                
            } cancel:^{
                
                //退到root页面
                [context.webview.navigationController popToRootViewControllerAnimated:YES];
                
            }];
            
            return NO;
        }
        
        if ([[CMAppProfile sharedInstance] isLogin]) return YES;
        
        NSURL *URL = [NSURL URLWithString:URLString];
        NSDictionary *params = [URL CM_URLQuery];
        NSString *host = URL.host;
        
        
        if ([host isEqualToString:@"callback"]) {
            [self onCallback:context.webview params:params];
            if (stop) stop();
            return NO;
        }
    
        BOOL isNeedLogin = [params CM_boolForKey:@"need_login"];
        BOOL popup = [params CM_boolForKey:@"popup"];
        if (!isNeedLogin) return YES;
        
        [FSGotoUtility gotoLoginViewController:context.webview success:^{
            
            if (popup) {
                TPKWebViewController *webView = [[TPKWebViewController alloc] initWithURLString:URLString];
                [context.webview.navigationController pushViewController:webView animated:YES];
            }else{
                NSString *JS = [NSString stringWithFormat:@"window.WebViewJavascriptBridge.open(\"%@\")",URLString];
                [context.webview evaluatingJavaScriptString:JS];                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

            }
        } cancel:^{
            
            NSLog(@"URLString is %@", URLString);
            
            if(context.webview.currentURL.length <= 0)
            {
                NSLog(@"当前没有打开任何URL");
                [context.webview.navigationController popViewControllerAnimated:YES];
            }
            
        }];
        
        if (stop) stop();
        return NO;
    }];
}


// JS回调
- (void)onCallback:(TPKWebViewController *)webViewController params:(NSDictionary*)params {
    NSString *action = [params[@"action"] lowercaseString];
    
    
    void(^tokenToWebViewBlock)(NSString *token) = ^(NSString *token) {
        NSString *function   = params[@"function"];
        NSString *userString = [NSString stringWithFormat:@"access_token=%@", token];
//        [webViewController.webView evaluateJavaScript:[NSString stringWithFormat:@"top.%@('%@')",function, userString]
//                                    completionHandler:nil];
        [webViewController.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"top.%@('%@')",function, userString]];
        
 
    };
    
    
    // 强制登录
    if ([action isEqualToString:@"relogin"] || [action isEqualToString:@"forcelogin"]) {
        [USER_INFO logout];
        
        [FSGotoUtility gotoLoginViewController:webViewController success:^{
            tokenToWebViewBlock([CMAppProfile sharedInstance].mTokenIDBlock());
        }];
        return;
    }
    
    
    BOOL hasLogin = [[CMAppProfile sharedInstance] isLogin];
    if ([action isEqualToString:@"needlogin"]) {
        if (hasLogin) {
            tokenToWebViewBlock([CMAppProfile sharedInstance].mTokenIDBlock());
            return;
        }
        
        // 没登录 弹出登录界面
        [FSGotoUtility gotoLoginViewController:webViewController success:^{
            tokenToWebViewBlock([CMAppProfile sharedInstance].mTokenIDBlock());
        }];
        return;
    }
}



@end
