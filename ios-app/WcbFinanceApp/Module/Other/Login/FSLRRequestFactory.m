//
//  FSLRRequestFactory.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/1/26.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSLRRequestFactory.h"
#import <AFNetworking.h>

@implementation FSLRRequestFactory

+ (void)userRegisterGetVoiceCode:(NSDictionary *)registerInfo
                         success:(void (^)(id json))success
                         failure:(void (^)(NSError *error))failure;
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@/getVoiceVerCodeCube",
                     [LRCenterManager sharedInstance].requestScheme, [LRCenterManager sharedInstance].requestHost, LRRegisterRequestDomin];
    
    NSLog(@"login sdk:注册请求语音验证码:%@,%@", url, registerInfo);
    
    [FSLRRequestFactory postWithURL:url params:registerInfo success:^(id json) {
        NSLog(@"login sdk:注册请求语音验证码成功:%@",json);
        
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        NSLog(@"login sdk:注册请求语音验证码失败:%@",error);
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getVoiceCodeForMobileNumber:(NSDictionary *)info
                            success:(void (^)(id json))success
                            failure:(void (^)(NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@/bind_mob/getVoiceVerCodeCube",
                     [LRCenterManager sharedInstance].requestScheme, [LRCenterManager sharedInstance].requestHost];
    
    NSLog(@"login sdk:绑定手机请求语音验证码:%@,%@", url, info);
    
    [FSLRRequestFactory postWithURL:url params:info success:^(id json) {
        NSLog(@"login sdk:绑定手机请求语音验证码成功:%@",json);
        
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        NSLog(@"login sdk:绑定手机请求语音验证码失败:%@",error);
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getSmsCodeForBindMobileNumber:(NSDictionary *)info
                           success:(void (^)(id json))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@/bind_mob/getVerCodeCube",
                     [LRCenterManager sharedInstance].requestScheme, [LRCenterManager sharedInstance].requestHost];
    
    NSLog(@"login sdk:绑定手机请求短信验证码:%@,%@", url, info);
    
    [FSLRRequestFactory postWithURL:url params:info success:^(id json) {
        NSLog(@"login sdk:绑定手机请求短信验证码成功:%@",json);
        
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        NSLog(@"login sdk:绑定手机请求短信验证码失败:%@",error);
        
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)fetchAgreementsWithSuccess:(void (^)(id json))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@/agreements",
                     [LRCenterManager sharedInstance].requestScheme, [LRCenterManager sharedInstance].requestHost, LRRegisterRequestDomin];
    
    [FSLRRequestFactory getWithURL:url params:nil success:^(id json) {
        NSLog(@"login sdk:绑定手机请求语音验证码成功:%@",json);
        
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        NSLog(@"login sdk:绑定手机请求语音验证码失败:%@",error);
        
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes
    = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    
    [[[LRCenterManager sharedInstance] requestHeaders] enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        if (obj.length > 0) { [manager.requestSerializer setValue:obj forHTTPHeaderField:key]; }
    }];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) { success(responseObject); }
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) { failure(error); }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes
    = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [[LRManager requestHeaders] enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *val, BOOL *stop) {
        if (val.length > 0) { [manager.requestSerializer setValue:val forHTTPHeaderField:key]; }
    }];
    
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        if (success) { success(responseObject); }
        [manager invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) { failure(error); }
        [manager invalidateSessionCancelingTasks:YES];
    }];
}

@end
