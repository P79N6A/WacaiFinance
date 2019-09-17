//
//  FSDiscoveryBindPromotionViewModel.m
//  Financeapp
//
//  Created by 叶帆 on 23/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryBindPromotionViewModel.h"

typedef NS_ENUM(NSUInteger, FSUserFinanceState) {
    FSUserFinanceStateNegative = 0,
    FSUserFinanceStatePositive,
    FSUserFinanceStateUnknown,
};

@implementation FSDiscoveryBindPromotionViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        @weakify(self);
        _promotionTextCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self fetchBindPromotionSignal];
        }];
        
        [_promotionTextCommand.executionSignals.switchToLatest.distinctUntilChanged subscribeNext:^(NSString *text) {
            self.bindPromotionText = text;
        }];
    }
    return self;
}

- (RACSignal *)fetchBindPromotionSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (![USER_INFO isLogged]) {
            [subscriber sendNext:[self defaultBindPromotionText]];
            [subscriber sendCompleted];
        } else {
            
            [[FSRequestManager manager] getRequestURL:fs_userStatus
                                           parameters:nil
                                              success:^(FSResponseData *response, id responseDic) {
                                                  NSNumber *bindCardStatus = [responseDic fs_objectMaybeNilForKey:@"bindCardStatus"];
                                                  NSNumber *realNameStatus = [responseDic fs_objectMaybeNilForKey:@"realNameStatus"];
                                                  USER_INFO.bindCardStatus = bindCardStatus;
                                                  USER_INFO.realNameStatus = realNameStatus;
                                                  [USER_INFO save];
                                                  BOOL hasRealName = realNameStatus.integerValue == 1;
                                                  BOOL hasBindCard = bindCardStatus.integerValue == 1;
                                                  NSString *text = [self convertBindPromotionTextWithNameStatus:hasRealName cardStatus:hasBindCard];
                                                  [subscriber sendNext:text];
                                                  [subscriber sendCompleted];
                                                  
                                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                  [subscriber sendError:error];
                                              }];
        }
        return [RACDisposable disposableWithBlock:^{}];
    }];
}

- (NSString *)convertBindPromotionTextWithNameStatus:(BOOL)hasRealName cardStatus:(BOOL)hasBindCard {
    NSString *text = @"";
    if (![USER_INFO isLogged]) {
        text = @"";
    } else {
        if (hasRealName) {
            if (hasBindCard) {
                text = @"";
            } else {
                text = @"绑定银行卡后即可开始投资，立即绑定";
            }
        } else {
            text = @"实名认证后即可开始投资，立即认证";
        }
    }
    return text;
}

- (NSString *)defaultBindPromotionText {
    NSNumber *defaultBindCardStatus = USER_INFO.bindCardStatus ? USER_INFO.bindCardStatus : @(FSUserFinanceStateUnknown);
    NSNumber *defaultRealNameStatus = USER_INFO.realNameStatus ? USER_INFO.realNameStatus : @(FSUserFinanceStateUnknown);
    BOOL hasRealName = defaultRealNameStatus.integerValue == 1;
    BOOL hasBindCard = defaultBindCardStatus.integerValue == 1;
    return [self convertBindPromotionTextWithNameStatus:hasRealName cardStatus:hasBindCard];
}

@end
