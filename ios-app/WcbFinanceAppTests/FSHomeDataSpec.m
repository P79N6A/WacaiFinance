//
//  FSHomeDataSpec.m
//  Financeapp
//
//  Created by 叶帆 on 04/07/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSHomeData.h"


SPEC_BEGIN(FSHomeDataSpec)

describe(@"FSHomeData", ^{
    context(@"when is create", ^{
        
        __block FSHomeData *data = nil;
        
        beforeAll(^{
            data = [[FSHomeData alloc] init];
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
            FSHomeData *unarchiveData = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
            [[unarchiveData shouldNot] beNil];
        });
        
        
    });

});

SPEC_END
