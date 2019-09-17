//
//  FSAccountSettingsViewModelSpec.m
//  FinanceApp
//
//  Created by 叶帆 on 22/05/2017.
//  Copyright 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSAccountSettingsViewModel.h"


SPEC_BEGIN(FSAccountSettingsViewModelSpec)

describe(@"FSAccountSettingsViewModel", ^{
    
    context(@"when viewModel is created", ^{
        __block FSAccountSettingsViewModel *viewModel = nil;
        
        beforeEach(^{
            viewModel = [[FSAccountSettingsViewModel alloc] init];
        });
        
        afterEach(^{
            viewModel = nil;
        });
        
        it(@"should exist", ^{
            [[viewModel shouldNot] beNil];
        });
        
        it(@"userAvatar should exist", ^{
            [[viewModel.userAvatar shouldNot] beNil];
        });
        
        it(@"userNickname should exist", ^{
            [[viewModel.userNickname shouldNot] beNil];
        });
        
        it(@"cellViewModels should exist", ^{
            [[viewModel.cellViewModels shouldNot] beNil];
        });
        
        it(@"requestCmd should exist", ^{
            [[viewModel.requestCmd shouldNot] beNil];
        });
    });
    
    context(@"when requestCmd is excuted", ^{
        __block FSAccountSettingsViewModel *viewModel = nil;
        __block NSError *error = nil;
        beforeEach(^{
            viewModel = [[FSAccountSettingsViewModel alloc] init];
        });
        
        afterEach(^{
            viewModel = nil;
        });
        
        it(@"should can complete", ^{
            __block NSUInteger counter = 0;
            [viewModel.requestCmd.executing subscribeNext:^(id x) {
                if(counter == 1) {
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
