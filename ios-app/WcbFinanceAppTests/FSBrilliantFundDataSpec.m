//
//  FSBrilliantFundDataSpec.m
//  Financeapp
//
//  Created by kuyeluofan on 04/07/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSBrilliantFundData.h"


SPEC_BEGIN(FSBrilliantFundDataSpec)

describe(@"FSBrilliantFundData", ^{
    context(@"when is create", ^{
        
        __block FSBrilliantFundData *data = nil;
        
        beforeAll(^{
            data = [[FSBrilliantFundData alloc] init];
        });
        
        it(@"should exist", ^{
            [[data shouldNot] beNil];
        });
        
        it(@"should response to diffIdentifier and return self", ^{
            [[[data performSelector:@selector(diffIdentifier)] should] equal:data];
        });
        
        it(@"should return No compare with other object", ^{
            [[theValue([data isEqualToDiffableObject:[NSObject new]]) should] equal:theValue(NO)];
        });
        
        it(@"should return No compare with other object", ^{
            [[theValue([data isEqualToDiffableObject:data]) should] equal:theValue(YES)];
        });
        
    
    });

});

SPEC_END
