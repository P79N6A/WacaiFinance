//
//  FSDiscoveryPostViewModel.h
//  Financeapp
//
//  Created by 叶帆 on 22/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSDiscoveryPost.h"

@interface FSDiscoveryPostViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *firstPagePostCommand;
@property (nonatomic, strong, readonly) RACCommand *morePostCommand;
@property (nonatomic, strong) NSArray<FSDiscoveryPost *> *posts;
@property (nonatomic, assign) BOOL noMorePosts;

@property (nonatomic, strong) NSError *firstPostError;
@property (nonatomic, strong) NSError *morePostError;

@end
