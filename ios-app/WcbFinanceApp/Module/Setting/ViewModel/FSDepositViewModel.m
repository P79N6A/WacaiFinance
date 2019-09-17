//
//  FSDepositViewModel.m
//  WcbFinanceApp
//
//  Created by xingyong on 26/01/2018.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDepositViewModel.h"
#import "FSDepositRequest.h"
#import <YYModel/YYModel.h>

@implementation FSDepositViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize{
    
    @weakify(self)
    _depositCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        
        return [[self cacheDepositSignal] merge:[self depositSignal]];
    }];
    
    [_depositCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *responseDic) {
        @strongify(self);
 
        FSDepositData *depositData = [FSDepositData yy_modelWithDictionary:responseDic];
        
        self.depositData = depositData;

        
    }];
    
}

- (RACSignal *)depositSignal{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        FSDepositRequest *request = [[FSDepositRequest alloc] init];
 
        [request startWithCompletionBlockWithSuccess:^(__kindof CMBaseRequest * _Nonnull request) {
            
            NSDictionary *responseDic = [request.responseJSONObject fs_objectMaybeNilForKey:@"data"];
            
            if (responseDic) {
                [subscriber sendNext:responseDic];
            }
            
            [subscriber sendCompleted];
            
        } failure:^(__kindof CMBaseRequest * _Nonnull request) {
            [subscriber sendCompleted];
            
        }];
        return [RACDisposable disposableWithBlock:^{}];
    }];
    
    return signal;
}
- (RACSignal *)cacheDepositSignal{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        FSDepositRequest *request = [[FSDepositRequest alloc] init];
 
        if ([request loadCacheWithError:nil]) {
            
            NSDictionary *responseDic = [request.responseJSONObject fs_objectMaybeNilForKey:@"data"];
            if (responseDic) {
                [subscriber sendNext:responseDic];
            }
            
            [subscriber sendCompleted];
        } else {
            [subscriber sendCompleted];
        }
        return [RACDisposable disposableWithBlock:^{}];
    }];
}
@end
