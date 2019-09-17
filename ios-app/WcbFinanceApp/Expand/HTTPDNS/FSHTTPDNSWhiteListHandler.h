//
//  FSHTTPDNSWhiteListHandler.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/12/5.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FSHTTPDNSWhiteListConfig;
@interface FSHTTPDNSWhiteListHandler : NSObject

@property (nonatomic, strong) FSHTTPDNSWhiteListConfig *whiteListConfig;

- (void)fetchConfig:(void(^)(FSHTTPDNSWhiteListConfig *config))successBlcok failBlock:(void(^)(NSError *error))failBLock;

- (FSHTTPDNSWhiteListConfig *)whiteListConfigFromFile;

@end
