//
//  FSDepositViewModelSpec.m
//  WcbFinanceApp
//
//  Created by xingyong on 01/02/2018.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSDepositViewModel.h"


SPEC_BEGIN(FSDepositViewModelSpec)

describe(@"FSDepositViewModel", ^{
    __block FSDepositViewModel *viewModel = nil;
    __block NSError *error = nil;
    
    beforeEach(^{
        viewModel = [[FSDepositViewModel alloc] init];
    });
    
    context(@"when is created", ^{
        it(@"should exist", ^{
            [[viewModel shouldNot] beNil];
        });
        
        it(@"depositCommand should exist", ^{
            [[viewModel.depositCommand shouldNot] beNil];
        });
        
        it(@"depositCommand should can complete", ^{
            
            __block NSUInteger counter = 0;
            
            [viewModel.depositCommand.executing subscribeNext:^(id x) {
                if (counter == 1) {
                    [[x should] beYes];
                } else {
                    [[x should] beNo];
                }
                counter++;
                
            }];
            
            [[viewModel.depositCommand execute:nil] asynchronouslyWaitUntilCompleted:&error];
        });
        
    });
});

SPEC_END
