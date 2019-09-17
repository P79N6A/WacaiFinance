//
//  FSEmptyCellViewModel.h
//  FinanceApp
//
//  Created by Alex on 8/5/16.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSEmptyCellViewModel : NSObject

@property (nonatomic, assign) CGFloat cellHeight;

- (instancetype)initWithHeight:(CGFloat)height;

@end
