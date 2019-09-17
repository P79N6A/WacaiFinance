//
//  FSCanShowAccordingAppStoreInfoHandler.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/12.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSCanShowAccordingAppStoreInfoHandler.h"

@interface FSCanShowAccordingAppStoreInfoHandler()

@property (nonatomic, assign) BOOL shouldShowInfo;

@end

@implementation FSCanShowAccordingAppStoreInfoHandler


- (void)requestAppStoreInfo:(void(^)(BOOL canshow))block
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    
    NSURL *URL = [NSURL URLWithString:@"https://itunes.apple.com/lookup?id=891192948"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *results = [responseObject fs_objectMaybeNilForKey:@"results" ofClass:[NSArray class]];
                id firstResultObject = [results fs_firstObject];
                if ([firstResultObject isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *resultDic = (NSDictionary *)firstResultObject;
                    NSString *AppStoreVersion = [resultDic fs_objectMaybeNilForKey:@"version" ofClass:[NSString class]] ?: @"99.99.99";
                    
                    self.shouldShowInfo = ![self isLocalVersionLargerThanAppStoreVersion:AppStoreVersion];
                    
                    if(block)
                    {
                        block(self.shouldShowInfo);
                    }
                }
            }
        }
    }];
    [dataTask resume];
}

- (BOOL)isLocalVersionLargerThanAppStoreVersion:(NSString *)AppStoreVersion {
    NSString *localVersion = Release_App_Ver ?: @"0.0.0";
    if ([localVersion compare:AppStoreVersion options:NSNumericSearch] == NSOrderedDescending) {
        // localVersion > AppStoreVersion
        return YES;
    } else {
        // localVersion <= AppStoreVersion
        return NO;
    }
}

@end
