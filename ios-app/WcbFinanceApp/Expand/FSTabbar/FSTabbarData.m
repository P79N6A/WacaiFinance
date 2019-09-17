//
//  FSTabbarData.m
//  FinanceApp
//
//  Created by xingyong on 7/25/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSTabbarData.h"
#import "NSDictionary+FSUtils.h"

@implementation FSTabbarData

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {

        NSDictionary *colorDic    = [dict fs_objectMaybeNilForKey:@"fontColor"];
        self.normalColor          = [colorDic fs_objectMaybeNilForKey:@"off"];
        self.selectedColor        = [colorDic fs_objectMaybeNilForKey:@"on"];

        NSDictionary *iconDic     = [dict fs_objectMaybeNilForKey:@"iconSrc"];
        self.normalUrl            = [iconDic fs_objectMaybeNilForKey:@"off"];
        self.selectedUrl          = [iconDic fs_objectMaybeNilForKey:@"on"];

        self.name                 = [dict fs_objectMaybeNilForKey:@"name"];
        
    }
    
    return self;
    
}

@end
