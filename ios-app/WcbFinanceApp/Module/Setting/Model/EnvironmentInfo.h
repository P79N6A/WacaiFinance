//
//  EnvironmentInfo.h
//  FinanceApp
//
//  Created by 叶帆 on 1/13/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FSEnvironmentType) {
    FSEnvironmentTypeDevelop = 0,
    FSEnvironmentTypeTest1,
    FSEnvironmentTypeTest2,
    FSEnvironmentTypePreRelease,
    FSEnvironmentTypeOnline,
};

typedef NS_ENUM(NSUInteger, FSURLType){
    FSURLTypeMainDomain = 1,
    FSURLTypeFinance,
    FSURLTypeServiceWindow,
    FSURLTypeMsgCenter,
    FSURLTypeForgetPwd,
    FSURLTypeCookieDomain,
    FSURLTypeStock,
    FSURLTypeLotusseedKey,
    FSURLTypeMemberCenter,
};

@interface EnvironmentInfo : NSObject

@property (nonatomic)BOOL needPrintBILog;

+ (instancetype)sharedInstance;

- (FSEnvironmentType)currentEnvironment;
- (void)switchEnvironmentTo:(FSEnvironmentType)environmentType;

- (NSString *)URLStringOfCurrentEnvironmentURLType:(FSURLType)URLType;
- (void)setURLString:(NSString *)URLString ofEnvironment:(FSEnvironmentType)environmentType URLType:(FSURLType)URLType;

- (BOOL)isDebugEnvironment;
- (BOOL)isNewlyInstallation;

@end
