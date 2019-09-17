//
//  FSDiscoveryBanner.m
//  Financeapp
//
//  Created by 叶帆 on 21/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryBanner.h"

@implementation FSDiscoveryBanner

#pragma mark - IGListDiffable
- (id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(id)object {
    // since the diff identifier returns self, object should only be compared with same instance
    return self == object;
}

@end
