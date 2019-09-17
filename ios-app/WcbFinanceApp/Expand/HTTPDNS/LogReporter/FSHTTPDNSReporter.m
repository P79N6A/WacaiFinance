//
//  FSHTTPDNSReporter.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/12/19.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSHTTPDNSReporter.h"
#import <FSThana/FSThana.h>

@implementation FSHTTPDNSReporter

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (void)setup:(BOOL)success
{
    [super setup:success];
}

- (void)queryStart:(NSString *)domain
{
    [super queryStart:domain];
    NSString *log = [NSString stringWithFormat:@"queryStart: %@",domain];
    NSLog(@"%@", log);
    
    NSDictionary *dic = @{@"lc_query_domain":domain
                          };
    [UserAction skylineEvent:@"finance_wcb_httpdns_start" attributes:dic];
    
}

- (void)querySuccess:(NSString *)domain type:(NSInteger)type ips:(NSArray*)ips
{
    NSString *recordsString = [self stringFromRecords:ips];
    NSString *log = [NSString stringWithFormat:@"querySuccess-> domain:%@ from:%@ %@",domain, [self getNameForType:type], recordsString];
    
    [super querySuccess:domain type:type ips:ips];
    
    NSDictionary *dic = @{@"lc_query_type":[self getNameForType:type],
                          @"lc_query_domain":domain
                          };
    [UserAction skylineEvent:@"finance_wcb_httpdns_query" attributes:dic];
    
     NSLog(@"%@", log);
}

- (void)queryError:(NSString *)domain error:(FSHttpDnsError *)error
{
    [super queryError:domain error:error];
    
    NSString *errorMsg = [error errorMsg];
    NSString *log = [NSString stringWithFormat:@"queryError-> domain:%@ error:%@",domain, [error errorMsg]];
    
    NSString *num = [NSString stringWithFormat:@"%@", @(error.code)];
    
    NSDictionary *dic = @{@"lc_error_type":@"query_error",
                          @"lc_error_code":num,
                          @"lc_error_msg":errorMsg
                          };
    [UserAction skylineEvent:@"finance_wcb_httpdns_error" attributes:dic];
    
     NSLog(@"%@", log);
}

- (void)competitionStart:(NSString *)domain
{
    [super competitionStart:domain];
    
    NSString *log = [NSString stringWithFormat:@"competitionStart-> %@",domain];
    NSLog(@"%@", log);
}

- (void)competitionSuccess:(NSString *)domain from:(NSInteger)from records:(NSArray *)records
{
    [super competitionSuccess:domain from:from records:records];
    
    NSString *recordsString = [self stringFromRecords:records];
    NSString *log = [NSString stringWithFormat:@"competitionSuccess-> domain:%@ from:%@ %@",domain, [self getNameForType:from], recordsString];
    
    NSString *typeFrom = [self getNameForType:from];
    NSDictionary *dic = @{@"lc_competition_from":typeFrom,
                          @"lc_query_domain":domain,
                          };
    [UserAction skylineEvent:@"finance_wcb_httpdns_competition" attributes:dic];
    
     NSLog(@"%@", log);
}

- (void)competitionError:(NSString *)domain error:(FSHttpDnsError *)error
{
    [super competitionError:domain error:error];
    NSString *log = [NSString stringWithFormat:@"competitionError-> domain:%@ errorMsg:%@",domain, [error errorMsg]];
     NSLog(@"%@", log);
    
    
    NSString *errorMsg = [error errorMsg];
    NSString *num = [NSString stringWithFormat:@"%@", @(error.code)];
    
    NSDictionary *dic = @{@"lc_error_type":@"competition",
                          @"lc_error_code":num,
                          @"lc_error_msg":errorMsg
                          };
    [UserAction skylineEvent:@"finance_wcb_httpdns_error" attributes:dic];
}

- (void)onNetWorkChange:(FSNetworkInfo *)netowrkInfo
{
    [super onNetWorkChange:netowrkInfo];
    
    NSString *log = [NSString stringWithFormat:@"onNetWorkChange-> networkInfo:%@", [netowrkInfo description]];
    NSLog(@"%@", log);
}

- (void)onCacheClear:(FSNetworkInfo *)networkInfo
{
    [super onCacheClear:networkInfo];
    NSLog(@"onCacheClear -> clearAllCache");
    
    NSDictionary *dic = @{@"lc_cache_type":@"clear"
                          };
    [UserAction skylineEvent:@"finance_wcb_httpdns_cache" attributes:dic];
}

- (void)resolverSuccess:(NSString *)domain  type:(NSString *)type consumingTime:(int64_t)consumingTime
{
    [super resolverSuccess:domain type:type consumingTime:consumingTime];
    NSString *log = [NSString stringWithFormat:@"resolverSuccess:%@ type:%@ 请求耗时:%@", domain,type, @(consumingTime)];
    NSLog(@"%@", log);
    
    NSString *num = [NSString stringWithFormat:@"%@", @(consumingTime)];
    NSDictionary *dic = @{@"lc_httpdns_request_from":type,
                          @"lc_httpdns_request_cost":num
                          };
    [UserAction skylineEvent:@"finance_httpdns_dns_request" attributes:dic];
}

#pragma mark-curl
- (void)fsCurlRequestStart:(NSURLRequest *)request ip:(NSString *)ip;
{
    NSString *url = request.URL.absoluteString;
    NSString *thanaLog = [NSString stringWithFormat:@"fsCurlRequest:Start\n url:%@ ip:%@",url,ip];
    [FSThana log:thanaLog];
}

- (void)fsCurlRequestDone:(NSURLRequest *)request timeInfo:(NSString *)timeInfo response:(id<FSRequestResponseProtocol>)reponse
{
    //thana
    NSString *url = request.URL.absoluteString;
    
    NSInteger statucCode = [reponse statusCode];
    NSString *httpVersion = [reponse responseHttpVersion];
    NSString *resInfo = [NSString stringWithFormat:@"statusCode:%@\n httpversion:%@\n", @(statucCode), httpVersion];
    
    NSString *thanaLog = [NSString stringWithFormat:@"fsCurlRequest:Done\n url:%@ \n Timeinfo:\n%@  ResponseInfo:\n %@",url, timeInfo, resInfo];
    [FSThana log:thanaLog];
}

- (void)fsCurlRequestFail:(NSURLRequest *)request timeInfo:(NSString *)timeInfo error:(NSError *)error
{
    //thana
    NSString *errorDes = [error description];
    
    NSString *url = request.URL.absoluteString;
    NSString *thanaLog = [NSString stringWithFormat:@"fsCurlRequest:Fail\n  url:%@ \nError:\n%@\n Timeinfo:\n%@",url, errorDes, timeInfo];
    [FSThana log:thanaLog];
}

- (void)fsCurlRequestCancel:(NSURLRequest *)request
{
    //thana
    NSString *url = request.URL.absoluteString;
    NSString *thanaLog = [NSString stringWithFormat:@"fsCurlRequest:Cancel \n url:%@",url];
    [FSThana log:thanaLog];
}

@end
