//
//  FSDiscoveryTag.m
//  Financeapp
//
//  Created by 叶帆 on 21/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryTag.h"

@implementation FSDiscoveryTag

+ (instancetype)tagWithName:(NSString *)name ID:(NSString *)tagID {
    return [[self alloc] initWithName:name ID:tagID];
}

- (instancetype)initWithName:(NSString *)name ID:(NSString *)tagID {
    self = [super init];
    if (self) {
        self.name = name;
        self.tagID = tagID;
    }
    return self;
}

@end
