//
//  FSDiscoveryBadgeViewModel.m
//  Financeapp
//
//  Created by 叶帆 on 07/09/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryBadgeViewModel.h"
#import "FSDiscoveryTagRequest.h"
#import "FSDiscoveryPostRequest.h"
#import "FSDiscoveryTag.h"
#import "FSDiscoveryPost.h"

@interface FSDiscoveryBadgeViewModel()<CMChainRequestDelegate>

@property (strong, nonatomic) NSArray<NSNumber *> *cacheArray;

@end

@implementation FSDiscoveryBadgeViewModel

- (void)requestBadgeCount {
    FSDiscoveryTagRequest *tagRequest = [[FSDiscoveryTagRequest alloc] init];
    CMChainRequest *chainReq = [[CMChainRequest alloc] init];
    [chainReq addRequest:tagRequest callback:^(CMChainRequest * _Nonnull chainRequest, CMBaseRequest * _Nonnull baseRequest) {
        NSString *firstTagID = [self firstTagIDFromResponseDic:baseRequest.responseJSONObject];
        self.cacheArray = [self cacheSetWithTagID:firstTagID] ?: [NSArray array];
        FSDiscoveryPostRequest *postRequest = [[FSDiscoveryPostRequest alloc] init];
        postRequest.moduleId = firstTagID;
        [chainRequest addRequest:postRequest callback:nil];
    }];
    chainReq.delegate = self;
    [chainReq start];
}

- (void)chainRequestFinished:(CMChainRequest *)chainRequest {
    FSDiscoveryPostRequest *postRequest = (FSDiscoveryPostRequest *)chainRequest.requestArray.lastObject;
    NSArray *responseArray = [self parsePostIDResponseDic:postRequest.responseJSONObject];
    self.unreadCount = [self unreadCountWithResponseArray:responseArray cacheArray:self.cacheArray];
}

- (NSNumber *)unreadCountWithResponseArray:(NSArray *)responseArray cacheArray:(NSArray *)cacheArray {
    NSSet *mergeSet = [NSSet setWithArray:[responseArray arrayByAddingObjectsFromArray:cacheArray]];
    NSInteger unreadCount = mergeSet.count - cacheArray.count;
    //产品 @木鱼 制定的策略
    if (cacheArray.count <= 0) {
        unreadCount = 1;
    }
    if (unreadCount > 10) {
        unreadCount = 10;
    }
    return @(unreadCount);
}

- (NSArray<NSNumber *> *)cacheSetWithTagID:(NSString *)tagID {
    NSArray<NSNumber *> *resultArray = [NSMutableArray array];
    FSDiscoveryPostRequest *postCacheRequest = [[FSDiscoveryPostRequest alloc] init];
    postCacheRequest.moduleId = tagID;
    if ([postCacheRequest loadCacheWithError:nil]) {
        NSDictionary *postsJSONDic = postCacheRequest.responseJSONObject;
        resultArray = [self parsePostIDResponseDic:postsJSONDic];
    }
    return resultArray;
}

- (NSString *)firstTagIDFromResponseDic:(NSDictionary *)responseDic {
    NSDictionary *data = [responseDic CM_dictionaryForKey:@"data"];
    NSArray *modules = [data CM_arrayForKey:@"modules"];
    NSDictionary *moduleDic = [modules fs_objectAtIndex:0];
    NSString *tagID = [moduleDic CM_stringForKey:@"id"];
    return tagID;
}

- (NSArray<NSNumber *> *)parsePostIDResponseDic:(NSDictionary *)responseDic {
    NSMutableArray *resultArray = [NSMutableArray array];
    NSDictionary *data = [responseDic CM_dictionaryForKey:@"data"];
    NSArray *posts = [data CM_arrayForKey:@"list"];
    [posts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *postDic = (NSDictionary *)obj;
            NSNumber *postID = @([postDic CM_longForKey:@"id"]);
            [resultArray fs_addObject:postID];
        }
    }];
    return [resultArray copy];
}

@end
