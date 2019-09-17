//
//  FinNotificationBodySpec.m
//  Financeapp
//
//  Created by 叶帆 on 22/06/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FinNotificationBody.h"


SPEC_BEGIN(FinNotificationBodySpec)

describe(@"FinNotificationBody", ^{
    context(@"when is created with dic", ^{
        __block FinNotificationBody *body = nil;
        beforeEach(^{
            NSDictionary *info = @{@"title" : @"I'm title",
                                   @"url"   : @"I'm url"
                                   };
            body = [[FinNotificationBody alloc] initWithDic:info];
        });
        
        it(@"should exist", ^{
            [[body shouldNot] beNil];
        });
        
        it(@"should has title", ^{
            [[body.mNotifyTitle shouldNot] beNil];
        });
        
        it(@"should has url", ^{
            [[body.mNotifyUrl shouldNot] beNil];
        });
        
    });
});

SPEC_END
