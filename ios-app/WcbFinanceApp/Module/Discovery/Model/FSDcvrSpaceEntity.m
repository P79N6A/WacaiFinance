//
//  FSDcvrSpaceEntity.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/5/29.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDcvrSpaceEntity.h"

@implementation FSDcvrSpaceEntity

- (id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(id)object {
    // since the diff identifier returns self, object should only be compared with same instance
    return self == object;
}

@end
