//
//  FSLoginViewModelSpec.m
//  Financeapp
//
//  Created by 叶帆 on 22/06/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSLoginViewModel.h"


SPEC_BEGIN(FSLoginViewModelSpec)

describe(@"FSLoginViewModel", ^{
    context(@"when is created", ^{
        __block FSLoginViewModel *viewModel = nil;
        __block NSError *error = nil;
        
        beforeEach(^{
            viewModel = [[FSLoginViewModel alloc] init];
        });
        
        it(@"should exist", ^{
            [[viewModel shouldNot] beNil];
        });
        
        it(@"request should can complete", ^{
            __block NSUInteger counter = 0;
            [viewModel.thirdLogin.executing subscribeNext:^(id x) {
                if (counter == 1) {
                    [[x should] beYes];
                } else {
                    [[x should] beNo];
                }
                counter++;
                
            }];
            
            [[viewModel.thirdLogin execute:nil] asynchronouslyWaitUntilCompleted:&error];
        });

    });
});

SPEC_END
