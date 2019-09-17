//
//  FSBBSMiddleware.m
//  WcbFinanceApp
//
//  Created by xingyong on 05/12/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSBBSMiddleware.h"
#import "TPKWebViewController.h"
#import <NeutronBridge/NeutronBridge.h>
#import <NativeQS/NQSParser.h>
#import <CMUIViewController/UIViewController+CMUtil.h>

@implementation FSBBSMiddleware

-(void)setupMiddleWareFunctionMap
{
    [self registerHandlerOnURLLoad:^BOOL(TPKWebViewContext *context, NSString *URLString, tpk_stop stop) {
        
        if (URLString.length > 0) {

            if ([URLString containsString:@"wacai://bbs.home"]) {
                
                 [self pushBBSViewController:context.webview];
                
                return NO;
            }
            
            
        }
        return YES;
    }];
}

- (void)pushBBSViewController:(UIViewController *)baseViewController{
     
    NSDictionary *param = @{@"showBackButton" : @(YES),@"nt_present":@(YES)};

    NSString *source = [NSString stringWithFormat:@"%@?%@", @"nt://sdk-bbs2/homepage", [NQSParser queryStringifyObject:param]];
    UIViewController * fromVC = [UIViewController CM_curViewController];
    // 调用统跳
    NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:fromVC];
    [ns ntWithSource:source
  fromViewController:fromVC
          transiaion:NTBViewControllerTransitionPush
              onDone:^(NSString * _Nullable result) {
                  
              } onError:^(NSError * _Nullable error) {
                  
              }];
    
    
}
@end
