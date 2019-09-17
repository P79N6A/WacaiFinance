//
//  TheReporter.m
//  HTTPDNSExample
//
//  Created by 破山 on 2018/11/20.
//  Copyright © 2018年 Wacai. All rights reserved.
//

#import "TheReporter.h"

@interface TheReporter()

@end

@implementation TheReporter

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _log = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)setup:(BOOL)success
{
    self.log = [[NSMutableString alloc] init];
}

- (void)queryStart:(NSString *)domain
{
    [super queryStart:domain];
    NSString *log = [NSString stringWithFormat:@"queryStart: %@",domain];
    
    [self.log appendFormat:@"%@ \n",log];
}

- (void)querySuccess:(NSString *)domain type:(NSInteger)type ips:(NSArray*)ips
{
    NSString *recordsString = [self stringFromRecords:ips];
    NSString *log = [NSString stringWithFormat:@"querySuccess-> domain:%@ from:%@ %@",domain, [self getNameForType:type], recordsString];
    
    [super querySuccess:domain type:type ips:ips];
    
    [self.log appendFormat:@"%@ \n", log];
}

- (void)queryError:(NSString *)domain error:(FSHttpDnsError *)error
{
    [super queryError:domain error:error];
    
    NSString *log = [NSString stringWithFormat:@"queryError-> domain:%@ error:%@",domain, [error errorMsg]];
    
    [self.log appendFormat:@"%@ \n", log];
}

- (void)competitionStart:(NSString *)domain
{
    [super competitionStart:domain];
    
    NSString *log = [NSString stringWithFormat:@"competitionStart-> %@",domain];
    [self.log appendFormat:@"%@ \n", log];
}

- (void)competitionSuccess:(NSString *)domain from:(NSInteger)from records:(NSArray *)records
{
    [super competitionSuccess:domain from:from records:records];
    
    NSString *recordsString = [self stringFromRecords:records];
    NSString *log = [NSString stringWithFormat:@"competitionSuccess-> domain:%@ from:%@ %@",domain, [self getNameForType:from], recordsString];
    [self.log appendFormat:@"%@ \n", log];
}

- (void)competitionError:(NSString *)domain error:(FSHttpDnsError *)error
{
    [super competitionError:domain error:error];
    NSString *log = [NSString stringWithFormat:@"competitionError-> domain:%@ errorMsg:%@",domain, [error errorMsg]];
    [self.log appendFormat:@"%@ \n", log];
}

- (void)onNetWorkChange:(FSNetworkInfo *)netowrkInfo
{
    [super onNetWorkChange:netowrkInfo];
    
    NSString *log = [NSString stringWithFormat:@"onNetWorkChange-> networkInfo:%@", [netowrkInfo description]];
    [self.log appendFormat:@"%@ \n", log];
}

- (void)onCacheClear:(FSNetworkInfo *)networkInfo
{
    [super onCacheClear:networkInfo];
}

- (void)resolverSuccess:(NSString *)domain  type:(NSString *)type consumingTime:(int64_t)consumingTime
{
    [super resolverSuccess:domain type:type consumingTime:consumingTime];
    NSString *log = [NSString stringWithFormat:@"resolverSuccess: type:%@ 请求耗时:%@", type, @(consumingTime)];
    [self.log appendFormat:@"%@ \n", log];
}

@end
