//
//  FSMenuData.m
//  FinanceApp
//
//  Created by xingyong on 7/26/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSMenuData.h"
#import "NSDictionary+FSUtils.h"
#import <YYModel/YYModel.h>
@implementation FSMenuData
 
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [self yy_modelEncodeWithCoder:aCoder];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        [self yy_modelInitWithCoder:aDecoder];
    }
    
    return self;
}

#pragma mark - IGListDiffable

- (id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(id)object {
    // since the diff identifier returns self, object should only be compared with same instance
    return self == object;
}


@end
