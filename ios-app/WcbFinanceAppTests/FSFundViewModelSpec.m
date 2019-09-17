//
//  FSFundViewModelSpec.m
//  Financeapp
//
//  Created by 叶帆 on 02/07/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSFundViewModel.h"


SPEC_BEGIN(FSFundViewModelSpec)

describe(@"FSFundViewModel", ^{
    __block FSFundViewModel *viewModel = nil;
    __block NSError *error = nil;
    
    beforeEach(^{
        viewModel = [[FSFundViewModel alloc] init];
    });
    
    context(@"when is created", ^{
        it(@"should exist", ^{
            [[viewModel shouldNot] beNil];
        });
        
        it(@"fundCommand should exist", ^{
            [[viewModel.fundCommand shouldNot] beNil];
        });
        
        it(@"fundCommand should can complete", ^{
            __block NSUInteger counter = 0;
            [viewModel.fundCommand.executing subscribeNext:^(id x) {
                if (counter == 1) {
                    [[x should] beYes];
                } else {
                    [[x should] beNo];
                }
                counter++;
                
            }];
            
            [[viewModel.fundCommand execute:nil] asynchronouslyWaitUntilCompleted:&error];
        });
        
    });
});

SPEC_END
