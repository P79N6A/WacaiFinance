//
//  FSHTTPDNSWhiteListManager.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/12/5.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSHTTPDNSWhiteListManager.h"
#import "FSHTTPDNSWhiteListConfig.h"
#import "FSHTTPDNSWhiteListRequest.h"
#import "FSHTTPDNSWhiteListHandler.h"
#import <FSHTTPDNS/FSDNSManager.h>

@interface FSHTTPDNSWhiteListManager()

@property (nonatomic, strong) FSHTTPDNSWhiteListHandler *handler;
@property (nonatomic, strong, readwrite) FSHTTPDNSWhiteListConfig *whiteListConfig;

@end

@implementation FSHTTPDNSWhiteListManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static FSHTTPDNSWhiteListManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _handler = [[FSHTTPDNSWhiteListHandler alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self stop];
}

- (void)start
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestWhiteList:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestWhiteList:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    //默认配置
    FSHTTPDNSWhiteListConfig *config = [FSHTTPDNSWhiteListConfig defaultConfig];
    if(config)
    {
        self.whiteListConfig = config;
    }
    
    //缓存配置
    config = [self.handler whiteListConfigFromFile];
    if(config)
    {
        self.whiteListConfig = config;
    }
    
    if(self.whiteListConfig)
    {
        [self updateConfig:self.whiteListConfig];
    }
    NSLog(@"whiteListConfig is %@", self.whiteListConfig);
    
    //读取本地文件缓存设置进去
    [self requestWhiteList:nil];
}

- (void)stop
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)requestWhiteList:(NSNotification *)notification
{
    __weak __typeof(self)weakSelf = self;
    [self.handler fetchConfig:^(FSHTTPDNSWhiteListConfig *config) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.whiteListConfig = config;
        [strongSelf updateConfig:strongSelf.whiteListConfig];
        
    } failBlock:^(NSError *error) {
        
        NSLog(@"error is %@", error);
        
    }];
}

- (void)onResignActive:(NSNotification *)noti
{
    [self requestWhiteList:noti];
}

- (void)updateConfig:(FSHTTPDNSWhiteListConfig *)config
{
    [[FSDNSManager sharedInstance] setWhiteList:config];
    if(config.aliyunLostTime > 0 && config.gslbLostTime > 0)
    {
        [[FSDNSManager sharedInstance] setCompetitionTime:config.gslbLostTime aliLostTime:config.aliyunLostTime];
    }
}


@end
