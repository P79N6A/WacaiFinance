//
//  FSHTTPDNSWhiteListManager.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/12/5.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define TestHTTPDNS  1

@class FSHTTPDNSWhiteListConfig;
@interface FSHTTPDNSWhiteListManager : NSObject

@property (nonatomic, strong, readonly) FSHTTPDNSWhiteListConfig *whiteListConfig;

+ (instancetype)sharedManager;

- (void)start;

@end
