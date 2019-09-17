//
//  EnvironmentInfoSpec.m
//  Financeapp
//
//  Created by kuyeluofan on 03/07/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "EnvironmentInfo.h"


SPEC_BEGIN(EnvironmentInfoSpec)

describe(@"EnvironmentInfo", ^{
    
    context(@"when sharedInstance is first loaded", ^{
        EnvironmentInfo *environmentInfo = [EnvironmentInfo sharedInstance];
        
        afterAll(^{
            [environmentInfo switchEnvironmentTo:FSEnvironmentTypeTest1];
        });

        it(@"should exist", ^{
            [[environmentInfo shouldNot] beNil];
        });
        
        it(@"should can return current environment", ^{
            [[theValue([environmentInfo currentEnvironment]) shouldNot] beNil];
        });
        
        it(@"should can switch to FSEnvironmentTypeDevelop", ^{
            [environmentInfo switchEnvironmentTo:FSEnvironmentTypeDevelop];
            [[theValue([environmentInfo currentEnvironment]) should] equal:theValue(FSEnvironmentTypeDevelop)];
        });
        
        it(@"should can switch to FSEnvironmentTypeTest1", ^{
            [environmentInfo switchEnvironmentTo:FSEnvironmentTypeTest1];
            [[theValue([environmentInfo currentEnvironment]) should] equal:theValue(FSEnvironmentTypeTest1)];
        });

        it(@"should can switch to FSEnvironmentTypeTest2", ^{
            [environmentInfo switchEnvironmentTo:FSEnvironmentTypeTest2];
            [[theValue([environmentInfo currentEnvironment]) should] equal:theValue(FSEnvironmentTypeTest2)];
        });
 
        it(@"should can switch to FSEnvironmentTypeOnline", ^{
            [environmentInfo switchEnvironmentTo:FSEnvironmentTypeOnline];
            [[theValue([environmentInfo currentEnvironment]) should] equal:theValue(FSEnvironmentTypeOnline)];
        });

        it(@"should can return URL of FSURLTypeDomain", ^{
            [[[environmentInfo URLStringOfCurrentEnvironmentURLType:FSURLTypeMainDomain] shouldNot] beNil];
        });
        
        it(@"should can return URL of FSURLTypeRPC", ^{
            [[[environmentInfo URLStringOfCurrentEnvironmentURLType:FSURLTypeFinance] shouldNot] beNil];
        });

        it(@"should can return URL of FSURLTypeServiceWindow", ^{
            [[[environmentInfo URLStringOfCurrentEnvironmentURLType:FSURLTypeServiceWindow] shouldNot] beNil];
        });

        it(@"should can return URL of FSURLTypeMsgCenter", ^{
            [[[environmentInfo URLStringOfCurrentEnvironmentURLType:FSURLTypeMsgCenter] shouldNot] beNil];
        });

        it(@"should can return URL of FSURLTypeForgetPwd", ^{
            [[[environmentInfo URLStringOfCurrentEnvironmentURLType:FSURLTypeForgetPwd] shouldNot] beNil];
        });

        it(@"should can return URL of FSURLTypeCookieDomain", ^{
            [[[environmentInfo URLStringOfCurrentEnvironmentURLType:FSURLTypeCookieDomain] shouldNot] beNil];
        });

        it(@"should can return URL of FSURLTypeStock", ^{
            [[[environmentInfo URLStringOfCurrentEnvironmentURLType:FSURLTypeStock] shouldNot] beNil];
        });
        
        it(@"should can return URL of FSURLTypeLotusseedKey", ^{
            [[[environmentInfo URLStringOfCurrentEnvironmentURLType:FSURLTypeLotusseedKey] shouldNot] beNil];
        });
        
        it(@"should can set URL", ^{
            [environmentInfo setURLString:@"http://URLString.test" ofEnvironment:[environmentInfo currentEnvironment] URLType:FSURLTypeMainDomain];
        });

        it(@"should can return default environment", ^{
            [[[environmentInfo performSelector:@selector(defaultEnvironmentInfoDictionary)] shouldNot] beNil];
        });
    });

});

SPEC_END
