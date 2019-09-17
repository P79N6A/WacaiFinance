//
//  FSEmptyCellViewModel.m
//  FinanceApp
//
//  Created by Alex on 8/5/16.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSEmptyCellViewModel.h"

@implementation FSEmptyCellViewModel

- (instancetype)initWithHeight:(CGFloat)height
{
    self = [super init];
    if (self) {
        _cellHeight = height;
    }
    
    return self;
}

@end
