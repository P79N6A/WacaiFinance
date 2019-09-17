//
//  FSLoadingMiddleware.m
//  WcbFinanceApp
//
//  Created by 金镖 on 2018/9/12.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSLoadingMiddleware.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface FSLoadingMiddleware ()

//@property (nonatomic, strong) UIView<CMWebViewLoadingProtocol> *loadingView;//loading加载提示
@property (nonatomic, strong) MBProgressHUD *hud;//loading加载提示

@end

@implementation FSLoadingMiddleware

-(void)setupMiddleWareFunctionMap
{
    [self registerHandlerOnCreateWebView:^(TPKWebViewContext *context,tpk_stop stop, tpk_next next) {
        MBProgressHUD *hud = [self hudWithView:context.webview.view];
        [hud showAnimated:YES];
        next();
    }];
    
    [self registerHandlerOnPageFinish:^(TPKWebViewContext *context,NSError *error,tpk_stop stop, tpk_next next) {

        MBProgressHUD *hud = (MBProgressHUD *)[context.webview.view viewWithTag:100000];
        [hud hideAnimated:YES];
        
        next();
    }];
}

- (MBProgressHUD *)hudWithView:(UIView *)rootView{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:rootView animated:YES];
    hud.tag = 100000;
    hud.removeFromSuperViewOnHide = NO;
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
    hud.userInteractionEnabled = NO;
    
    return hud;
}


@end
