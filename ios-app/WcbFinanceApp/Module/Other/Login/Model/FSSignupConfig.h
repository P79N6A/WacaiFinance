//
//  FSSignupConfig.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/11/14.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSSignupConfig : NSObject

@property (nonatomic, strong) NSString *headSubtitle;
@property (nonatomic, assign) NSInteger needThirdLogin;
@property (nonatomic, assign) NSInteger thirdNeedBindPhone;

+ (NSString *)configKey;

@end
