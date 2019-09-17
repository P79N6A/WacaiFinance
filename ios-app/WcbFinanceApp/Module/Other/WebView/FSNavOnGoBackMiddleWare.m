//
//  FSNavOnGoBackMiddleWare.m
//  WcbFinanceApp
//
//  Created by xingyong on 01/03/2018.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSNavOnGoBackMiddleWare.h"

static NSString * const kTPKJSBridgeOnGoBack = @"interceptGoBack";
static NSString * const kTPKJSBridgeClearGoBack = @"clearGoBack";
static NSString * const kTPKJSBridgeOnFinanceGoBack = @"onFinanceGoBack";

@implementation FSNavOnGoBackMiddleWare
// 处理详情界面，未登录先跳转到登陆界面
-(void)setupMiddleWareFunctionMap
{
    
    [self registerJSBridgeForkey:kTPKJSBridgeOnGoBack handler:^(TPKWebViewContext *context, NSDictionary *data, WVJBResponseCallback responseCallback, tpk_stop stop, tpk_next next) {
        
        NSDictionary *dataDic =  [data CM_dictionaryForKey:@"params"];
        NSLog(@"data==== %@",data);
        BOOL flag = [dataDic CM_boolForKey:@"intercept"];
        if (flag) {
            [context.webview overrideBackButtonAction:^{
//                NSLog(@"阻止事件");
                [context.webview callJSBridgeHandler:kTPKJSBridgeOnFinanceGoBack data:nil];
            }];
        }else{
            
            [context.webview overrideBackButtonAction:NULL];

        }
    
        stop();
        
    } timeout:0];
    
    
    [self registerJSBridgeForkey:kTPKJSBridgeClearGoBack handler:^(TPKWebViewContext *context, NSDictionary *data, WVJBResponseCallback responseCallback, tpk_stop stop, tpk_next next) {
        
//        NSString *URLToOpen = [data CM_stringForKey:@"params"];
        [context.webview overrideBackButtonAction:NULL];
 
        
        
        stop();
        
    } timeout:0];
    
    
}
@end
