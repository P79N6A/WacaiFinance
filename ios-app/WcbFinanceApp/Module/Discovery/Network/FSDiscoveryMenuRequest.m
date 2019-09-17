//
//  FSDiscoveryMenuRequest.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/22.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryMenuRequest.h"
#import "FSCommonParam.h"

@implementation FSDiscoveryMenuRequest

- (NSInteger)cacheTimeInSeconds {
    return -1;
}

- (id)requestParam
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params  fs_setObjectMaybeNil:self.menuId forKey:@"area"];
    return params;
}

- (NSString *)requestUrl {
    NSString *financeBaseURL = [FSCommonParam commonParam:fs_apiBaseUrl];;
    return [NSString stringWithFormat:@"%@/%@", financeBaseURL, fs_homeMenu];
}


@end
