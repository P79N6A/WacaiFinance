//
//  FSAgreementManager.m
//  WcbFinanceApp
//
//  Created by tesila on 2019/7/19.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSAgreementManager.h"
#import <FSHiveConfig/FSHCFetcher.h>
#import <FSHiveConfig/FSHCCache.h>

static NSString *const kAgreementKey = @"register_api";

@implementation FSAgreementManager

+ (void)loadRegisterAgreements:(FSAgreementLoadCompletionBlock)completion {
    // Cache
    FSAgreementInfo *agreementInfo = [self cacheOfAgreement];
    if (completion) {
        completion(agreementInfo, YES);
    }
    
    // Fetch
    [self fetchAgreement:completion];
}

+ (void)fetchAgreement:(FSAgreementLoadCompletionBlock)completion {
    [FSHCFetcher fetchAgreement:kAgreementKey class:[FSAgreementInfo class] completion:^(BOOL isSuccess, id  _Nullable object) {
        if (completion) {
            completion(object, NO);
        }
    }];
}

+ (FSAgreementInfo *)cacheOfAgreement {
    return [FSHCCache localCacheOfKey:kAgreementKey class:[FSAgreementInfo class]];
}



@end
