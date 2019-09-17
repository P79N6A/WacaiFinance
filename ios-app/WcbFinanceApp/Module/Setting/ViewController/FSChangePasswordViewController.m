//
//  FSChangePasswordViewController.m
//  FinanceApp
//
//  Created by Alex on 27/10/2016.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSChangePasswordViewController.h"
#import "LRCenterManager.h"
#import "LoginRegisterSDK+PersonalCenter.h"
#import "CMUIDisappearView.h"


static NSString *changePassword = @"/change_pwd_h5"; //修改密码

static NSString *const LRjsBridgeChangePwd = @"changePwd";

@interface FSChangePasswordViewController ()

@end

@implementation FSChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideNaviBar:YES];
    
    self.mRequestHeadersBlock = ^NSDictionary * {
        NSLog(@"%@",[LoginRegisterSDK runtimeUser].mToken);
        return @{@"X-ACCESS-TOKEN":[LoginRegisterSDK runtimeUser].mToken?:@""};
    };
    
    [LoginRegisterSDK getUserInfo:^(LRLoginUser *user) {
        
        [self changePassword];

    } errorHappened:^(NSError *error) {
        
    }];
    
    @weakify(self);
    NSDictionary *personalCenterJSFuns = @{
                                           LRjsBridgeChangePwd: ^(NSDictionary *data, WVJBResponseCallback responseCallback) {
                                               @strongify(self);
                                               [CMUIDisappearView showMessage:@"密码已失效，请重新登录"];
                                               [USER_INFO logout];
                                               [self.navigationController popToRootViewControllerAnimated:YES];
                                           },
                                           
                                           
                                           };
    [self addJSBridgeFunctions:personalCenterJSFuns];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}
-(void)changePassword {
    [self setNaviBarTitle:@"修改密码"];
    [self setRequestURLStr:[NSString stringWithFormat:@"%@%@%@",[LRCenterManager sharedInstance].requestScheme,[LRCenterManager sharedInstance].requestHost,changePassword]];
    [self reloadWebView];
}


@end
