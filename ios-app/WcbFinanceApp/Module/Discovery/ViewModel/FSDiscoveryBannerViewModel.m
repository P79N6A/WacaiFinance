//
//  FSDiscoveryBannerViewModel.m
//  Financeapp
//
//  Created by 叶帆 on 22/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryBannerViewModel.h"
#import "FSDiscoveryBannerRequest.h"

@interface FSDiscoveryBannerViewModel()

@end

@implementation FSDiscoveryBannerViewModel

- (instancetype)initWithBelongModule:(NSString *)belongModule
{
    self = [super init];
    if (self) {
        
        _belongModule = belongModule;
        
        @weakify(self);
        _bannerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[self bannerCacheSignal] merge:[self fetchBannerSignal]];
        }];
        [_bannerCommand.executionSignals.switchToLatest.distinctUntilChanged subscribeNext:^(NSDictionary *responseDic) {

            self.banners = [self parseResponseDic:responseDic];
        }];
        
        //网络信息错误
        [_bannerCommand.errors subscribeNext:^(NSError *error) {
            self.error = error;
        }];
        
        //每次请求前，清理掉上次的错误
        [_bannerCommand.executing subscribeNext:^(id x) {
            
            if([x boolValue] == YES)
            {
                self.error = nil;
            }
        }];
        
    }
    return self;
}

- (RACSignal *)fetchBannerSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        FSDiscoveryBannerRequest *request = [[FSDiscoveryBannerRequest alloc] init];
        request.belongModule = self.belongModule;
        
        [request startWithCompletionBlockWithSuccess:^(__kindof CMBaseRequest * _Nonnull request) {
            NSDictionary *responseDic = request.responseJSONObject;
            NSArray *resultArray = [self parseResponseDic:responseDic];
            
            NSLog(@"belongMode is %@ responseDic is %@", self.belongModule, responseDic);
            
            if (resultArray) {
                [subscriber sendNext:responseDic];
            }
            [subscriber sendCompleted];
        } failure:^(__kindof CMBaseRequest * _Nonnull request) {
            [subscriber sendError:request.error];
        }];
        return [RACDisposable disposableWithBlock:^{
            
            
        }];
    }];
}

- (RACSignal *)bannerCacheSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        FSDiscoveryBannerRequest *request = [[FSDiscoveryBannerRequest alloc] init];
        request.belongModule = self.belongModule;
        
        if ([request loadCacheWithError:nil]) {
            NSDictionary *responseDic = request.responseJSONObject;
            NSArray *resultArray = [self parseResponseDic:responseDic];
            if (resultArray) {
                [subscriber sendNext:responseDic];
            }
            [subscriber sendCompleted];
        } else {
            [subscriber sendCompleted];
        }
        return [RACDisposable disposableWithBlock:^{
            
            
        }];
    }];
}

- (NSArray<FSDiscoveryBanner *> *)parseResponseDic:(NSDictionary *)responseDic {
    
    NSMutableArray *resultArray = [NSMutableArray array];
    NSDictionary *data = [responseDic CM_dictionaryForKey:@"data"];
    NSArray *entrace = [data CM_arrayForKey:@"entrace"];
    [entrace enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *entraceDic = (NSDictionary *)obj;
            NSString *bannerID = [entraceDic CM_stringForKey:@"id"];
            NSString *imgURL = [entraceDic CM_stringForKey:@"imgUrl"];
            NSString *linkURL = [entraceDic CM_stringForKey:@"linkUrl"];
            FSDiscoveryBanner *banner = ({
                FSDiscoveryBanner *banner = [[FSDiscoveryBanner alloc] init];
                banner.bannerID = bannerID;
                banner.imgURL = imgURL;
                banner.linkURL = linkURL;
                banner;
            });
            [resultArray fs_addObject:banner];
        }
    }];
    return resultArray;
}

@end
