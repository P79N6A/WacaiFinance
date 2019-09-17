//
//  FSDepositViewModel.h
//  WcbFinanceApp
//
//  Created by xingyong on 26/01/2018.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSDepositData.h"

@interface FSDepositViewModel : NSObject

@property(nonatomic, strong,readonly) RACCommand *depositCommand;
@property(nonatomic, strong) FSDepositData *depositData;

@end
