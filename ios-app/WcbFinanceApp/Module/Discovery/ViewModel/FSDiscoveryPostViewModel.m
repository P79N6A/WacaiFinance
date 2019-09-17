//
//  FSDiscoveryPostViewModel.m
//  Financeapp
//
//  Created by 叶帆 on 22/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryPostViewModel.h"
#import "FSDiscoveryPostRequest.h"

@interface FSDiscoveryPostViewModel()

@property (nonatomic, assign) NSTimeInterval lastPublishTime;

@end

@implementation FSDiscoveryPostViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.lastPublishTime = 0;
        self.noMorePosts = NO;
        
        @weakify(self);
        _firstPagePostCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *tagID) {
            @strongify(self);
            NSTimeInterval lastPublishTime = 0;
            
            return [[self postCacheSignalWithTagID:tagID lastPublishTime:lastPublishTime]
                    merge:[self fetchPostSignalWithTagID:tagID lastPublishTime:lastPublishTime]];
            
        }];
        [_firstPagePostCommand.executionSignals.switchToLatest.distinctUntilChanged subscribeNext:^(NSDictionary *responseDic) {
            self.posts = [self parseResponseDic:responseDic];
            if (self.posts.count > 0) {
                self.lastPublishTime = self.posts.lastObject.publishTime;
                self.noMorePosts = NO;
            } else {
                self.noMorePosts = YES;
            }
        }];
        
        //tag第一页网络错误信息
        [_firstPagePostCommand.errors subscribeNext:^(NSError *error){
            self.firstPostError = error;
        }];
        
        //tag第一页每次请求前，清理掉上次的错误
        [_firstPagePostCommand.executing subscribeNext:^(id x) {
            
            if([x boolValue] == YES)
            {
                self.firstPostError = nil;
            }
        }];
        
        _morePostCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *tagID) {
            @strongify(self);
            return [self fetchPostSignalWithTagID:tagID lastPublishTime:self.lastPublishTime];
        }];
        [_morePostCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *responseDic) {
            @strongify(self);
            NSArray *morePosts = [self parseResponseDic:responseDic];
            if (morePosts.count > 0) {
                NSArray *originPosts = self.posts;
                self.posts = [originPosts arrayByAddingObjectsFromArray:morePosts];
                self.lastPublishTime = self.posts.lastObject.publishTime;
                self.noMorePosts = NO;
            } else {
                self.noMorePosts = YES;
            }
        }];
        
        //更多数据请求错误
        [_morePostCommand.errors subscribeNext:^(NSError *error){
            self.morePostError = error;
        }];
        
        //更多数据请求错误，清理掉上次的错误
        [_morePostCommand.executing subscribeNext:^(id x) {
            
            if([x boolValue] == YES)
            {
                self.morePostError = nil;
            }
        }];
    }
    return self;
}

- (RACSignal *)postCacheSignalWithTagID:(NSString *)tagID lastPublishTime:(NSTimeInterval)lastPublishTime{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        FSDiscoveryPostRequest *request = [[FSDiscoveryPostRequest alloc] init];
        request.moduleId = tagID;
        request.lastPublishTime = @(lastPublishTime);
        request.pageSize = @10;
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

- (RACSignal *)fetchPostSignalWithTagID:(NSString *)tagID lastPublishTime:(NSTimeInterval)lastPublishTime{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        FSDiscoveryPostRequest *request = [[FSDiscoveryPostRequest alloc] init];
        request.moduleId = tagID;
        request.lastPublishTime = @(lastPublishTime);
        request.pageSize = @10;
        [request startWithCompletionBlockWithSuccess:^(__kindof CMBaseRequest * _Nonnull request) {
            NSDictionary *responseDic = request.responseJSONObject;
            NSArray *resultArray = [self parseResponseDic:responseDic];
            
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

- (NSArray<FSDiscoveryPost *> *)parseResponseDic:(NSDictionary *)responseDic {
    NSMutableArray *resultArray = [NSMutableArray array];
    NSDictionary *data = [responseDic CM_dictionaryForKey:@"data"];
    NSArray *posts = [data CM_arrayForKey:@"list"];
    [posts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *postDic   = (NSDictionary *)obj;
            NSString *contentURL    =  [postDic CM_stringForKey:@"contentUrl"];
            NSString *hottag        =  [postDic CM_stringForKey:@"hottag"];
            NSString *imageURL      =  [postDic CM_stringForKey:@"img"];
            NSString *moduleName    =  [postDic CM_stringForKey:@"moduleName"];
            NSString *moduleId      =  [postDic CM_stringForKey:@"moduleId"];
            NSString *pageView      =  [postDic CM_stringForKey:@"pageView"];
            NSTimeInterval publishTime = [postDic CM_doubleForKey:@"publishTime"];
            NSString *reporter         = [postDic CM_stringForKey:@"reporter"];
            NSString *title            = [postDic CM_stringForKey:@"title"];
            NSString *postid        = [postDic CM_stringForKey:@"id"];
            
            FSDiscoveryPost *post = ({
                FSDiscoveryPost *post = [[FSDiscoveryPost alloc] init];
                post.title = title;
                post.type = [self typeWithString:hottag];
                post.moduleName = moduleName;
                post.moduleId = moduleId;
                post.authorName = reporter;
                post.readCountString = pageView;
                post.illustrationURL = imageURL;
                post.linkURL = contentURL;
                post.publishTime = publishTime;
                post.postid = postid;
                post;
            });
            
            [resultArray fs_addObject:post];
        }
    }];
    return resultArray;
}

- (FSDiscoveryPostType)typeWithString:(NSString *)typeString {
    if ([typeString isEqualToString:@"热门"]) {
        return FSDiscoveryPostTypeHot;
    } else if ([typeString isEqualToString:@"最新"]) {
        return FSDiscoveryPostTypeLatest;
    } else {
        return FSDiscoveryPostTypeNone;
    }
}


@end
