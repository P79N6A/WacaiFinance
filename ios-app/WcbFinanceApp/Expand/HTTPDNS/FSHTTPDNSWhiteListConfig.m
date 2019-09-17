//
//  FSHTTPDNSWhiteListConfig.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/12/4.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSHTTPDNSWhiteListConfig.h"
#import "FSHTTPDNSConfigModel.h"

@interface FSHTTPDNSWhiteListConfig()

@property (nonatomic, strong) NSDictionary *configDic;
@property (nonatomic, strong) FSHTTPDNSConfigModel *configNative;
@property (nonatomic, strong) FSHTTPDNSConfigModel *configH5;

@property (nonatomic, assign, readwrite) NSInteger gslbLostTime;
@property (nonatomic, assign, readwrite) NSInteger aliyunLostTime;

@end

@implementation FSHTTPDNSWhiteListConfig

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if(self)
    {
        _configDic = dic;
        NSDictionary *data = dic[@"data"];
        if([data CM_isValidDictionary])
        {
            _gslbLostTime = [data[@"gslbLostTime"] integerValue];
            _aliyunLostTime = [data[@"aliyunLostTime"] integerValue];
            
            NSDictionary *native = data[@"native"];
            if([native CM_isValidDictionary])
            {
                _configNative = [[FSHTTPDNSConfigModel alloc] initWithDic:native];
            }
            
            NSDictionary *h5 = data[@"H5"];
            if([native CM_isValidDictionary])
            {
                _configH5 = [[FSHTTPDNSConfigModel alloc] initWithDic:h5];
            }
            
        }
    }
    return self;
}

+ (NSString *)configKey
{
    return @"http_dns_whitelist";
}

- (BOOL)isRequestUseHttpDns:(NSURLRequest *)request
{
    BOOL enable = [self.configNative isRequestUseHttpDns:request];
    return enable;
}

- (BOOL)isH5UrlUseHttpDns:(NSString *)url
{
    BOOL enable = [self.configH5 isUrlUseHttpDns:url];
    return enable;
}

- (NSString *)description
{
    NSString *des = [NSString stringWithFormat:@"native:%@ \nh5:%@", self.configNative, self.configH5];
    return des;
}

+ (FSHTTPDNSWhiteListConfig *)defaultConfig
{
    FSHTTPDNSWhiteListConfig *config = [[FSHTTPDNSWhiteListConfig alloc] init];
    config.configNative = [FSHTTPDNSConfigModel defaultNativeConfig];
    return config;
}

@end
