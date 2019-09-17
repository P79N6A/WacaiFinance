//
//  FSEnterMobileNumberViewModel.m
//  FinanceApp
//
//  Created by Alex on 7/5/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSEnterMobileNumberViewModel.h"
#import "LRRequestFactory.h"
#import "NSString+FSUtils.h"


@implementation FSEnterMobileNumberViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        @weakify(self);
        self.mobileHasRegisteCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return
            [[self validMobileSignal]
             flattenMap:^RACStream *(id value) {
                @strongify(self);
                return [self mobileHasRegisteSignal];
            }] ;
        }];
    }
    
    return self;
}

- (RACSignal *)validMobileSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if(![self.mobileString fs_isValidPhoneNumber]) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"error_invalid_phone_number", nil)};
            NSError *myError = [NSError errorWithDomain:@"https://8.wacai.com" code:0 userInfo:userInfo];
            [subscriber sendError:myError];
        } else {
            [subscriber sendNext:@""];
            [subscriber sendCompleted];
        }
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

- (RACSignal *)mobileHasRegisteSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [LRRequestFactory userRegisterMobileExist:self.mobileString success:^(id json) {
            NSString *errorCode = [json objectForKey:@"code"];
            if ([errorCode isEqualToString:@"2204"]) {
                [subscriber sendNext:@(YES)];
                [subscriber sendCompleted];
            } else if ([errorCode isEqualToString:@"0"]) {
                [subscriber sendNext:@(NO)];
                [subscriber sendCompleted];
            } else {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: SafeString([json objectForKey:@"error"])};
                NSError *error = [NSError errorWithDomain:@"https://user.wacai.com" code:0 userInfo:userInfo];
                [subscriber sendError:error];
            }
            
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

@end
