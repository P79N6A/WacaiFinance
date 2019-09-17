//
//  FSLoginMiddleware.m
//  FinanceApp
//
//  Created by xingyong on 12/01/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSLoginMiddleware.h"
#import <NeutronBridge/NeutronBridge.h>

@implementation FSLoginMiddleware
// 处理详情界面，未登录先跳转到登陆界面
-(void)setupMiddleWareFunctionMap
{
    
    [self registerJSBridgeForkey:TPKJSBridgeLoginThenOpen handler:^(TPKWebViewContext *context, NSDictionary *data, WVJBResponseCallback responseCallback, tpk_stop stop, tpk_next next) {
        NSString *URLToOpen = [data CM_stringForKey:@"params"];
        
        if ([[CMAppProfile sharedInstance] isLogin]) {
            [context.webview loadURLString:URLToOpen];
            next();
            return ;
        }
        
        [FSGotoUtility gotoLoginViewController:nil
                                       success:^{
                                           [context.webview loadURLString:URLToOpen];
                                       } cancel:^{
                                           NSLog(@"cancel");
                                       }];
        
        stop();
        
    } timeout:0];
    
    [self registerJSBridgeForkey:TPKJSBridgeLogin handler:^(TPKWebViewContext *context, NSDictionary *data, WVJBResponseCallback responseCallback, tpk_stop stop, tpk_next next) {
        
        __weak typeof(context.webview) weakWebView = context.webview;
        
        [FSGotoUtility gotoLoginViewController:nil
                                       success:^{
                                           [context.webview loadURLString:weakWebView.currentURL];
                                       } cancel:^{
                                           NSLog(@"cancel");
                                           [weakWebView.navigationController popViewControllerAnimated:YES];
                                       }];
        
        stop();
        
    } timeout:0];
    
}


@end

