//
//  FSSetPasswordViewModelSpec.m
//  Financeapp
//
//  Created by 叶帆 on 02/07/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSSetPasswordViewModel.h"


SPEC_BEGIN(FSSetPasswordViewModelSpec)

describe(@"FSSetPasswordViewModel", ^{
    context(@"when is created", ^{
        __block FSSetPasswordViewModel *viewModel = nil;
        __block NSError *error = nil;
        beforeEach(^{
            viewModel = [[FSSetPasswordViewModel alloc] init];
        });
        
        it(@"should exist", ^{
            [[viewModel shouldNot] beNil];
        });
        
        it(@"float window view model should exist", ^{
            [[viewModel.floatWindowViewModel shouldNot] beNil];
        });
        
        it(@"getSMSCodeCmd should can complete", ^{
            __block NSUInteger counter = 0;
            [viewModel.getSMSCodeCmd.executing subscribeNext:^(id x) {
                if (counter == 1) {
                    [[x should] beYes];
                } else {
                    [[x should] beNo];
                }
                counter++;
                
            }];
            
            [[viewModel.getSMSCodeCmd execute:nil] asynchronouslyWaitUntilCompleted:&error];
        });
        
        it(@"getVoiceCodeCmd should can complete", ^{
            __block NSUInteger counter = 0;
            [viewModel.getVoiceCodeCmd.executing subscribeNext:^(id x) {
                if (counter == 1) {
                    [[x should] beYes];
                } else {
                    [[x should] beNo];
                }
                counter++;
                
            }];
            
            [[viewModel.getVoiceCodeCmd execute:nil] asynchronouslyWaitUntilCompleted:&error];
        });

        
        it(@"registerCmd should can complete", ^{
            __block NSUInteger counter = 0;
            [viewModel.registerCmd.executing subscribeNext:^(id x) {
                if (counter == 1) {
                    [[x should] beYes];
                } else {
                    [[x should] beNo];
                }
                counter++;
                
            }];
            
            [[viewModel.registerCmd execute:nil] asynchronouslyWaitUntilCompleted:&error];
        });


    });
});

SPEC_END
