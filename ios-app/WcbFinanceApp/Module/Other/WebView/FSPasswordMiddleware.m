//
//  FSPasswordMiddleware.m
//  WcbFinanceApp
//
//  Created by 金镖 on 2018/8/3.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSPasswordMiddleware.h"
#import "NSDictionary+CMSBJSON.h"
#import "FSWacaiLoginViewController.h"

@implementation FSPasswordMiddleware

-(void)setupMiddleWareFunctionMap
{
    [self registerJSBridgeForkey:@"coinChangePwd" handler:^(TPKWebViewContext *context, NSDictionary *data, WVJBResponseCallback responseCallback, tpk_stop stop, tpk_next next) {
        
        
        [context.webview.navigationController popToRootViewControllerAnimated:YES];
        
        UIViewController *rootViewController = context.webview.navigationController.viewControllers[0];
        if(![rootViewController isKindOfClass:[FSWacaiLoginViewController class]])
        {
            [FSGotoUtility gotoLoginViewController:nil
                                           success:^{
                                               
                                           } cancel:NULL];

        }
        
        stop();
        
        
    } timeout:0];
    
    [self registerJSBridgeForkey:@"jumpToLogin" handler:^(TPKWebViewContext *context, NSDictionary *data, WVJBResponseCallback responseCallback, tpk_stop stop, tpk_next next) {
    
        __weak typeof(context.webview) weakWebView = context.webview;
        
        [FSGotoUtility gotoLoginViewController:nil
                                       success:^{
                                           [context.webview loadURLString:weakWebView.currentURL];
                                       } cancel:NULL];
        
        stop();
        
    } timeout:0];
}

@end
