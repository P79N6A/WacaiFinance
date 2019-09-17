//
//  FSNewExclusiveViewModelSpec.m
//  Financeapp
//
//  Created by 叶帆 on 02/07/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSNewExclusiveViewModel.h"


SPEC_BEGIN(FSNewExclusiveViewModelSpec)

describe(@"FSNewExclusiveViewModel", ^{
    __block FSNewExclusiveViewModel *viewModel = nil;
    __block NSError *error = nil;
    
    beforeEach(^{
        viewModel = [[FSNewExclusiveViewModel alloc] init];
    });
    
    context(@"when is created", ^{
        it(@"should exist", ^{
            [[viewModel shouldNot] beNil];
        });
        
        it(@"exclusiveCommand should exist", ^{
            [[viewModel.exclusiveCommand shouldNot] beNil];
        });
        
        it(@"getSMSCodeCmd should can complete", ^{
            __block NSUInteger counter = 0;
            [viewModel.exclusiveCommand.executing subscribeNext:^(id x) {
                if (counter == 1) {
                    [[x should] beYes];
                } else {
                    [[x should] beNo];
                }
                counter++;
                
            }];
            
            [[viewModel.exclusiveCommand execute:nil] asynchronouslyWaitUntilCompleted:&error];
        });
    });
    
});

SPEC_END
