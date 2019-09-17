//
//  FSAssetUserInfoViewModel.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/17.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSAssetUserLevelViewModel.h"
#import <CMNetworking.h>
#import "EnvironmentInfo.h"
#import "FSUserLevelInfo.h"
#import "FSUserLevelInfoRequest.h"

@implementation FSAssetUserLevelViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        @weakify(self);
        _userLevelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self fetchLevelInfoSignal];
        }];
        [[_userLevelCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
            @strongify(self);
            RACTupleUnpack(NSString *levelName, NSNumber *levelValue) = tuple;
            
            FSUserLevelInfo *levelInfo = [[FSUserLevelInfo alloc] init];
            levelInfo.levelName = levelName;
            levelInfo.levelValue = [levelValue intValue];

            self.levelInfo = levelInfo;
        }];
        
        [[_userLevelCommand.errors deliverOnMainThread] subscribeNext:^(NSError *error) {
            FSUserLevelInfo *levelInfo = [[FSUserLevelInfo alloc] init];
            levelInfo.levelName = @"--会员";
            levelInfo.levelValue = 0;
            
            self.levelInfo = levelInfo;
        }];
            
        
    }
    return self;
}

- (RACSignal *)fetchLevelInfoSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        FSUserLevelInfoRequest *request = [[FSUserLevelInfoRequest alloc] init];
        [request startWithCompletionBlockWithSuccess:^(__kindof CMBaseRequest * _Nonnull request) {
            NSDictionary *responseDic = request.responseJSONObject;
            NSInteger code = [[responseDic fs_objectMaybeNilForKey:@"code"] integerValue];
            if (code == 0) {
                NSDictionary *data = [responseDic fs_objectMaybeNilForKey:@"data" ofClass:[NSDictionary class]];
                
                NSString *levelName = [data fs_objectMaybeNilForKey:@"showLevel" ofClass:[NSString class]];
                NSNumber *levelValue = [data fs_objectMaybeNilForKey:@"level" ofClass:[NSNumber class]];
                
                [subscriber sendNext:RACTuplePack(levelName, levelValue)];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:nil];
            }
            
        } failure:^(__kindof CMBaseRequest * _Nonnull request) {
            [subscriber sendError:nil];
        }];
        
        
        return [RACDisposable disposableWithBlock:^{}];
    }];
}


@end
