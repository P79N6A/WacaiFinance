//
//  FSTabBarMessage.h
//  WcbFinanceApp
//
//  Created by 叶帆 on 2018/8/30.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSTabBarMessage : NSObject

@property (copy, nonatomic) NSString *msg;
@property (copy, nonatomic) NSString *url;
@property (strong, nonatomic) NSArray *couponCodeList;

@end
