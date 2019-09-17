//
//  FSiRateDelegate.h
//  FinanceApp
//
//  Created by Alex on 1/14/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomiRate.h"

@interface FSiRateDelegate : NSObject<iRateDelegate>

+ (FSiRateDelegate*)shareInstance;

- (void)promptForRating;
@end
