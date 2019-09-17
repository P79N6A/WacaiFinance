//
//  FSFeedbackRequest.m
//  WcbFinanceApp
//
//  Created by 叶帆 on 08/03/2018.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSFeedbackRequest.h"
#import "EnvironmentInfo.h"
#import "FSAPPRequestInterface.h"

@implementation FSFeedbackRequest {
    NSString *_content;
    NSString *_email;
}

- (id)initWithContent:(NSString *)content email:(NSString *)email {
    self = [super init];
    if (self) {
        _content = content;
        _email = email;
    }
    return self;
}

- (CMRequestMethod)requestMethod {
    return CMRequestMethodPOST;
}

- (NSString *)requestUrl {
    NSString *financeBaseURL = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeFinance];
    return [NSString stringWithFormat:@"%@%@", financeBaseURL, fs_feedback];
}

- (id)requestParam {
    return @{
             @"content" : _content,
             @"contact" : _email
             };
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    NSMutableDictionary *addtionalHeader = [NSMutableDictionary dictionary];
    //理财 Header 中使用的 AppVer 为三位数，公共实现为四位数版本，故在此覆盖 x-appver 字段
    NSString *shortVersionString = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    [addtionalHeader fs_setObjectMaybeNil:shortVersionString forKey:@"X-Appver"];
    //接口要求指定字符集为 UTF-8 ，否则后端会出现乱码
    [addtionalHeader fs_setObjectMaybeNil:@"application/x-www-form-urlencoded; charset=UTF-8" forKey:@"Content-Type"];
    return addtionalHeader;
}

@end
