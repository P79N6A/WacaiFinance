//
//  FSEnterPasswordViewModel.m
//  FinanceApp
//
//  Created by Alex on 7/5/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSEnterPasswordViewModel.h"
#import "UserInfo.h"
#import "EnvironmentInfo.h"
#import "LRLoginUserData.h"
#import "LRCenterManager.h"
#import "LRRequestFactory.h"
#import "LRHistoryUserManager.h"
#import "LRRegisterHandler.h"
#import <CMhash/CMMD5.h>
#import <NeutronBridge/NeutronBridge.h>
#import <NativeQS/NQSParser.h>
#import <CMUIViewController/UIViewController+CMUtil.h>
#import <CMNSString/NSString+CMUtil.h>

@interface FSEnterPasswordViewModel ()

@property (nonatomic, assign, readwrite) BOOL needVerifyCode;

@end

@implementation FSEnterPasswordViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        @weakify(self);
        self.loginCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
             return
            [[[self valiedInputsSignal]
             flattenMap:^RACStream *(id value) {
                 @strongify(self);
                 return [self loginSignal];
             }] flattenMap:^RACStream *(LRLoginUser *loginUser) {
                 @strongify(self);
                 return [self hasBindMobileSignal:loginUser];
             }];
        }];
        
         
        
        RAC(self, tipString) = [RACObserve(self, accountString) map:^id(NSString *value) {
            
            NSString *accountString = [value fs_isValidPhoneNumber] ? [value CM_getsecretString] : SAFE_STRING(value);
            NSString *tipString = [NSString stringWithFormat:@"Hi, %@, 欢迎回来!", accountString];

            return tipString;
        }];
    }
    
    return self;
}

- (RACSignal *)valiedInputsSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if (isEmpty(self.accountString)) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"用户名不能为空", NSLocalizedFailureReasonErrorKey: @"InvalidValue"};
            NSError *error = [[NSError alloc] initWithDomain:@"" code:0 userInfo:userInfo];
            [subscriber sendError:error];
        } else if (isEmpty(self.pwdString)) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"error_password_empty", nil), NSLocalizedFailureReasonErrorKey: @"InvalidValue"};
            NSError *error = [[NSError alloc] initWithDomain:@"" code:0 userInfo:userInfo];
            [subscriber sendError:error];
        } else if (self.needVerifyCode && isEmpty(self.verifyCode)) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"验证码不能为空", NSLocalizedFailureReasonErrorKey: @"InvalidValue"};
            NSError *error = [[NSError alloc] initWithDomain:@"" code:0 userInfo:userInfo];
            [subscriber sendError:error];
        }
        else if(!self.acceptAgreements)
        {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:NSLocalizedString(@"error_must_agree_protocol", nil), NSLocalizedFailureReasonErrorKey: @"InvalidValue"};
            NSError *error = [[NSError alloc] initWithDomain:@"" code:0 userInfo:userInfo];
            [subscriber sendError:error];
        }
        else {
            [subscriber sendNext:@""];
            [subscriber sendCompleted];
        }
        
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

- (RACSignal *)loginSignal
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        LRLoginUserData *usrData = [[LRLoginUserData alloc] init];
        usrData.mUsername = self.accountString;
        usrData.mPassword = [CMMD5 md5:self.pwdString];
        if (self.needVerifyCode) {
            usrData.mTips = self.verifyTips;
            usrData.mVerificationCode = self.verifyCode;
        }
        
        NSMutableDictionary *mutaParams = [[NSMutableDictionary alloc] init];
        mutaParams[@"username"] = self.accountString;
        mutaParams[@"password"] = self.pwdString;
        
        if(self.needVerifyCode)
        {
            mutaParams[@"tips"] = self.verifyTips;
            mutaParams[@"imgVercode"] = self.verifyCode;
        }
        NSString *source = [NSString stringWithFormat:@"%@?%@", @"nt://sdk-user/loginWithUsernameAndPassword", [NQSParser queryStringifyObject:mutaParams]];
        UIViewController * fromVC = [UIViewController CM_curViewController];
        @weakify(self)
        // 调用统跳
        NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:fromVC];
        [ns ntWithSource:source
      fromViewController:fromVC
              transiaion:NTBViewControllerTransitionPush
                  onDone:^(NSString * _Nullable result) {
                      @strongify(self)
                      NSDictionary * info = [result CM_JsonStringToDictionary];
                      NSString *status = info[@"status"];
                      if([status isEqualToString:@"authFailed"])
                      {
                          NSDictionary *userInfo = @{NSLocalizedDescriptionKey: SafeString([info objectForKey:@"msg"]),
                                                     NSLocalizedRecoverySuggestionErrorKey: SafeString([info objectForKey:@"tips"])};
                          self.verifyTips = SafeString([info objectForKey:@"tips"]);
                          NSError *error = [NSError errorWithDomain:@"sdk-user" code:0 userInfo:userInfo];
                          
                          [subscriber sendError:error];
                          
                      }
                      else if([status isEqualToString:@"imgVercode"])//图形验证码
                      {
                          NSDictionary *userInfo = @{NSLocalizedDescriptionKey: SafeString([info objectForKey:@"msg"]),
                                                     NSLocalizedRecoverySuggestionErrorKey: SafeString([info objectForKey:@"tips"])};
                          self.verifyTips = SafeString([info objectForKey:@"tips"]);
                          NSError *error = [NSError errorWithDomain:@"sdk-user" code:0 userInfo:userInfo];
                          
                          [subscriber sendError:error];
                      }
                      else if([status isEqualToString:@"success"] || [status isEqualToString:@"multipleUser"])
                      {
                          NSArray *users = info[@"users"];
                          if(users.count)
                          {
                              NSDictionary *firsetUser = [users firstObject];
                              LRLoginUser *returnUser = [LRLoginUser userWithDic:firsetUser];
                              [LRHistoryUserManager insertHistoryUser:self.accountString];
                              
                              [[NSUserDefaults standardUserDefaults] setObject:self.accountString forKey:@"kWacaibaoLastLoginAccount"];
                              
                              
                              returnUser.mLoginWay = LRThirdLoginWayNone;
                              returnUser.mLoginType = LRLoginWayTypePhone;
                              returnUser.mIsRegisterLogin = NO;
                              [subscriber sendNext:returnUser];
                              [subscriber sendCompleted];
                          }
                      }
                      else
                      {
                          NSLog(@"status is %@", status);
                      }
                      
                  } onError:^(NSError * _Nullable error) {
                      [subscriber sendError:error];
                  }];
        
        
        
        return [RACDisposable disposableWithBlock:^{ }];
    }] doNext:^(LRLoginUser *loginUser) {
        [[LRCenterManager sharedInstance]  updateRuntimeUser:loginUser];
        [USER_INFO updateUserInfo:loginUser];
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
        if (hasBindMobile.boolValue) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_USER_SWITCHED object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:FSLoginDidFinishNotification object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:LRUserDidLoginSuccessNotification
                                                                    object:nil];
            });
        }
    }];
}

#pragma mark - getter & setter 
- (NSURL *)verifyCodeImageURL {
    if (!_verifyCodeImageURL) {
        _verifyCodeImageURL = [NSURL new];
    }
    _verifyCodeImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/validate/v1/kaptcha/new?59&token=%@",[[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeMainDomain], self.verifyTips]];
    return _verifyCodeImageURL;
}

- (BOOL)needVerifyCode {
    if (self.verifyTips && ![self.verifyTips isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)verifyTips {
    if (!_verifyTips) {
        _verifyTips = [NSString new];
    }
    return _verifyTips;
}

- (NSString *)verifyCode {
    if (!_verifyCode) {
        _verifyCode = [NSString new];
    }
    return _verifyCode;
}

@end
