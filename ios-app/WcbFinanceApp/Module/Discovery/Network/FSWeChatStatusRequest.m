//
//  FSWeChatStatusRequest.m
//  WcbFinanceApp
//
//  Created by tesila on 2018/11/21.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSWeChatStatusRequest.h"
#import "EnvironmentInfo.h"

//接口文档 http://client.wacai.info/api-doc/project/442/doc/22560

static NSString *const kWeChatOfficialAccountsID_Test = @"wxb343d24555aaecb6";
static NSString *const kWeChatOfficialAccountsID_Release = @"wxf00d59819dc9469e";

@implementation FSWeChatStatusRequest

- (NSString *)baseUrl {
    if ([EnvironmentInfo sharedInstance].isDebugEnvironment) {
        return @"http://hera.ngrok.wacaiyun.com";
    } else {
        return @"https://www.wacai.com";
    }
}

- (NSString *)requestUrl {
    if ([EnvironmentInfo sharedInstance].isDebugEnvironment) {
        return @"/user/status";
    } else {
        return @"/wechat/user/status";
    }
    
}

- (id)requestParam {
    BOOL isDebug = [EnvironmentInfo sharedInstance].isDebugEnvironment;
    return @{
             @"appid": isDebug ? kWeChatOfficialAccountsID_Test : kWeChatOfficialAccountsID_Release
             };
}

@end
