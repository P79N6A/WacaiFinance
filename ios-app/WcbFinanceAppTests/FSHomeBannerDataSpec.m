//
//  FSHomeBannerDataSpec.m
//  Financeapp
//
//  Created by 叶帆 on 22/06/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSHomeBannerData.h"


SPEC_BEGIN(FSHomeBannerDataSpec)

describe(@"FSHomeBannerData", ^{
    __block FSHomeBannerData *data = nil;
    context(@"when is created", ^{
        
        beforeEach(^{
            data = [[FSHomeBannerData alloc] init];
        });
        
        it(@"should exist", ^{
            [[data shouldNot] beNil];
        });
        
        it(@"should be able to archived and unarchive", ^{
            NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:data];
            [[archivedData shouldNot] beNil];
            FSHomeBannerData *unarchiveData = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
            [[unarchiveData shouldNot] beNil];
        });
        
    });
});

SPEC_END
