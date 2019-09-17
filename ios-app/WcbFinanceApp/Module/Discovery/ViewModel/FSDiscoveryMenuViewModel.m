//
//  FSDiscoveryMenuViewModel.m
//  Financeapp
//
//  Created by 叶帆 on 22/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryMenuViewModel.h"
#import "FSMenuData.h"
#import <YYModel/YYModel.h>
#import "FSDiscoveryMenuRequest.h"

@interface FSDiscoveryMenuViewModel()

@end

@implementation FSDiscoveryMenuViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        @weakify(self);
        _menuCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[self cacheMenuSignal:@(2)] merge:[self menuSignal:@(2)]];
        }];
        
        [_menuCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *responseDic) {
              
            self.menuModels = [self parseResponseDic:responseDic];
        }];
        
        //网络错误信息
        [_menuCommand.errors subscribeNext:^(NSError *error){
            self.error = error;
        }];
        
        //每次请求前，清理掉上次的错误
        [_menuCommand.executing subscribeNext:^(id x) {
           
            if([x boolValue] == YES)
            {
                self.error = nil;
            }
        }];
    }
    return self;
}

- (NSArray *)parseResponseDic:(NSDictionary *)responseDic {
    
    NSDictionary *data = [responseDic CM_dictionaryForKey:@"data"];
    
    NSArray *funArray    = [data fs_objectMaybeNilForKey:@"funcs" ofClass:[NSArray class]];
    NSArray *resultArray = [funArray.rac_sequence map:^id(id value) {
        return [FSMenuData yy_modelWithJSON:value];
    }].array;
    return resultArray;
}


//功能入口-cache
- (RACSignal *)cacheMenuSignal:(NSNumber *)menuId{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        FSDiscoveryMenuRequest *request = [[FSDiscoveryMenuRequest alloc] init];
        request.menuId = menuId;
        
        if ([request loadCacheWithError:nil]) {
            NSDictionary *responseDic = request.responseJSONObject;
            NSArray *resultArray = [self parseResponseDic:responseDic];
            if (resultArray) {
                [subscriber sendNext:responseDic];
            }
            [subscriber sendCompleted];
        } else {
            [subscriber sendCompleted];
        }
        
        return [RACDisposable disposableWithBlock:^{
            
            
        }];
        
    }];
}

//功能入口
- (RACSignal *)menuSignal:(NSNumber *)menuId{
    
    return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        FSDiscoveryMenuRequest *request = [[FSDiscoveryMenuRequest alloc] init];
        request.menuId = menuId;
        
        [request startWithCompletionBlockWithSuccess:^(__kindof CMBaseRequest * _Nonnull request) {
            
            NSDictionary *responseDic = request.responseJSONObject;
            
            NSArray *responseArray = [self parseResponseDic:responseDic];
            if(responseArray)
            {
                [subscriber sendNext:responseDic];
            }
        
            
            [subscriber sendCompleted];
            
        } failure:^(__kindof CMBaseRequest * _Nonnull request) {
            
            [subscriber sendError:request.error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
            
        }];
        
    }];
    
}


@end
