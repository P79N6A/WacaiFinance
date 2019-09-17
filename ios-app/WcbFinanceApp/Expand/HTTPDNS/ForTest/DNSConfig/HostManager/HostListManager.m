//
//  HostListManager.m
//  HTTPDNSExample
//
//  Created by 破山 on 2018/11/20.
//  Copyright © 2018年 Wacai. All rights reserved.
//

#import "HostListManager.h"

@interface HostListManager()

@property (atomic, strong) NSMutableArray *hostList;
@property (atomic, strong) NSMutableDictionary *hostDic;

@end

@implementation HostListManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static HostListManager *manager;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[HostListManager alloc] init];
        
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.hostList = [[NSMutableArray alloc] init];
        self.hostDic = [[NSMutableDictionary alloc] init];
        [self.hostList addObjectsFromArray:@[@"8.wacai.com",@"8.wacaiyun.com",@"user.wacaiyun.com", @"fund.wacai.com"]];
        for(NSInteger i = 0; i < self.hostList.count; i ++)
        {
            [self.hostDic setValue:@"1" forKey:self.hostList[i]];
        }
    }
    return self;
}

- (void)addHost:(NSString *)host
{
    if(host.length <= 0)
    {
        return;
    }
    [self.hostList addObject:host];
    [self.hostDic setValue:@"1" forKey:host];
}

- (NSArray *)currentHostList
{
    return [self.hostList copy];
}

- (BOOL)isRequestUseHttpDns:(NSURLRequest *)request
{
    NSURL *url = request.URL;
    if([self.hostDic valueForKey:url.host])
    {
        return YES;
    }
    return NO;
}


@end
