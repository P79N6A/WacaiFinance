//
//  FSHomeMarketDataSpec.m
//  Financeapp
//
//  Created by 叶帆 on 04/07/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSHomeMarketData.h"


SPEC_BEGIN(FSHomeMarketDataSpec)

describe(@"FSHomeMarketData", ^{
    context(@"when is create", ^{
        
        __block FSHomeMarketData *data = nil;
        
        beforeAll(^{
            data = [[FSHomeMarketData alloc] init];
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
        
        it(@"should be able to archived and unarchive", ^{
            NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:data];
            [[archivedData shouldNot] beNil];
            FSHomeMarketData *unarchiveData = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
            [[unarchiveData shouldNot] beNil];
        });
        
        
    });

});

SPEC_END
