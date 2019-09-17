//
//  FSExamMiddleware.m
//  FinanceApp
//
//  Created by xingyong on 20/01/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSExamMiddleware.h"
#import "CMUIHelper.h"
@implementation FSExamMiddleware
// 处理资产体检头部按钮
-(void)setupMiddleWareFunctionMap
{
    [self registerHandlerOnCreateWebView:^(TPKWebViewContext *context,tpk_stop stop, tpk_next next) {
 
        if ([context.webview.initialURL CM_isContain:@"examination/enter"] || [context.webview.initialURL CM_isContain:@"examination/index"]) {
            NSURL *currenURL = [NSURL URLWithString:context.webview.initialURL];
            NSString *value = FMT(@"%@://%@/h/action/page/examination/question?need_zinfo=1",currenURL.scheme,currenURL.host);
            NSString *message = [NSString stringWithFormat:@"window.WebViewJavascriptBridge.open(\"%@\")",value];
            [context.webview setCustomButtons:@[@{@"text":@"调整偏好",@"message":message}] titleColor:[CMUIHelper getRGBColorBy:@"#0097ff"]];
        }
 
        next();
    }];
    
    [self registerHandlerOnPageFinish:^(TPKWebViewContext *context, NSError *error, tpk_stop stop, tpk_next next) {
         
        if ([context.webview.currentURL CM_isContain:@"examination/enter"] || [context.webview.currentURL CM_isContain:@"examination/index"]) {
            NSURL *currenURL = [NSURL URLWithString:context.webview.initialURL];
            NSString *value = FMT(@"%@://%@/h/action/page/examination/question?need_zinfo=1",currenURL.scheme,currenURL.host);
            NSString *message = [NSString stringWithFormat:@"window.WebViewJavascriptBridge.open(\"%@\")",value];
            [context.webview setCustomButtons:@[@{@"text":@"调整偏好",@"message":message}] titleColor:[CMUIHelper getRGBColorBy:@"#0097ff"]];
        } else {
//            [context.webview setCustomButtons:@[] titleColor:[CMUIHelper getRGBColorBy:@"#0097ff"]];
        }
 
        
        next();
    }];
}


@end
