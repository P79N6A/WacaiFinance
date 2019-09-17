//
//  FSDiscoveryPost.h
//  Financeapp
//
//  Created by kuyeluofan on 20/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FSDiscoveryPostType) {
    FSDiscoveryPostTypeNone     = 0,
    FSDiscoveryPostTypeHot      = 1,
    FSDiscoveryPostTypeLatest   = 2,
};

@interface FSDiscoveryPost : NSObject

@property (nonatomic, assign) FSDiscoveryPostType type;
@property (nonatomic, copy) NSString *postid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, copy) NSString *moduleId;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSString *readCountString;
@property (nonatomic, copy) NSString *illustrationURL;
@property (nonatomic, copy) NSString *linkURL;
@property (nonatomic, assign) NSTimeInterval publishTime;
@property (nonatomic, assign) BOOL isInFirstTag;

@end
