//
//  FSHTTPDNSWhiteListConfig.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/12/4.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FSHTTPDNS/FSHTTPDNSWhiteListProtocol.h>

@interface FSHTTPDNSWhiteListConfig : NSObject<FSHTTPDNSWhiteListProtocol>

@property (nonatomic, assign, readonly) NSInteger gslbLostTime;
@property (nonatomic, assign, readonly) NSInteger aliyunLostTime;

- (instancetype)initWithDic:(NSDictionary *)dic;

+ (NSString *)configKey;

//协议方法
- (BOOL)isRequestUseHttpDns:(NSURLRequest *)request;

- (BOOL)isH5UrlUseHttpDns:(NSString *)url;

+ (FSHTTPDNSWhiteListConfig *)defaultConfig;

@end
