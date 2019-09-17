//
//  FSMenuViewModelSpec.m
//  Financeapp
//
//  Created by kuyeluofan on 03/07/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSMenuViewModel.h"


SPEC_BEGIN(FSMenuViewModelSpec)

describe(@"FSMenuViewModel", ^{
    __block FSMenuViewModel *viewModel = nil;
    __block NSError *error = nil;
    
    beforeEach(^{
        viewModel = [[FSMenuViewModel alloc] init];
    });
    
    context(@"when is created", ^{
        it(@"should exist", ^{
            [[viewModel shouldNot] beNil];
        });
        
        it(@"menuCommand should exist", ^{
            [[viewModel.menuCommand shouldNot] beNil];
        });
        
        it(@"menuCommand should can complete", ^{
            __block NSUInteger counter = 0;
            [viewModel.menuCommand.executing subscribeNext:^(id x) {
                if (counter == 1) {
                    [[x should] beYes];
                } else {
                    [[x should] beNo];
                }
                counter++;
                
            }];
            
            [[viewModel.menuCommand execute:nil] asynchronouslyWaitUntilCompleted:&error];
        });
        
    });
});

SPEC_END
