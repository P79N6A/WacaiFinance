//
//  UserInfo.h
//  FinanceApp
//
//  Introduction: Define wacai account information.
//
//  Created by new on 15/1/17.
//  Copyright (c) 2015年 com.wacai.licai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRLoginUser.h"

#define USER_INFO [UserInfo sharedInstance]

typedef void(^FSNewerRequestOnDoneBlock)();

@interface UserInfo : NSObject <NSCoding>

@property (nonatomic, copy) NSString *mUserId; // 32位
@property (nonatomic, copy) NSString *mUserUdid; // 服务端下发的数字
@property (nonatomic, copy) NSString *mUserAccount;
@property (nonatomic, copy) NSString *accountShow;
@property (nonatomic, copy) NSString *mNickName;
@property (nonatomic, copy) NSString *mUserEmail;
@property (nonatomic, copy) NSString *mUserPhone;
@property (nonatomic, strong) NSNumber *hasBoundPhone;//对应接口activateSMS字段

@property (nonatomic, strong) UIImage *userAvator;
@property (nonatomic, strong) NSNumber *bindCardStatus;
@property (nonatomic, strong) NSNumber *realNameStatus;
@property (nonatomic, copy  ) NSString *levelFlag;
@property (nonatomic, strong) NSNumber *levelValue;

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *refreshToken;

// 已经登录的新用户
@property(nonatomic, strong) NSNumber *isFinanceOldUser;


+ (UserInfo*)sharedInstance;

// 持久化存储对象.
- (void)save;

// 是否已登录.
- (BOOL)isLogged;

// 注销.
- (void)logout;


- (void)updateUserInfo:(LRLoginUser *)userInfo;

- (void)updateIsNewerIfNeededWithOnDoneBlock:(FSNewerRequestOnDoneBlock)onDone;

@end
