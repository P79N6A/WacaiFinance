//
//  FSLoginViewModel.m
//  FinanceApp
//
//  Created by Alex on 1/17/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSLoginViewModel.h"
#import "UIViewController+CMUtil.h"
#import "UIViewController+FSUtil.h"
#import "LRCenterManager.h"
#import "LRRequestFactory.h"
#import "LRHistoryUserManager.h"
#import "SocialShareSDK.h"
#import <NeutronBridge/NeutronBridge.h>
#import <SdkUser/LRUtil.h>
#import <NativeQS/NQSParser.h>
#import <CMUIViewController/UIViewController+CMUtil.h>
#import <CMNSString/NSString+CMUtil.h>

@interface FSLoginViewModel ()


@end

@implementation FSLoginViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)initialize
{
    @weakify(self);
    self.thirdLogin = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *platform) {
        @strongify(self);
        RACSignal *thirdPartyLogin = [self thirdLoginSignalWithPlatform:platform];
        return [thirdPartyLogin
                flattenMap:^RACStream *(id value) {
            @strongify(self);
            return [self hasBindMobileSignal:value];
        }];
    }];
    
    self.thirdLogin.allowsConcurrentExecution = YES;
}
 
- (RACSignal *)thirdLoginSignalWithPlatform:(id)platform
{
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        LRThirdLoginWay loginWay = [platform integerValue];
        
        NSString *lc_third_type;
        if(loginWay == LRThirdLoginWayWeChat){
            lc_third_type = @"1";
        }else if(loginWay == LRThirdLoginWaySinaWeibo){
            lc_third_type = @"2";
        }else if(loginWay == LRThirdLoginWayQQ){
            lc_third_type = @"3";
        }
        
        NSString *lotEventName = @"RegistrationThirdResult";
        NSString *skylineEventName = @"finance_wcb_register_third_result";
        if(!self.fromRegistration)
        {
            lotEventName = @"LoginThirdResult";
            skylineEventName = @"finance_wcb_login_thirdlogin_result";
        }
        
        LRLoginMethod method = [LRUtil loginMethodFromThirdLoginWay:loginWay];
        
        NSDictionary *params = @{@"thirdMethod":@(method)};
        NSString *source = [NSString stringWithFormat:@"%@?%@", @"nt://sdk-user/loginWithThirdMethod", [NQSParser queryStringifyObject:params]];
        UIViewController * fromVC = [UIViewController CM_curViewController];
        NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:fromVC];
        [ns ntWithSource:source
      fromViewController:fromVC
              transiaion:NTBViewControllerTransitionPush
                  onDone:^(NSString * _Nullable result) {
                      NSDictionary * info = [result CM_JsonStringToDictionary];
                      NSString *msg = info[@"status"];
                      if(!msg)
                      {
                          msg = @"";
                      }
                      NSDictionary *attribute;
                      
                      if([info[@"status"] isEqualToString:@"success"])
                      {
                          NSArray *users = info[@"users"];
                          if(users.count)
                          {
                              LRLoginUser *user = [[LRLoginUser alloc] initWithDic:users[0]];
                              
                              [LRHistoryUserManager insertHistoryUser:[user userNameForLogin]];
                              
                              user.mLoginType = LRLoginWayTypeUserName;
                              user.mIsRegisterLogin = NO;
                              
                              [subscriber sendNext:user];
                              [subscriber sendCompleted];
                              
                              //埋点
                              attribute = @{@"lc_result":@"1",
                                            @"lc_third_type":lc_third_type,
                                            @"lc_error_type":@"",
                                            @"lc_error_message":msg
                                            };
                          }
                          else
                          {
                              [subscriber sendError:nil];
                          }
                      }
                      else if([info[@"status"] isEqualToString:@"showLoadingUI"])
                      {
                          NSLog(@"loading ui");
                          
                      }
                      else
                      {
                          attribute = @{@"lc_result":@"0",
                                        @"lc_third_type":lc_third_type,
                                        @"lc_error_type":@"",
                                        @"lc_error_message":msg
                                        };
                      }
                      
                      [UserAction skylineEvent:skylineEventName attributes:attribute];

                  } onError:^(NSError * _Nullable error) {
                      NSString *errorType = [NSString stringWithFormat:@"%@", @(error.code)];
                      NSString *errorMsg = error.domain;
                      if(!errorMsg)
                      {
                          errorMsg = @"";
                      }
                      
                      NSDictionary *attribute = @{@"lc_result":@"0",
                                                  @"lc_third_type":lc_third_type,
                                                  @"lc_error_type":errorType,
                                                  @"lc_error_message":errorMsg
                                                  };
                      //attribute
                      [UserAction skylineEvent:skylineEventName attributes:attribute];
                      
                      //埋点
                      [subscriber sendError:nil];
                      
                  }];
        
        
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"------------disposableWithBlock---------- ");
        }];
    }] timeout:120
   onScheduler:[RACScheduler mainThreadScheduler]]
        doNext:^(LRLoginUser *loginUser) {
            
            NSLog(@"loginUser ------ %@",loginUser);
            [USER_INFO updateUserInfo:loginUser];
            NSLog(@"---mTokenIDBlock--  %@",[CMAppProfile sharedInstance].mTokenIDBlock());
            
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_USER_SWITCHED object:nil];
    }];
}


- (RACSignal *)hasBindMobileSignal:(LRLoginUser *)user
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        BOOL hasBindMobile = [user.mMobilePhoneNumber length] > 0;
        [subscriber sendNext:@(hasBindMobile)];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{}];
    }] doNext:^(NSNumber *hasBindMobile) {
        if ([hasBindMobile boolValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:FSLoginDidFinishNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:LRUserDidLoginSuccessNotification
                                                                object:nil];
        }
    }];
}


@end
