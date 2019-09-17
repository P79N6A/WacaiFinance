//
//  FSBindeMobileNumberViewModel.m
//  FinanceApp
//
//  Created by Alex on 7/12/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSBindeMobileNumberViewModel.h"
#import "LRRequestFactory.h"
#import "FSLRRequestFactory.h"


@implementation FSBindeMobileNumberViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        @weakify(self);
        self.bindMobileCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[self verfiyInputs]
                     flattenMap:^RACStream *(id value) {
                        @strongify(self);
                        return [self bindMobileNumberSignal];
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

        NSString *telString = ReplaceSpace(SafeString(self.mobile));
        NSString* verifyCode = SafeString(self.code);
        
        if ([telString length] == 0) {
            errorMsg = @"手机号不能为空";
        } else if (![telString fs_isValidPhoneNumber]) {
            errorMsg = NSLocalizedString(@"error_invalid_phone_number", nil);
        } else if (isEmpty(verifyCode)) {
            errorMsg = NSLocalizedString(@"error_verify_code", nil);
        }
        else if(!self.acceptAgreements)
        {
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


- (RACSignal *)bindMobileNumberSignal
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [LRRequestFactory bindMobileNumber:self.mobile code:self.code success:^(id json) {
            NSString *errorCode = [json objectForKey:@"code"];
            if (![errorCode isEqualToString:@"0"]) {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: SafeString([json objectForKey:@"error"])};
                NSError *error = [NSError errorWithDomain:@"https://user.wacai.com" code:0 userInfo:userInfo];
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:self.mobile];
                [subscriber sendCompleted];
            }
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }] doNext:^(NSString *mobile) {
        USER_INFO.mUserPhone = mobile;
        [USER_INFO save];
    }];
}


- (RACSignal *)getCodeSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        NSMutableDictionary *registerInfo = [[NSMutableDictionary alloc] init];
        registerInfo[@"mob"] = self.mobile;
        if (self.smsTips){
            registerInfo[@"tips"] = self.smsTips;
            self.smsTips = nil;
        }
        if (self.smsImageVerCode)
        {
            registerInfo[@"imgVerCode"] = self.smsImageVerCode.length > 0 ? self.smsImageVerCode : @"empty";
            self.smsImageVerCode = nil;
        }
        
        [FSLRRequestFactory getSmsCodeForBindMobileNumber:registerInfo success:^(id json) {
            
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
        registerInfo[@"mob"] = self.mobile;
        if (self.voiceTips){
            registerInfo[@"tips"] = self.voiceTips;
            self.voiceTips = nil;
        }
        if (self.voiceImageVerCode)
        {
            registerInfo[@"imgVerCode"] = self.voiceImageVerCode.length > 0 ? self.voiceImageVerCode : @"empty";
            self.voiceImageVerCode = nil;
        }
        
        [FSLRRequestFactory getVoiceCodeForMobileNumber:registerInfo success:^(id json) {
            
            [subscriber sendNext:json];
            [subscriber sendCompleted];
            
        } failure:^(NSError *error) {
            
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{}];
        
    }];
    
}

@end
