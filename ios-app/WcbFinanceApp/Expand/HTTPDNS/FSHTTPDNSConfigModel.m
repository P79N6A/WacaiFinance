//
//  FSHTTPDNSConfigNative.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/12/19.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSHTTPDNSConfigModel.h"

@implementation FSHTTPDNSConfigModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if(self)
    {
        _enable = [dic[@"enable"] boolValue];
        _ignorePaths = [dic[@"ignorePaths"] boolValue];
        NSArray *domains = dic[@"domains"];
        NSArray *paths = dic[@"paths"];
        
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        for(NSInteger i = 0; i < domains.count; i ++)
        {
            [tmpDic setValue:@"1" forKey:domains[i]];
        }
        _domainDic = [tmpDic copy];
        
        [tmpDic removeAllObjects];
        for(NSInteger i = 0; i < paths.count; i ++)
        {
            [tmpDic setValue:@"1" forKey:paths[i]];
        }
        _pathDic = [tmpDic copy];
    }
    return self;
}


- (BOOL)isHTTPDNSEnable
{
    return _enable;
}

- (BOOL)isUrlUseHttpDns:(NSString *)url
{
    NSURL *URL = [[NSURL alloc] initWithString:url];
    BOOL enable = [self isURLUseHttpDns:URL];
    
    return enable;
}

- (BOOL)isRequestUseHttpDns:(NSURLRequest *)request
{
    NSURL *url = request.URL;
    
    BOOL enable = [self isURLUseHttpDns:url];
    
    return enable;
}

- (BOOL)isURLUseHttpDns:(NSURL *)URL
{
    if(![self isHTTPDNSEnable])
    {
        return NO;
    }
    
    if(!URL)
    {
        return NO;
    }
    
    if(!self.domainDic || self.domainDic.allKeys.count == 0)
    {
        return NO;
    }
    
    NSString *host = URL.host;
    NSString *path = URL.path;
    
    if(!host)
    {
        return NO;
    }
    
    if(self.ignorePaths)
    {
        if(self.domainDic[host])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        if(!self.pathDic || self.pathDic.allKeys.count == 0)
        {
            return NO;
        }
        
        if(self.domainDic[host] && self.pathDic[path])
        {
            return YES;
        }
    }
    return NO;
}

- (NSString *)description
{
    NSString *des = [NSString stringWithFormat:@"enable:%@  ignorePaths:%@  domainDic:%@  pathDic:%@ ",@(_enable), @(_ignorePaths),_domainDic, _pathDic];
    
    return des;
}

+ (FSHTTPDNSConfigModel *)defaultNativeConfig
{
    FSHTTPDNSConfigModel *config = [[FSHTTPDNSConfigModel alloc] init];
    config.enable = YES;
    config.ignorePaths = NO;
    config.domainDic = @{@"8.wacai.com":@"1", @"8.wacaiyun.com":@"1"};
    config.pathDic = @{@"/finance/app/feedback.do":@"1"};
    
    return config;
}

@end
