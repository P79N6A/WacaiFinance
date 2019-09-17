//
//  FSDiscoveryBannerSpec.m
//  Financeapp
//
//  Created by 叶帆 on 30/10/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD.. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSDiscoveryBanner.h"


SPEC_BEGIN(FSDiscoveryBannerSpec)

describe(@"FSDiscoveryBanner", ^{
    context(@"When is created", ^{
            
        __block FSDiscoveryBanner *banner = nil;
        
        beforeAll(^{
            banner = [FSDiscoveryBanner new];
            banner.bannerID = @"666";
        });
        
        it(@"should exist", ^{
            [[banner shouldNot] beNil];
        });
        
        it(@"should response to diffIdentifier and return self", ^{
            [[[banner performSelector:@selector(diffIdentifier)] should] equal:banner];
        });
        
        it(@"should return No compare with other object", ^{
            [[theValue([banner isEqualToDiffableObject:[FSDiscoveryBanner new]]) should] equal:theValue(NO)];
        });
        
    });
});

SPEC_END
