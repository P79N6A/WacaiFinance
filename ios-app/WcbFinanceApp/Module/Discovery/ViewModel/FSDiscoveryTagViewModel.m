//
//  FSDiscoveryTagViewModel.m
//  Financeapp
//
//  Created by 叶帆 on 22/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryTagViewModel.h"
#import "FSDiscoveryTagRequest.h"

@implementation FSDiscoveryTagViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        @weakify(self);
        _tagCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[self tagCacheSignal] merge:[self fetchTagSignal]];
        }];
        [_tagCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *responseDic) {
            
            self.tags = [self parseResponseDic:responseDic];
            
        }];
    }
    return self;
}

- (RACSignal *)fetchTagSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        FSDiscoveryTagRequest *request = [[FSDiscoveryTagRequest alloc] init];
        [request startWithCompletionBlockWithSuccess:^(__kindof CMBaseRequest * _Nonnull request) {
            NSDictionary *responseDic = request.responseJSONObject;
            NSArray *resultArray = [self parseResponseDic:responseDic];
            if (resultArray) {
                [subscriber sendNext:responseDic];
            }
            [subscriber sendCompleted];
        } failure:^(__kindof CMBaseRequest * _Nonnull request) {
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
            
            
        }];
    }];
}

- (RACSignal *)tagCacheSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        FSDiscoveryTagRequest *request = [[FSDiscoveryTagRequest alloc] init];
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

- (NSArray<FSDiscoveryTag *> *)parseResponseDic:(NSDictionary *)responseDic {
    NSMutableArray *resultArray = [NSMutableArray array];
    NSDictionary *data = [responseDic CM_dictionaryForKey:@"data"];
    NSArray *modules = [data CM_arrayForKey:@"modules"];
    [modules enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *moduleDic = (NSDictionary *)obj;
            NSString *tagID = [moduleDic CM_stringForKey:@"id"];
            NSString *name = [moduleDic CM_stringForKey:@"name"];
            FSDiscoveryTag *tag = [FSDiscoveryTag tagWithName:name ID:tagID];
            [resultArray fs_addObject:tag];
        }
    }];
    return resultArray;
}

@end
