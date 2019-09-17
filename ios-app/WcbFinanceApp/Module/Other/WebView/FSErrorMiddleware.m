//
//  FSErrorMiddleware.m
//  WcbFinanceApp
//
//  Created by 金镖 on 2018/10/11.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSErrorMiddleware.h"
#import "FSCommonErrorView.h"
#import <i-Finance-Library/FSEventStatisticsAction.h>
@interface FSErrorMiddleware ()
@property(nonatomic, strong) FSCommonErrorView *errorView;;
@end

@implementation FSErrorMiddleware

-(void)setupMiddleWareFunctionMap
{
    [self registerHandlerOnPageFinish:^(TPKWebViewContext *context,NSError *error,tpk_stop stop, tpk_next next) {
        if (error) {
            __weak typeof(context.webview) weakWebView = context.webview;
            void(^reloadAction)() = ^{
                __strong typeof(weakWebView) strongWebview = weakWebView;
                [strongWebview reload];
            };
            
            if (!self.errorView) {
                self.errorView = [[FSCommonErrorView alloc] init];
            }
            self.errorView.reloadAction = reloadAction;
            [context.webview showCustomErrorView:self.errorView];
            
            NSString *currentURL = context.webview.currentURL;
            NSString *willLoadURL = context.webview.willLoadingURL;
            [self logError:error currentURL:currentURL willRequestURL:willLoadURL];
        } else {
            [context.webview hideErrorView];
        }
        next();
    }];
}

- (void)logError:(NSError *)error currentURL:(NSString *)currentURL willRequestURL:(NSString *)willLoadURL {
    NSDictionary *params = @{
                             @"lc_error_code"   : @(error.code) ?: @(0),
                             @"lc_error_msg"    : error.description ?: @"Null",
                             @"lc_current_url"  : currentURL ?: @"Null",
                             @"lc_willLoad_url" : willLoadURL ?: @"Null"
                             };
    [FSEventAction skylineEvent:@"finance_wcb_web_error" attributes:params];
}

@end
