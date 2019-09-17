//
//  FSLRRequestFactory.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/1/26.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LRCenterManager.h>
#import <LRRequestFactory.h>

@interface FSLRRequestFactory : NSObject

+ (void)userRegisterGetVoiceCode:(NSDictionary *)registerInfo
                         success:(void (^)(id json))success
                         failure:(void (^)(NSError *error))failure;


+ (void)getVoiceCodeForMobileNumber:(NSDictionary *)info
                            success:(void (^)(id json))success
                            failure:(void (^)(NSError *error))failure;

+ (void)getSmsCodeForBindMobileNumber:(NSDictionary *)info
                           success:(void (^)(id json))success
                           failure:(void (^)(NSError *error))failure;



+ (void)fetchAgreementsWithSuccess:(void (^)(id json))success
                           failure:(void (^)(NSError *error))failure;



@end
