//
//  FSHTTPDNSWhiteListHandler.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/12/5.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSHTTPDNSWhiteListHandler.h"
#import "FSHTTPDNSWhiteListConfig.h"
#import "FSHTTPDNSWhiteListRequest.h"
#import "FSHiveConfigEvent.h"
#import <WCAnalytics/WCALogging.h>

static NSString *const kWhiteListName = @"FSHttpDns_whiteList";

@interface FSHTTPDNSWhiteListHandler()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end


@implementation FSHTTPDNSWhiteListHandler

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {

        
      

    

    }
    return self;
}

- (void)fillHeaders:(AFHTTPRequestSerializer *)requestSerializer request:(FSHTTPDNSWhiteListRequest *)request
{
    NSDictionary<NSString *, NSString *> *defaultHTTPRequestHeaders = [CMAppProfile sharedInstance].httpRequestHeaders;
    
    [defaultHTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    [requestSerializer setValue:[WCALogging generateTraceID] forHTTPHeaderField:@"X-Trace-Id"];
    
    NSDictionary<NSString *, NSString *> *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
}


- (void)fetchConfig:(void(^)(FSHTTPDNSWhiteListConfig *config))successBlcok failBlock:(void(^)(NSError *error))failBLock
{
    NSString *configKey = [FSHTTPDNSWhiteListConfig configKey];
    FSHTTPDNSWhiteListRequest *request = [[FSHTTPDNSWhiteListRequest alloc] initWithKey:configKey];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes
    = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    
    [self fillHeaders:manager.requestSerializer request:request];
    
    NSString *url = [request requestUrl];
    NSDictionary *requestParam = [request requestParam];
    
    [manager POST:url parameters:requestParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSUInteger code = [responseObject CM_intForKey:@"code"];
        if (code != 0) {
            
            [FSHiveConfigEvent hiveConfigEvent:configKey errorType:FSHiveConfigErrorTypeData];
            
            if(failBLock)
            {
                failBLock(nil);
            }
            return;
        }
        NSDictionary *dataDic = [responseObject CM_dictionaryForKey:@"data"];
        NSArray *configs = [dataDic CM_arrayForKey:@"config"];
        __block NSDictionary *configDataDic;
        __block NSString *dataStringInData;
        [configs enumerateObjectsUsingBlock:^(id  _Nonnull configData, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![configData isKindOfClass:[NSDictionary class]]) {
                
                [FSHiveConfigEvent hiveConfigEvent:configKey errorType:FSHiveConfigErrorTypeData];
                if(failBLock)
                {
                    failBLock(nil);
                }
                return;
            }
            NSString *configKeyInData = [configData CM_stringForKey:@"key"];
            if ([configKey isEqualToString:configKeyInData]) {
                dataStringInData = [configData CM_stringForKey:@"data"];
                configDataDic = [dataStringInData CM_JsonStringToDictionary];
                *stop = YES;
            }
        }];
        
        if([configDataDic CM_isValidDictionary])
        {
            self.whiteListConfig = [[FSHTTPDNSWhiteListConfig alloc] initWithDic:configDataDic];
            if(successBlcok)
            {
                successBlcok(self.whiteListConfig);
            }
            
            [self saveWhiteListDic:configDataDic];
            
        }else{
            //report error
            [FSHiveConfigEvent hiveConfigEvent:configKey errorType:FSHiveConfigErrorTypeData];
            
            if(failBLock)
            {
                failBLock(nil);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [FSHiveConfigEvent hiveConfigEvent:configKey errorType:FSHiveConfigErrorTypeNet];
        
        if(failBLock)
        {
            failBLock(error);
        }
    }];
    
}



- (FSHTTPDNSWhiteListConfig *)whiteListConfigFromFile
{
    NSDictionary *dic = [self whiteListDicFromFile];
    if([dic CM_isValidDictionary])
    {
        FSHTTPDNSWhiteListConfig *config = [[FSHTTPDNSWhiteListConfig alloc] initWithDic:dic];
        return config;
        
    }else{
        return nil;
    }
}


- (NSString *)documentPath:(NSString *)fineName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,fineName];
    return filePath;
}

- (BOOL)saveWhiteListDic:(NSDictionary *)dic
{
    NSString *filePath = [self documentPath:kWhiteListName];
    
    BOOL status = [NSKeyedArchiver archiveRootObject:dic toFile:filePath];
    return status;
}

- (NSDictionary *)whiteListDicFromFile
{
    NSString *filePath = [self documentPath:kWhiteListName];
    
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}


/*
- (void)fetchConfig:(void(^)(FSHTTPDNSWhiteListConfig *config))successBlcok failBlock:(void(^)(NSError *error))failBLock
{
    NSString *configKey = [FSHTTPDNSWhiteListConfig configKey];
    
    FSHTTPDNSWhiteListRequest *request = [[FSHTTPDNSWhiteListRequest alloc] initWithKey:configKey];
    
    [request startWithCompletionBlockWithSuccess:^(__kindof CMBaseRequest * _Nonnull request) {
        
        NSUInteger code = [request.responseJSONObject CM_intForKey:@"code"];
        if (code != 0) {
            
            [FSHiveConfigEvent hiveConfigEvent:configKey errorType:FSHiveConfigErrorTypeData];
            
            if(failBLock)
            {
                failBLock(nil);
            }
            return;
        }
        NSDictionary *dataDic = [request.responseJSONObject CM_dictionaryForKey:@"data"];
        NSArray *configs = [dataDic CM_arrayForKey:@"config"];
        __block NSDictionary *configDataDic;
        __block NSString *dataStringInData;
        [configs enumerateObjectsUsingBlock:^(id  _Nonnull configData, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![configData isKindOfClass:[NSDictionary class]]) {
                
                [FSHiveConfigEvent hiveConfigEvent:configKey errorType:FSHiveConfigErrorTypeData];
                if(failBLock)
                {
                    failBLock(nil);
                }
                return;
            }
            NSString *configKeyInData = [configData CM_stringForKey:@"key"];
            if ([configKey isEqualToString:configKeyInData]) {
                dataStringInData = [configData CM_stringForKey:@"data"];
                configDataDic = [dataStringInData CM_JsonStringToDictionary];
                *stop = YES;
            }
        }];
        
        if([configDataDic CM_isValidDictionary])
        {
            self.whiteListConfig = [[FSHTTPDNSWhiteListConfig alloc] initWithDic:configDataDic];
            if(successBlcok)
            {
                successBlcok(self.whiteListConfig);
            }
            
        }else{
            //report error
            [FSHiveConfigEvent hiveConfigEvent:configKey errorType:FSHiveConfigErrorTypeData];
            
            if(failBLock)
            {
                failBLock(nil);
            }
        }
    } failure:^(__kindof CMBaseRequest * _Nonnull request) {
        //net workerror
        
        [FSHiveConfigEvent hiveConfigEvent:configKey errorType:FSHiveConfigErrorTypeNet];
        
        if(failBLock)
        {
            failBLock(request.error);
        }
    }];
}


- (FSHTTPDNSWhiteListConfig *)whiteListConfigFromCache
{
    NSString *configKey = [FSHTTPDNSWhiteListConfig configKey];
    FSHTTPDNSWhiteListRequest *request = [[FSHTTPDNSWhiteListRequest alloc] initWithKey:configKey];
    
    NSError *error;
    if([request loadCacheWithError:&error])
    {
        NSUInteger code = [request.responseJSONObject CM_intForKey:@"code"];
        if (code != 0) {
            
            return nil;
        }
        NSDictionary *dataDic = [request.responseJSONObject CM_dictionaryForKey:@"data"];
        NSArray *configs = [dataDic CM_arrayForKey:@"config"];
        __block NSDictionary *configDataDic;
        __block NSString *dataStringInData;
        [configs enumerateObjectsUsingBlock:^(id  _Nonnull configData, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![configData isKindOfClass:[NSDictionary class]]) {
                
                return ;
            }
            NSString *configKeyInData = [configData CM_stringForKey:@"key"];
            if ([configKey isEqualToString:configKeyInData]) {
                dataStringInData = [configData CM_stringForKey:@"data"];
                configDataDic = [dataStringInData CM_JsonStringToDictionary];
                *stop = YES;
            }
        }];
        
        if([configDataDic CM_isValidDictionary])
        {
            FSHTTPDNSWhiteListConfig *config = [[FSHTTPDNSWhiteListConfig alloc] initWithDic:configDataDic];
            
            return config;
            
        }else{
            return nil;
        }
    }
    else
    {
        return nil;
    }
    return nil;
}
*/


@end
