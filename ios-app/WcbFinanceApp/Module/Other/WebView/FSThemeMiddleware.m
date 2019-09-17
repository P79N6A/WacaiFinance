//
//  FSThemeMiddleware.m
//  FinanceApp
//
//  Created by xingyong on 12/01/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSThemeMiddleware.h"
#import <SdkBbs2/BBSURL.h>
#import <WMPageController/WMPageController.h>

@implementation FSThemeMiddleware
-(void)setupMiddleWareFunctionMap
{
    [self registerHandlerOnCreateWebView:^(TPKWebViewContext *context,tpk_stop stop, tpk_next next) {
        //需要执行的事件,这里是将webview的导航主题设置为白色主题,将状态栏颜色改变成白色
        [context.webview setNavBarTheme:@"white"];
        [context.webview hideLoadingIndicator];
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [context.webview setupBackgroundView:backgroundView];
        [context.webview setSingleTitleFont:[UIFont systemFontOfSize:17]];
        [context.webview setStatusBarBackgroundColor:[UIColor whiteColor]];
        [context.webview setNavBarSeperatorLineColor:[UIColor colorWithHex:0xe7e7e7]];
        context.webview.webView.scalesPageToFit = YES;
        context.webview.webView.keyboardDisplayRequiresUserAction = NO;
        [context.webview setCustomCloseButtonImage:[UIImage imageNamed:@"tpk_close"]];
        [context.webview setCustomBackButtonImage:[UIImage imageNamed:@"tpk_back"]];


        if(![BBSURL isBBSDomainURL:[NSURL URLWithString:context.webview.initialURL]]){
            [context.webview setWebviewBounces:YES];
        }
        
        //next()是将说明下个中间件可以执行
        next();
    }];
    [self registerHandlerOnActive:^(TPKWebViewContext *context, tpk_stop stop, tpk_next goNext) {
        // App 内 PageController 样式为深色 StatusBar，此时不修改 WebView Controller 样式
        if (![self isEmbeddedInPageController:context.webview]) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
        goNext();
    }];
}

- (BOOL)isEmbeddedInPageController:(UIViewController *)controller {
    UIViewController *nextController = controller;
    while (nextController != nil) {
        if ([nextController isKindOfClass:[WMPageController class]]) {
            return YES;
        }
        nextController = nextController.parentViewController;
    }
    return NO;
}

@end
