//
//  FSFundRequestHostSpec.m
//  Financeapp
//
//  Created by 叶帆 on 21/06/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSFundRequestHost.h"
#import "EnvironmentInfo.h"


SPEC_BEGIN(FSFundRequestHostSpec)

describe(@"FSFundRequestHost", ^{
    context(@"when ask for fundHost", ^{
        EnvironmentInfo *environmentInfo = [EnvironmentInfo sharedInstance];
        it(@"should return host url when debug", ^{
            [environmentInfo stub:@selector(isDebugEnvironment) andReturn:theValue(YES)];
            [[[FSFundRequestHost fs_FundHost] shouldNot] beNil];
        });
        
        it(@"should return host url when release", ^{
            [environmentInfo stub:@selector(isDebugEnvironment) andReturn:theValue(YES)];
            [[[FSFundRequestHost fs_FundHost] shouldNot] beNil];
        });
    });
});

SPEC_END
