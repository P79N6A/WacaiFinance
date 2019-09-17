//
//  FSAccountInfoViewModelSpec.m
//  Financeapp
//
//  Created by 叶帆 on 22/06/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSAccountInfoViewModel.h"


SPEC_BEGIN(FSAccountInfoViewModelSpec)

describe(@"FSAccountInfoViewModel", ^{
    __block FSAccountInfoViewModel *viewModel = nil;
    __block NSError *error = nil;
    beforeEach(^{
        viewModel = [[FSAccountInfoViewModel alloc] init];
    });
    context(@"when is created", ^{
        it(@"should exist", ^{
            [[viewModel shouldNot] beNil];
        });
        
        it(@"avatar should exist", ^{
            [[viewModel.userAvatar shouldNot] beNil];
        });
        
        it(@"nickname should exist", ^{
            [[viewModel.userNickname shouldNot] beNil];
        });
        
        it(@"account should exist", ^{
            [[viewModel.userAccount shouldNot] beNil];
        });
        
        it(@"requestCmd should exist", ^{
            [[viewModel.requestCmd shouldNot] beNil];
        });
        
        it(@"request should can complete", ^{
            __block NSUInteger counter = 0;
            [viewModel.requestCmd.executing subscribeNext:^(id x) {
                if (counter == 1) {
                    [[x should] beYes];
                } else {
                    [[x should] beNo];
                }
                counter++;
                
            }];
            
            [[viewModel.requestCmd execute:nil] asynchronouslyWaitUntilCompleted:&error];
        });

    });
    
});

SPEC_END
