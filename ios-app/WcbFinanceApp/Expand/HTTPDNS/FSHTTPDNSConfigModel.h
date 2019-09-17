//
//  FSHTTPDNSConfigNative.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/12/19.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSHTTPDNSConfigModel : NSObject

@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) BOOL ignorePaths;
@property (nonatomic, strong) NSDictionary *domainDic;
@property (nonatomic, strong) NSDictionary *pathDic;

- (instancetype)initWithDic:(NSDictionary *)dic;

- (BOOL)isRequestUseHttpDns:(NSURLRequest *)request;

- (BOOL)isUrlUseHttpDns:(NSString *)url;



+ (FSHTTPDNSConfigModel *)defaultNativeConfig;

@end
