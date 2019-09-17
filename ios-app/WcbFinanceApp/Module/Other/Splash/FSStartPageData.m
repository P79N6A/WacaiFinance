//
//  FSStartPageData.m
//  FinanceApp
//
//  Created by xingyong on 29/11/2016.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSStartPageData.h"

@implementation FSStartPageData
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];

    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        
        self.mid          = [dict fs_objectMaybeNilForKey:@"id"];
        self.mimgUrls      = [dict fs_objectMaybeNilForKey:@"imgUrls"];
        self.mimgUrl      = [dict fs_objectMaybeNilForKey:@"imgUrl"];
        self.mlinkUrl     = [dict fs_objectMaybeNilForKey:@"linkUrl"];
        self.mpageName    = [dict fs_objectMaybeNilForKey:@"pageName"];
    
    }

    return self;

}

@end
