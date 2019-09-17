//
//  FSSetPasswordViewModel.m
//  FinanceApp
//
//  Created by Alex on 7/4/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSSetPasswordViewModel.h"
#import "LRCenterManager.h"
#import "LRRequestFactory.h"
#import "LRHistoryUserManager.h"
#import "LRRegisterHandler.h"
#import <CMHash/CMMD5.h>

#import "FSLRRequestFactory.h"

#define MIN_PASSWORD_LEN      6
#define MAX_PASSWORD_LEN      16

@implementation FSSetPasswordViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _floatWindowViewModel = [FSFloatWindowViewModel new];
        _agreeProtocol = NO;
        @weakify(self);
        self.registerCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[self verfiyInputs]
                    flattenMap:^RACStream *(id value) {
                        @strongify(self);
                        return [self verfiyCodeSignal];
                    }]
                    flattenMap:^RACStream *(id value) {
                        @strongify(self);
                        return [self registerSignalWithTips:value];
                    }];
        }];
        
        
        self.getSMSCodeCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self getCodeSignal];
        }];
        
        self.getVoiceCodeCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self getVoiceCodeSignal];
        }];
    }
    
    return self;
}

- (RACSignal *)verfiyInputs
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *errorMsg = [NSString string];
        if (isEmpty(self.code)) {
            errorMsg = NSLocalizedString(@"error_verify_code", nil);
        }else if (isEmpty(self.account)) {
            errorMsg = @"用户名不能为空";
        }else if (isEmpty(self.password)) {
            errorMsg = NSLocalizedString(@"error_empty_password", nil);
        }else if (isEmpty(self.confirmPassword)) {
            errorMsg = NSLocalizedString(@"error_empty_confirm_password", nil);
        }else if (![self.password isEqualToString:self.confirmPassword]) {
            errorMsg = NSLocalizedString(@"error_confirm_password", nil);
        }else if ([self.password length] < MIN_PASSWORD_LEN || [self.password length] > MAX_PASSWORD_LEN) {
            errorMsg = NSLocalizedString(@"tips_correct_password", nil);
        }
        else if (!self.agreeProtocol) {
            errorMsg = NSLocalizedString(@"error_must_agree_protocol", nil);
        }
        
        if ([errorMsg length] > 0) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: SafeString(errorMsg)};
            NSError *error = [NSError errorWithDomain:@"https://user.wacai.com" code:0 userInfo:userInfo];
            [subscriber sendError:error];
        } else {
            [subscriber sendNext:@""];
            [subscriber sendCompleted];
        }
        
        return [RACDisposable disposableWithBlock:^{}];
    }];

}


- (RACSignal *)verfiyCodeSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSDictionary *param = @{@"mob":self.account,
                                @"verCode":self.code};
        
        [LRRequestFactory userRegisterWithMobileInfo:param success:^(id json) {
            NSString *errorCode = [json objectForKey:@"code"];
            if (![errorCode isEqualToString:@"0"]) {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: SafeString([json objectForKey:@"error"])};
                NSError *error = [NSError errorWithDomain:@"https://user.wacai.com" code:0 userInfo:userInfo];
                [subscriber sendError:error];
            } else {
                NSDictionary *data = json[@"data"];
                NSString *tips = [data CM_stringForKey:@"tips"];
                [subscriber sendNext:tips];
                [subscriber sendCompleted];
            }
            
        } failure:^(NSError *error) {
            [subscriber sendError:error];
            
        }];
        
        return [RACDisposable disposableWithBlock:^{}];
    }];
}


- (RACSignal *)registerSignalWithTips:(NSString *)tips
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSDictionary *param = @{@"tips":tips,
                                @"password":[CMMD5 md5:self.password],
                                @"mob":self.account};
        
        [LRRequestFactory userRegisterWithPasswordInfo:param success:^(id json) {
            NSString *errorCode = [json objectForKey:@"code"];
            if (![errorCode isEqualToString:@"0"]) {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: SafeString([json objectForKey:@"error"])};
                NSError *error = [NSError errorWithDomain:@"https://user.wacai.com" code:0 userInfo:userInfo];
                [subscriber sendError:error];
            } else {
                NSDictionary *userDic = [[json objectForKey:@"users"] firstObject];
                LRLoginUser *loginUser = [LRLoginUser userWithDic:userDic];
                loginUser.mIsRegisterLogin = YES;

                [LRHistoryUserManager insertHistoryUser:self.account];
                [[NSUserDefaults standardUserDefaults] setObject:self.account forKey:@"kWacaibaoLastLoginAccount"];
                [subscriber sendNext:loginUser];
                [subscriber sendCompleted];
            }
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{}];
    }] doNext:^(LRLoginUser *loginUser) {
        [[LRRegisterHandler sharedInstance] registerSuccessWithUser:loginUser];
        [[LRCenterManager sharedInstance]  updateRuntimeUser:loginUser];
        [USER_INFO updateUserInfo:loginUser];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_USER_SWITCHED object:nil];
    }];
}


- (RACSignal *)getCodeSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSMutableDictionary *registerInfo = [[NSMutableDictionary alloc] init];
        registerInfo[@"mob"] = self.account;
        if (self.smsTips){
            registerInfo[@"tips"] = self.smsTips;
            self.smsTips = nil;
        }
        if (self.smsImageVerCode)
        {
            registerInfo[@"imgVerCode"] = self.smsImageVerCode.length > 0 ? self.smsImageVerCode : @"empty";
            self.smsImageVerCode = nil;
        }
        
        [LRRequestFactory userRegisterStepGetSmsVercode:registerInfo success:^(id json) {
            
            [subscriber sendNext:json];
            [subscriber sendCompleted];
            
        } failure:^(NSError *error) {
            
            [subscriber sendError:error];
            
        }];
        
        return [RACDisposable disposableWithBlock:^{}];
    }];
}


- (RACSignal *)getVoiceCodeSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSMutableDictionary *registerInfo = [[NSMutableDictionary alloc] init];
        registerInfo[@"mob"] = self.account;
        if (self.voiceTips){
            registerInfo[@"tips"] = self.voiceTips;
            self.voiceTips = nil;
        }
        if (self.voiceImageVerCode)
        {
            registerInfo[@"imgVerCode"] = self.voiceImageVerCode.length > 0 ? self.voiceImageVerCode : @"empty";
            self.voiceImageVerCode = nil;
        }
        
        [FSLRRequestFactory userRegisterGetVoiceCode:registerInfo success:^(id json) {
            
            [subscriber sendNext:json];
            [subscriber sendCompleted];
            
        } failure:^(NSError *error) {
            
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{}];
    }];
    
}



@end
