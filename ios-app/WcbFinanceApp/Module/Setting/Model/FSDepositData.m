//
//  FSDepositData.m
//  WcbFinanceApp
//
//  Created by xingyong on 29/01/2018.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDepositData.h"
#import <YYModel/YYModel.h>

@implementation FSDepositData

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [self yy_modelEncodeWithCoder:aCoder];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        [self yy_modelInitWithCoder:aDecoder];
    }
    
    return self;
}

@end
