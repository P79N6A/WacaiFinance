//
//  FSProductTabDataSpec.m
//  Financeapp
//
//  Created by 叶帆 on 04/07/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSProductTabData.h"


SPEC_BEGIN(FSProductTabDataSpec)

describe(@"FSProductTabData", ^{
    context(@"when is create", ^{
        
        __block FSProductTabData *data = nil;
        NSDictionary *testDic = @{@"classifyName" : @"name",
                                  @"classifyId" : @"id",
                                  @"url" : @"url",
                                  @"type" : @"type"
                                  };
        
        beforeAll(^{
            data = [[FSProductTabData alloc] initWithDictionary:testDic];
        });
        
        it(@"should exist", ^{
            [[data shouldNot] beNil];
        });
        
        it(@"should has dictionaryDescription", ^{
            [[[data dictionaryDescription] shouldNot] beNil];
        });
        
        it(@"should be able to archived and unarchive", ^{
            NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:data];
            [[archivedData shouldNot] beNil];
            FSProductTabData *unarchiveData = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
            [[unarchiveData shouldNot] beNil];
        });
        
        it(@"should be able to create with class method", ^{
            [[[FSProductTabData modelObjectWithDictionary:testDic] shouldNot] beNil];
        });
        
        it(@"should can be save & load", ^{
            [data save];
            [[[FSProductTabData loadTabData] shouldNot] beNil];
        });
        
    });

});

SPEC_END
