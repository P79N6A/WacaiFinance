//
//  FSFloatWindowViewModelSpec.m
//  FinanceApp
//
//  Created by Alex on 08/02/2017.
//  Copyright 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSFloatWindowViewModel.h"


SPEC_BEGIN(FSFloatWindowViewModelSpec)

describe(@"FSFloatWindowViewModel", ^{
    context(@"when ViewModel is created", ^{
        __block FSFloatWindowViewModel *viewModel = nil;
        beforeEach(^{
            viewModel = [FSFloatWindowViewModel new];
        });
        
        afterEach(^{
            viewModel = nil;
        });
        
        it(@"should exist", ^{
            [[viewModel shouldNot] beNil];
        });
        
        it(@"userRegister should be NO", ^{
            [[theValue(viewModel.userRegister) should] beNo];
        });
        
        it(@"userNeverLogin should be NO", ^{
            [[theValue(viewModel.userNeverLogin) should] beNo];
        });
        
        it(@"userLoggedIn should be NO", ^{
            [[theValue(viewModel.userLoggedIn) should] beNo];
        });
        
        it(@"showPopupWindowCmd should be exist", ^{
            [[theValue(viewModel.userLoggedIn) shouldNot] beNil];
        });
    });
    
    
    context(@"when user register", ^{
        __block FSFloatWindowViewModel *viewModel = nil;
        __block NSError *error = nil;
        beforeEach(^{
            viewModel = [FSFloatWindowViewModel new];
            viewModel.userRegister = YES;
        });
        
        afterEach(^{
            viewModel = nil;
        });
        
        it(@"should popup every times", ^{
            __block NSUInteger counter = 0;
            
            [viewModel.showPopupWindowCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
                counter++;
            }];
            
            RACSignal *showPopupWindowSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[@"", @"", @1, @123]];
                [subscriber sendNext:tuple];
                [subscriber sendCompleted];
                
                return [RACDisposable disposableWithBlock:^{}];
            }];
            
            [viewModel stub:@selector(showPopupWindowSignal) andReturn:showPopupWindowSignal];

            [[viewModel.showPopupWindowCmd execute:nil] asynchronouslyWaitUntilCompleted:&error];
            [[theValue(counter) should] equal:@(1)];
            
            [[viewModel.showPopupWindowCmd execute:nil] asynchronouslyWaitUntilCompleted:&error];
            [[theValue(counter) should] equal:@(2)];
        });
        
    });
});

SPEC_END
