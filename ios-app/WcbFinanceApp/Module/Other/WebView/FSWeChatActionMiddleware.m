//
//  FSWeChatActionMiddleware.m
//  WcbFinanceApp
//
//  Created by tesila on 2018/11/24.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSWeChatActionMiddleware.h"
#import <SdkShare/SocialShareSDK.h>
#import <CMNSDictionary/CMNSDictionary.h>
#import <NeutronBridge/NeutronBridge.h>
#import <NativeQS/NQSParser.h>
#import <CMUIViewController/UIViewController+CMUtil.h>
#import <CMNSString/NSString+CMUtil.h>

// 说明文档 http://git.caimi-inc.com/client/finance-discussion/issues/209

static NSString *const kFSRequestWXLogin = @"requestWXLogin";
static NSString *const kFSOpenWX = @"openWX";

@implementation FSWeChatActionMiddleware

- (void)setupMiddleWareFunctionMap {
    [self registerJSBridgeForkey:kFSRequestWXLogin handler:^(TPKWebViewContext *context, NSDictionary *data, WVJBResponseCallback responseCallback, tpk_stop stop, tpk_next next) {
        
        UIViewController *fromVC = context.webview;
        
        NSDictionary *param = @{ @"shareType":@(LRThirdLoginWayWeChat),
                                 @"action": @(SSActionLogin) };
        NSString *source = [NSString stringWithFormat:@"%@?%@", @"nt://sdk-share/login", [NQSParser queryStringifyObject:param]];
        
        NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:fromVC];
        [ns ntWithSource:source
      fromViewController:fromVC
              transiaion:NTBViewControllerTransitionPush
                  onDone:^(NSString * _Nullable result) {
                      
                      NSDictionary *params = @{@"shareType":@(LRThirdLoginWayWeChat),
                                               @"action": @(SSActionGetUsername)};
                      NSString *source = [NSString stringWithFormat:@"%@?%@", @"nt://sdk-share/login", [NQSParser queryStringifyObject:params]];
                      NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:fromVC];
                      [ns ntWithSource:source
                    fromViewController:fromVC
                            transiaion:NTBViewControllerTransitionPush
                                onDone:^(NSString * _Nullable result) {
                                    NSDictionary * info = [result CM_JsonStringToDictionary];
                                    if ([[info CM_stringForKey:@"status"] isEqualToString:@"success"] == NO) { return; }
                                    
                                    NSDictionary *shareInfo = [SOCIALSHARESDK infoForShareType:SSShareTypeWeChat];
                                    
                                    NSDictionary *shareResult = @{
                                                             @"access_token"    : [shareInfo CM_stringForKey:@"SSShareTypeInfoAccessTokenKey"],
                                                             @"expires_in"      : [shareInfo CM_stringForKey:@"SSShareTypeInfoExpiresKey"],
                                                             @"refresh_token"   : [shareInfo CM_stringForKey:@"SSShareTypeInfoRefreshTokenKey"],
                                                             @"source_account"  : [shareInfo CM_stringForKey:@"SSShareTypeInfoUserIDKey"]
                                                             };
                                    responseCallback(shareResult);
                                } onError:^(NSError * _Nullable error) {
                                    responseCallback(error.description ?: @"");
                                }];
                      
                  } onError:^(NSError * _Nullable error) {
                      
                  }];
        
        stop();
    } timeout:120];
    
    [self registerJSBridgeForKey:kFSOpenWX handler:^(TPKWebViewContext *context, NSDictionary *data, WVJBResponseCallback responseCallback, tpk_stop stop, tpk_next next) {
        
        NSURL *wxURL = [[NSURL alloc] initWithString:@"weixin://"];
        [[UIApplication sharedApplication] openURL:wxURL];
        stop();
        
    }];
}

@end
