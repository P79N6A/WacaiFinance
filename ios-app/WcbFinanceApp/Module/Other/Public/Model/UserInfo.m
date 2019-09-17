//
//  UserInfo.m
//  FinanceApp
//
//  Created by new on 15/1/17.
//  Copyright (c) 2015年 com.wacai.licai. All rights reserved.
//

#import "UserInfo.h"
#import "FinanceNotifications.h"
#import "MD5.h"
#import "CMAbstractSDK.h"
#import "EnvironmentInfo.h"
#import "TPKCookieManager.h"
#import "CMAppProfile.h"
#import "LoginRegisterSDK.h"
#import "LRCenterManager.h"
#import <FSNewerRequest.h>


#define KEY_loginBuyUser            @"loginBuyUser"

#define KEY_ROOT_USER_INFO          @"RecordLocalPersonInfo"
#define USER_INFO_CODED_NAME        @"GobalPersonInfo"

#define KEY_USER_ID                 @"userID"
#define KEY_USER_UDID               @"userUdid"
#define KEY_USER_ACCOUNT            @"userAccount"
#define KEY_USER_ACCOUNT_SHOW       @"accountShow"
#define KEY_USER_NICK_NAME          @"nickName"
#define KEY_USER_EMAIL              @"userEmail"
#define KEY_USER_PHONE              @"userTel"
#define KEY_USER_HAS_BOUND_PHONE    @"hasBoundPhone"

#define KEY_USER_AVATOR             @"userAvator"
#define KEY_BINDCARD_STATUS         @"bindCardStatus"
#define KEY_REALNAME_STATUS         @"realNameStatus"
#define KEY_LEVEL_FLAG              @"levelFlag"
#define KEY_LEVEL_VALUE             @"levelValue"

#define KEY_USER_TOKEN              @"token"
#define KEY_USER_REFRESH_TOKEN      @"refreshToken"



@implementation UserInfo

- (id)init{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (UserInfo*)sharedInstance {
    static dispatch_once_t onceToken;
    static UserInfo *instance;
    dispatch_once(&onceToken, ^{
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_ROOT_USER_INFO];
        if (nil != data) {
            [NSKeyedUnarchiver setClass:[UserInfo class] forClassName:USER_INFO_CODED_NAME];
            instance = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        } else {
            instance = [[UserInfo alloc] init];
        }
    });
    
    return instance;
}




//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.mUserId forKey:KEY_USER_ID];
    [encoder encodeObject:self.mUserUdid forKey:KEY_USER_UDID];
    [encoder encodeObject:self.mUserAccount forKey:KEY_USER_ACCOUNT];
    [encoder encodeObject:self.accountShow forKey:KEY_USER_ACCOUNT_SHOW];
    [encoder encodeObject:self.mNickName forKey:KEY_USER_NICK_NAME];
    [encoder encodeObject:self.mUserEmail forKey:KEY_USER_EMAIL];
    [encoder encodeObject:self.mUserPhone forKey:KEY_USER_PHONE];
    [encoder encodeObject:self.hasBoundPhone forKey:KEY_USER_HAS_BOUND_PHONE];
    [encoder encodeObject:self.userAvator forKey:KEY_USER_AVATOR];
    [encoder encodeObject:self.bindCardStatus forKey:KEY_BINDCARD_STATUS];
    [encoder encodeObject:self.realNameStatus forKey:KEY_REALNAME_STATUS];
    [encoder encodeObject:self.levelFlag forKey:KEY_LEVEL_FLAG];
    [encoder encodeObject:self.levelValue forKey:KEY_LEVEL_VALUE];
    [encoder encodeObject:self.token forKey:KEY_USER_TOKEN];
    [encoder encodeObject:self.refreshToken forKey:KEY_USER_REFRESH_TOKEN];
    [encoder encodeObject:self.isFinanceOldUser forKey:KEY_loginBuyUser];

 
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.mUserId = [decoder decodeObjectForKey:KEY_USER_ID];
        self.mUserUdid = [decoder decodeObjectForKey:KEY_USER_UDID];
        self.mUserAccount = [decoder decodeObjectForKey:KEY_USER_ACCOUNT];
        self.accountShow = [decoder decodeObjectForKey:KEY_USER_ACCOUNT_SHOW];
        self.mNickName = [decoder decodeObjectForKey:KEY_USER_NICK_NAME];
        self.mUserEmail = [decoder decodeObjectForKey:KEY_USER_EMAIL];
        self.mUserPhone = [decoder decodeObjectForKey:KEY_USER_PHONE];
        self.hasBoundPhone = [decoder decodeObjectForKey:KEY_USER_HAS_BOUND_PHONE];
        self.userAvator = [decoder decodeObjectForKey:KEY_USER_AVATOR];
        self.bindCardStatus = [decoder decodeObjectForKey:KEY_BINDCARD_STATUS];
        self.realNameStatus = [decoder decodeObjectForKey:KEY_REALNAME_STATUS];
        self.levelFlag = [decoder decodeObjectForKey:KEY_LEVEL_FLAG];
        self.levelValue = [decoder decodeObjectForKey:KEY_LEVEL_VALUE];
        self.token = [decoder decodeObjectForKey:KEY_USER_TOKEN];
        self.refreshToken = [decoder decodeObjectForKey:KEY_USER_REFRESH_TOKEN];
        self.isFinanceOldUser   = [decoder decodeObjectForKey:KEY_loginBuyUser];
    
    }
    return self;
}

#pragma mark Class Methods

- (BOOL)isLogged {
    return [self.token length] > 0;
}

- (void)save {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self] forKey:KEY_ROOT_USER_INFO];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}



- (void)reset {
    
    [FSNetworkCache removeAllHttpCache];
    
    self.mUserId = nil;
    self.mUserUdid = nil;
    self.mUserAccount = nil;
    self.accountShow = nil;
    self.mNickName = nil;
    self.mUserEmail = nil;
    self.mUserPhone = nil;
    self.hasBoundPhone = nil;
    self.userAvator = [UIImage imageNamed:@"default_profile"];
    self.bindCardStatus = nil;
    self.realNameStatus = nil;
    self.levelFlag = nil;
    self.levelValue = nil;
    self.token = nil;
    self.refreshToken = nil;
    self.isFinanceOldUser = @(0);
    
}
 

- (void)logout {
   
    [self reset];
    [self save];
    
 
    [SDK_MGR cleanPersistentDatas];
    
    [self deleteCookie];
    
    
    // 账户注销后，不需要刷新当前的SDK页面，避免当前页面重复请求登录窗口.
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_USER_SWITCHED object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:LRUserDidLogoutSuccessNotification object:nil];

}

- (void)deleteCookie {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

- (void)updateUserInfo:(LRLoginUser *)userInfo{
    
    USER_INFO.mUserId       = userInfo.mUserId;
    USER_INFO.mUserUdid     = userInfo.mUid;
    USER_INFO.mUserPhone    = userInfo.mMobilePhoneNumber;
    USER_INFO.token         = userInfo.mToken;
    USER_INFO.refreshToken  = userInfo.mRefreshToken;
    USER_INFO.mNickName     = userInfo.mNickName;
    USER_INFO.mUserAccount  = userInfo.mAccount;
    USER_INFO.accountShow   = [userInfo userNameForLogin];
    USER_INFO.hasBoundPhone = @(userInfo.mActivateSMS);
    [USER_INFO save];
    
    [[TPKCookieManager sharedInstance] fillCookiesIfNeeded];
    
}



- (void)updateIsNewerIfNeededWithOnDoneBlock:(FSNewerRequestOnDoneBlock)onDone {
    if ([USER_INFO.isFinanceOldUser boolValue]) {
        if (onDone) {
            onDone();
        }
    } else {
        [self updateIsNewerWithOnDoneBlock:onDone];
    }
}

- (void)updateIsNewerWithOnDoneBlock:(FSNewerRequestOnDoneBlock)onDone {
    FSNewerRequest *request = [[FSNewerRequest alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof CMBaseRequest * _Nonnull request) {
        NSDictionary *responseDic = request.responseJSONObject;
        
        if (responseDic) {
            NSDictionary *dataDic = [responseDic fs_objectMaybeNilForKey:@"data"];
            BOOL isNewer = [[dataDic fs_objectMaybeNilForKey:@"isNewer"] boolValue];
            if (![USER_INFO.token CM_isValidString]) {
                USER_INFO.isFinanceOldUser = @(0);
            }else{
                USER_INFO.isFinanceOldUser = @(!isNewer);
            }
            [USER_INFO save];
        }
        if (onDone) {
            onDone();
        }
        
    } failure:^(__kindof CMBaseRequest * _Nonnull request) {
        NSInteger statusCode = request.responseStatusCode;
        if(statusCode == 403 || statusCode == 401) {
            USER_INFO.isFinanceOldUser = @(0);
            [USER_INFO save];
        }
        if (onDone) {
            onDone();
        }
    }];
}



@end
