//
//  FSSplashViewModelSpec.m
//  Financeapp
//
//  Created by 叶帆 on 02/07/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSSplashViewModel.h"


SPEC_BEGIN(FSSplashViewModelSpec)

describe(@"FSSplashViewModel", ^{
    __block FSSplashViewModel *viewModel = nil;
    __block NSError *error = nil;
    beforeEach(^{
        viewModel = [[FSSplashViewModel alloc] init];
    });
    
    context(@"when is created", ^{
        [[viewModel shouldNot] beNil];
    });
    
    it(@"should exist", ^{
        [[viewModel shouldNot] beNil];
    });
    
    it(@"spalshCommand should exist", ^{
        [[viewModel.splashCommand shouldNot] beNil];
    });
    
    it(@"spalshCommand should can complete", ^{
        __block NSUInteger counter = 0;
        [viewModel.splashCommand.executing subscribeNext:^(id x) {
            if (counter == 1) {
                [[x should] beYes];
            } else {
                [[x should] beNo];
            }
            counter++;
            
        }];
        
        [[viewModel.splashCommand execute:nil] asynchronouslyWaitUntilCompleted:&error];
    });

});

SPEC_END
