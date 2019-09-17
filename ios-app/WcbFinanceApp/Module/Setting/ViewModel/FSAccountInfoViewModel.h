//
//  FSAccountInfoViewModel.h
//  FinanceApp
//
//  Created by 叶帆 on 16/03/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSAccountInfoViewModel : NSObject

@property (strong, nonatomic) UIImage *userAvatar;
@property (copy, nonatomic) NSString *userNickname;
@property (copy, nonatomic) NSString *userAccount;

@property (strong, nonatomic) RACCommand *requestCmd;

@end
