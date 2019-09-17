//
//  FSBindeMobileNumberViewModelSpec.m
//  Financeapp
//
//  Created by 叶帆 on 02/07/2017.
//  Copyright 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FSBindeMobileNumberViewModel.h"


SPEC_BEGIN(FSBindeMobileNumberViewModelSpec)

describe(@"FSBindeMobileNumberViewModel", ^{
    context(@"when is created", ^{
        __block FSBindeMobileNumberViewModel *viewModel = nil;
        __block NSError *error = nil;
        beforeEach(^{
            viewModel = [[FSBindeMobileNumberViewModel alloc] init];
        });
        
        it(@"should exist", ^{
            [[viewModel shouldNot] beNil];
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
        
        
        it(@"bindMobileCmd should can complete", ^{
            __block NSUInteger counter = 0;
            [viewModel.bindMobileCmd.executing subscribeNext:^(id x) {
                if (counter == 1) {
                    [[x should] beYes];
                } else {
                    [[x should] beNo];
                }
                counter++;
                
            }];
            
            [[viewModel.bindMobileCmd execute:nil] asynchronouslyWaitUntilCompleted:&error];
        });
        
        
    });

});

SPEC_END
