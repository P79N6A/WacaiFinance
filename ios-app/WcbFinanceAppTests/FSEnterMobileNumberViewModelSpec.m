//
//  FSEnterMobileNumberViewModelSpec.m
//  FinanceApp
//
//  Created by Alex on 07/02/2017.
//  Copyright 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSEnterMobileNumberViewModel.h"


SPEC_BEGIN(FSEnterMobileNumberViewModelSpec)

describe(@"FSEnterMobileNumberViewModel", ^{
    context(@"when ViewModel is created", ^{
        __block FSEnterMobileNumberViewModel *viewModel = nil;
        beforeEach(^{
            viewModel = [FSEnterMobileNumberViewModel new];
        });
        
        afterEach(^{
            viewModel = nil;
        });
        
        it(@"should exist", ^{
            [[viewModel shouldNot] beNil];
        });
        
        it(@"mobileHasRegisteCmd should exist", ^{
            [[viewModel shouldNot] beNil];
        });
    });
    
    context(@"when mobileHasRegisteCmd is excuted", ^{
        __block FSEnterMobileNumberViewModel *viewModel = nil;
        __block NSError *error = nil;

        beforeEach(^{
            viewModel = [FSEnterMobileNumberViewModel new];
        });
        
        afterEach(^{
            viewModel = nil;
        });
        
        
        it(@"should can complete", ^{
            __block NSUInteger counter = 0;
            
            [viewModel.mobileHasRegisteCmd.executing subscribeNext:^(id x) {
                if (counter == 1) {
                    [[x should] beYes];
                } else {
                    [[x should] beNo];
                }
                counter++;
            }];
            
            
            [[viewModel.mobileHasRegisteCmd execute:nil] asynchronouslyWaitUntilCompleted:&error];
            
        });
        
        it(@"should can return Value", ^{
            viewModel.mobileString = @"18511111111";
            BOOL hasRegiste = YES;
            [viewModel stub:@selector(mobileHasRegisteSignal) andReturn:[RACSignal return:@(hasRegiste)]];
            
            [viewModel.mobileHasRegisteCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
                [[x should] equal:@(hasRegiste)];
            }];
            
            [[viewModel.mobileHasRegisteCmd execute:nil] asynchronouslyWaitUntilCompleted:&error];
            
        });
    });
    
    context(@"when mobileString is invalid", ^{
        __block FSEnterMobileNumberViewModel *viewModel = nil;
        __block NSError *error = nil;
        
        beforeEach(^{
            viewModel = [FSEnterMobileNumberViewModel new];
        });
        
        afterEach(^{
            viewModel = nil;
        });
        
        
        it(@"should return error", ^{
            viewModel.mobileString = @"185";
            [viewModel.mobileHasRegisteCmd.errors subscribeNext:^(id x) {
                [[x shouldNot] beNil];
            }];
            
            [[viewModel.mobileHasRegisteCmd execute:nil] asynchronouslyWaitUntilCompleted:&error];
            
        });
    });
    
});

SPEC_END
