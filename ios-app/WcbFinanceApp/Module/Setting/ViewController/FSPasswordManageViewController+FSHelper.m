//
//  FSPasswordManageViewController+FSHelper.m
//  WcbFinanceApp
//
//  Created by 叶帆 on 12/01/2018.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSPasswordManageViewController+FSHelper.h"
#import <FSStringUtils.h>
#import "FSTouchIDHelper.h"
#import "FSChangePasswordViewController.h"
#import "EnvironmentInfo.h"
#import <NeutronBridge/NeutronBridge.h>
#import <CMUIViewController/UIViewController+CMUtil.h>
#import <i-Finance-Library/FSSDKGotoUtility.h>


@implementation FSPasswordManageViewController (FSHelper)

- (BOOL)hasSetGesture {
    NSString *savedPassword = [[NSUserDefaults standardUserDefaults] objectForKey:[FSStringUtils getPasswordKey]];
    return [savedPassword CM_isValidString];
}

- (BOOL)shouldEnableBiometricsAuthSwitch {
    return [self hasSetGesture] && ([FSTouchIDHelper checkTouchIDStatusOfSystem] == FSTouchIDStatusSystemAvailable);
}

#pragma mark - Event Response

- (void)onClickWacaiBaoling {
    
    [UserAction skylineEvent:@"finance_wcb_accountsetting_treasure_click"];
    
    NSString *linkURL = [NSString stringWithFormat:@"%@/m/wacpay/pwd/index.htm?wacaiClientNav=0&back_url=wacai://close&need_zinfo=1",[[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeFinance]];
    [FSSDKGotoUtility openURL:linkURL from:self];
}

- (void)onClickBankPassword:(NSString *)url
{
    [FSSDKGotoUtility openURL:url from:self];
}

- (void)onModifyGesture {
     if (![USER_INFO isLogged]) {
        return [CMUIDisappearView showMessage:NSLocalizedString(@"error_not_login", nil)];
    }
    
    [FSGotoUtility gotoGestureLockViewController:self.navigationController
                                            type:FSGestureLockTypeUpdate
                                        animated:YES];
}

- (void)onModifyPassword {
     if (![USER_INFO isLogged]) {
        return [CMUIDisappearView showMessage:NSLocalizedString(@"error_not_login", nil)];
    }
    NSString *source = [NSString stringWithFormat:@"%@", @"nt://sdk-user/changepassword"];
    UIViewController * fromVC = [UIViewController CM_curViewController];
    NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:fromVC];
    [ns ntWithSource:source
  fromViewController:fromVC
          transiaion:NTBViewControllerTransitionPush
              onDone:^(NSString * _Nullable result) {
                  NSLog(@"data is %@", result);
              } onError:^(NSError * _Nullable error) {
                  NSLog(@"error is %@", error);
              }];
}

- (FSBankAccountEntranceViewModel *)convertViewModelOfBankAccountEntranceModel:(FSBankAccountEntranceModel *)model {
    FSBankAccountEntranceViewModel *viewModel = [[FSBankAccountEntranceViewModel alloc] init];
    viewModel.shouldShow = [model.custodyPasswordSwitch boolValue];
    viewModel.stateText = model.hasPassword ? @"已设置" : @"未设置";
    UIColor *blackColor = [UIColor colorWithHexString:@"#999999"];
    UIColor *redColor = [UIColor colorWithHexString:@"#d94b40"];
    viewModel.stateColor = model.hasPassword ? blackColor : redColor;
    
    viewModel.pwdUrl = model.pwdUrl;
    
    return viewModel;
}
@end
