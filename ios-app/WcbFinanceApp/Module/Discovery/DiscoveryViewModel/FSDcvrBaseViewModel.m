//
//  FSDcvrBaseViewModel.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/11.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDcvrBaseViewModel.h"

@implementation FSDcvrBaseViewModel

#pragma mark - IGListDiffable
- (id<NSObject>)diffIdentifier {
    //TODO 待优化
    //    return @(_type);
    return self;
}

- (BOOL)isEqualToDiffableObject:(id)object {
    // since the diff identifier returns self, object should only be compared with same instance
    return self == object;
}

- (BOOL)hasError
{
    if(self.error)
    {
        return YES;
    }
    
    return NO;
}

@end
