//
//  FinNotificationManagerSpec.m
//  Financeapp
//
//  Created by 叶帆 on 05/07/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FinNotificationManager.h"


SPEC_BEGIN(FinNotificationManagerSpec)

describe(@"FinNotificationManager", ^{
    context(@"when sharedInstance is called", ^{
        __block FinNotificationManager *manager = nil;
        it(@"should exist", ^{
            manager = [FinNotificationManager sharedInstance];
            [[manager shouldNot] beNil];
        });
        
        
    });
});

SPEC_END
