//
//  EnvironmentInfo.m
//  FinanceApp
//
//  Created by 叶帆 on 1/13/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "EnvironmentInfo.h"
#import "EGOCache.h"

static NSString *const kCurrentEnvironment = @"CurrentEnvironment"; //当前环境
static NSString *const kEnvironmentVersion = @"EnvironmentVersion"; //本plist有效的版本
static NSString *const kVersionNull = @"Null"; //如果Version取到空，返回该String
static NSString *const kPreviousReleaseVersion = @"PreviousReleaseVersion"; //上次安装App的版本号，若本次为全新安装，则为@"Null"
static NSString *const kLotusseedKey_Release = @"V0jK7JiQ5M8YdsdhKaP2";//莲子统计正式key
static NSString *const kLotusseedKey_Debug = @"G0o7m5IS8YMdU9ucJskc";//莲子统计测试key
@interface EnvironmentInfo ()

@property (strong ,nonatomic)NSMutableDictionary *infoDictionary;
@property (copy, nonatomic)NSString *previousReleaseVersion;

@end


@implementation EnvironmentInfo
@synthesize infoDictionary = _infoDictionary;
+ (instancetype)sharedInstance{
    static EnvironmentInfo *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (NSMutableDictionary *)defaultEnvironmentInfoDictionary{
    FSEnvironmentType defaultType = FSEnvironmentTypeOnline;
#ifdef kTestAppURL
    defaultType = FSEnvironmentTypeTest1;
#endif
    NSMutableDictionary *developerEnvironmentDictionary = [@{
                                                             [self FSURLTypeToStringKey:FSURLTypeMainDomain] :
                                                                 @"http://www.caimi-inc.com",
                                                             [self FSURLTypeToStringKey:FSURLTypeFinance] :
                                                                 @"http://8.caimi-inc.com",
                                                             [self FSURLTypeToStringKey:FSURLTypeServiceWindow] :
                                                                 @"http://api.dev.wacai.info/basic-biz",
                                                             [self FSURLTypeToStringKey:FSURLTypeMsgCenter] :
                                                                 @"http://message.test.wacai.info",
                                                             [self FSURLTypeToStringKey:FSURLTypeForgetPwd] :
                                                                 @"http://user.wacaiyun.com/resetPwd_h5?wacaiclientnav=0",
                                                             [self FSURLTypeToStringKey:FSURLTypeCookieDomain] :
                                                                 @".caimi-inc.com",
                                                             [self FSURLTypeToStringKey:FSURLTypeStock] :
                                                                 @"http://stock3.wacaiyun.com/api",
                                                             [self FSURLTypeToStringKey:FSURLTypeLotusseedKey] :
                                                                 kLotusseedKey_Debug,
                                                             [self FSURLTypeToStringKey:FSURLTypeMemberCenter] :
                                                                 @"http://vip.caimi-inc.com"
                                                            } mutableCopy];
    
    NSMutableDictionary *test1EnvironmentDictionary =  [@{
                                                          [self FSURLTypeToStringKey:FSURLTypeMainDomain] :
                                                              @"http://www.wacaiyun.com",
                                                          [self FSURLTypeToStringKey:FSURLTypeFinance] :
                                                              @"http://8.wacaiyun.com",
                                                          [self FSURLTypeToStringKey:FSURLTypeServiceWindow] :
                                                              @"http://api.test.wacai.info/basic-biz",
                                                          [self FSURLTypeToStringKey:FSURLTypeMsgCenter] :
                                                              @"http://message.test.wacai.info",
                                                          [self FSURLTypeToStringKey:FSURLTypeForgetPwd] :
                                                              @"http://user.wacaiyun.com/resetPwd_h5?wacaiclientnav=0",
                                                          [self FSURLTypeToStringKey:FSURLTypeCookieDomain] :
                                                              @".wacaiyun.com",
                                                          [self FSURLTypeToStringKey:FSURLTypeStock] :
                                                              @"http://stock3.wacaiyun.com/api",
                                                          [self FSURLTypeToStringKey:FSURLTypeLotusseedKey] :
                                                              kLotusseedKey_Debug,
                                                          [self FSURLTypeToStringKey:FSURLTypeMemberCenter] :
                                                              @"http://vip.wacaiyun.com"
                                                          } mutableCopy];

    
    NSMutableDictionary *test2EnvironmentDictionary = [@{
                                                         [self FSURLTypeToStringKey:FSURLTypeMainDomain] :
                                                             @"http://qa8.wacaiyun.com",
                                                         [self FSURLTypeToStringKey:FSURLTypeFinance] :
                                                             @"http://qa8.wacaiyun.com",
                                                         [self FSURLTypeToStringKey:FSURLTypeServiceWindow] :
                                                             @"http://api.test.wacai.info/basic-biz",
                                                         [self FSURLTypeToStringKey:FSURLTypeMsgCenter] :
                                                             @"http://message.test.wacai.info",
                                                         [self FSURLTypeToStringKey:FSURLTypeForgetPwd] :
                                                             @"http://user.wacaiyun.com/resetPwd_h5?wacaiclientnav=0",
                                                         [self FSURLTypeToStringKey:FSURLTypeCookieDomain] :
                                                             @".wacaiyun.com",
                                                         [self FSURLTypeToStringKey:FSURLTypeStock] :
                                                             @"http://stock3.wacaiyun.com/api",
                                                         [self FSURLTypeToStringKey:FSURLTypeLotusseedKey] :
                                                             kLotusseedKey_Debug,
                                                         [self FSURLTypeToStringKey:FSURLTypeMemberCenter] :
                                                             @"http://vip.wacaiyun.com"
                                                         } mutableCopy];
    
    NSMutableDictionary *preReleaseEnvironmentDictionary = [@{
                                                         [self FSURLTypeToStringKey:FSURLTypeMainDomain] :
                                                             @"https://www.wacai.com",
                                                         [self FSURLTypeToStringKey:FSURLTypeFinance] :
                                                             @"https://8.staging.wacai.com",
                                                         [self FSURLTypeToStringKey:FSURLTypeServiceWindow] :
                                                             @"http://api.test.wacai.info/basic-biz",
                                                         [self FSURLTypeToStringKey:FSURLTypeMsgCenter] :
                                                             @"https://msgcenter.wacai.com",
                                                         [self FSURLTypeToStringKey:FSURLTypeForgetPwd] :
                                                             @"http://user.staging.wacai.com/resetPwd_h5?wacaiclientnav=0",
                                                         [self FSURLTypeToStringKey:FSURLTypeCookieDomain] :
                                                             @".wacaiyun.com",
                                                         [self FSURLTypeToStringKey:FSURLTypeStock] :
                                                             @"https://gupiao.staging.wacai.com",
                                                         [self FSURLTypeToStringKey:FSURLTypeLotusseedKey] :
                                                             kLotusseedKey_Debug,
                                                         [self FSURLTypeToStringKey:FSURLTypeMemberCenter] :
                                                             @"http://vip.staging.wacai.info"
                                                         } mutableCopy];
    
    NSMutableDictionary *onlineEnvironmentDictionary = [@{
                                                          [self FSURLTypeToStringKey:FSURLTypeMainDomain] :
                                                              @"https://www.wacai.com",
                                                          [self FSURLTypeToStringKey:FSURLTypeFinance] :
                                                              @"https://8.wacai.com",
                                                          [self FSURLTypeToStringKey:FSURLTypeServiceWindow] :
                                                              @"https://basic.wacai.com/basic-biz",
                                                          [self FSURLTypeToStringKey:FSURLTypeMsgCenter] :
                                                              @"https://msgcenter.wacai.com",
                                                          [self FSURLTypeToStringKey:FSURLTypeForgetPwd] :
                                                              @"https://user.wacai.com/resetPwd_h5?wacaiclientnav=0",
                                                          [self FSURLTypeToStringKey:FSURLTypeCookieDomain] :
                                                              @".wacai.com",
                                                          [self FSURLTypeToStringKey:FSURLTypeStock] :
                                                              @"https://stock.wacai.com/api",
                                                          [self FSURLTypeToStringKey:FSURLTypeLotusseedKey] :
                                                              kLotusseedKey_Release,
                                                          [self FSURLTypeToStringKey:FSURLTypeMemberCenter] :
                                                              @"https://vip.wacai.com"
                                                          } mutableCopy];
    
    NSMutableDictionary *defaultEnvironmentInfoDictionary = [@{
                                                               [self FSEnvironmentTypeToStringKey:FSEnvironmentTypeDevelop]:developerEnvironmentDictionary,
                                                               [self FSEnvironmentTypeToStringKey:FSEnvironmentTypeTest1]:test1EnvironmentDictionary,
                                                               [self FSEnvironmentTypeToStringKey:FSEnvironmentTypeTest2]:test2EnvironmentDictionary,
                                                               [self FSEnvironmentTypeToStringKey:FSEnvironmentTypeOnline]:onlineEnvironmentDictionary,
                                                                [self FSEnvironmentTypeToStringKey:FSEnvironmentTypePreRelease]:preReleaseEnvironmentDictionary,
                                                               kCurrentEnvironment:[self FSEnvironmentTypeToStringKey:defaultType],
                                                               kEnvironmentVersion:Release_App_Ver
                                                               } mutableCopy];
    return defaultEnvironmentInfoDictionary;
}



#pragma mark - Plist Operations
- (BOOL)updateEnvironmentInfoPlistWith:(NSMutableDictionary *)dictionary{
   return [dictionary writeToFile:[self plistPath] atomically:YES];
}

- (NSMutableDictionary *)readEnvironmentInfoPlist{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:[self plistPath]];
    return dictionary;
}

- (NSString *)plistPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *environmentPlistPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"FinanceEnvironmentInfo.plist"];
    return environmentPlistPath;
}

- (BOOL)isFileExist{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[self plistPath]];
}

- (BOOL)environmentPlistHasExpired{
    if ([Release_App_Ver isEqualToString:[self environmentVersion]]) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)isDebugEnvironment
{
    FSEnvironmentType currentType =  [[EnvironmentInfo sharedInstance] currentEnvironment];
    BOOL debug = (currentType != FSEnvironmentTypeOnline) && (currentType != FSEnvironmentTypePreRelease);
    return debug;
}

- (BOOL)isNewlyInstallation {
    [self infoDictionary];//确保infoDictionary已经初始化
    if ([self.previousReleaseVersion isEqualToString:kVersionNull]) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - getter & setter
- (NSString *)URLStringOfCurrentEnvironmentURLType:(FSURLType)URLType{
    NSString *URLString = [self URLStringOfEnvironment:[self currentEnvironment] URLType:URLType];
    if (!URLString) {
        
        NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"环境配置中%@的值为nil", [self FSURLTypeToStringKey:URLType]]
                                                         reason:@"如果新增字段，请升级版本号或卸载后重新安装，即可自动生成新的Environment.plist！"
                                                       userInfo:nil];
        @throw exception;
    }
    return [self URLStringOfEnvironment:[self currentEnvironment] URLType:URLType];
}

- (NSString *)URLStringOfEnvironment:(FSEnvironmentType)environmentType URLType:(FSURLType)URLType{
    NSMutableDictionary *singleEnvironmentDictionary = [self dictionaryOfEnvironment:environmentType];
    return [singleEnvironmentDictionary objectForKey:[self FSURLTypeToStringKey:URLType]];
}

- (void)setURLString:(NSString *)URLString ofEnvironment:(FSEnvironmentType)environmentType URLType:(FSURLType)URLType{
    NSMutableDictionary *singleEnvironmentDictionary = [self dictionaryOfEnvironment:environmentType];
    [singleEnvironmentDictionary setObject:URLString forKey:[self FSURLTypeToStringKey:URLType]];
    NSMutableDictionary *tempDictionary = self.infoDictionary;
    [tempDictionary setObject:singleEnvironmentDictionary forKey:[self FSEnvironmentTypeToStringKey:environmentType]];
    self.infoDictionary = tempDictionary;
    //触发infoDictionary setter以持久化到plist
}

- (NSMutableDictionary *)dictionaryOfEnvironment:(FSEnvironmentType)environmentType{
    NSMutableDictionary *singleEnvironmentDictionary = [self.infoDictionary objectForKey:[self FSEnvironmentTypeToStringKey:environmentType]];
    return singleEnvironmentDictionary;
}

- (FSEnvironmentType)currentEnvironment{
    NSString *environmentString = [self.infoDictionary objectForKey:kCurrentEnvironment];
    return [self StringKeyToFSEnvironmentType:environmentString];
}

- (void)switchEnvironmentTo:(FSEnvironmentType)environmentType{
    NSMutableDictionary *tempDictionary = self.infoDictionary;
    tempDictionary[kCurrentEnvironment] = [self FSEnvironmentTypeToStringKey:environmentType];
    self.infoDictionary = tempDictionary;
    //触发infoDictionary setter以持久化到plist
}

- (NSString *)environmentVersion{
    //version直接读取plist而不经过infoDictionary Property的原因是为了避免自己判断自己有没有过期而递归调用
    if (![self isFileExist]) {
        return kVersionNull;
    }
    NSString *version = [[self readEnvironmentInfoPlist] objectForKey:kEnvironmentVersion];
    if (!version) {
        return kVersionNull;
    }
    return version;
}


- (NSMutableDictionary *)infoDictionary{
    if (!_infoDictionary) {
        
        BOOL isFileExist = [self isFileExist];
        BOOL environmentPlistHasExpired = [self environmentPlistHasExpired];
        if (!isFileExist || environmentPlistHasExpired) {

            if (!isFileExist) {
                self.previousReleaseVersion = kVersionNull;
            }
            
            if (environmentPlistHasExpired) {
                self.previousReleaseVersion = [self environmentVersion];
            }
            
            _infoDictionary = [self defaultEnvironmentInfoDictionary];
            [self updateEnvironmentInfoPlistWith:_infoDictionary];
        } else {
            _infoDictionary = [self readEnvironmentInfoPlist];
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.previousReleaseVersion forKey:kPreviousReleaseVersion];
        [userDefaults synchronize];
    }
    return _infoDictionary;
}

- (void)setInfoDictionary:(NSMutableDictionary *)infoDictionary{
    _infoDictionary = infoDictionary;
    [self updateEnvironmentInfoPlistWith:_infoDictionary];
}

- (NSString *)previousReleaseVersion {
    if (!_previousReleaseVersion) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *previousReleaseVersionInUserDefaults = [userDefaults objectForKey:kPreviousReleaseVersion];
        BOOL hasPreviousReleaseVersionInUserDefaults = previousReleaseVersionInUserDefaults != nil;
        if (hasPreviousReleaseVersionInUserDefaults) {
            return previousReleaseVersionInUserDefaults;
        } else {
            return kVersionNull;
        }
    }
    return _previousReleaseVersion;
}


#pragma mark - String & Enum Converter
- (NSString *)FSEnvironmentTypeToStringKey:(FSEnvironmentType)type{
    NSString *string = @"Unknow EnvironmentType";
    switch (type) {
        case FSEnvironmentTypeDevelop:
            string =  @"DeveloperEnvironment";
            break;
        case FSEnvironmentTypeTest1:
            string = @"Test1Environment";
            break;
        case FSEnvironmentTypeTest2:
            string = @"Test2Environment";
            break;
        case FSEnvironmentTypeOnline:
            string = @"OnlineEnvironment";
            break;
        case FSEnvironmentTypePreRelease:
            string = @"PreReleaseEnvironment";
            break;
        default:
            //Error
            string = @"Unknow EnvironmentType";
            break;
    }
    return string;
}

- (FSEnvironmentType)StringKeyToFSEnvironmentType:(NSString *)string{
    if ([string isEqualToString:@"DeveloperEnvironment"]) {
        return FSEnvironmentTypeDevelop;
    } else if ([string isEqualToString:@"Test1Environment"]){
        return FSEnvironmentTypeTest1;
    } else if ([string isEqualToString:@"Test2Environment"]){
        return FSEnvironmentTypeTest2;
    } else if ([string isEqualToString:@"OnlineEnvironment"]){
        return FSEnvironmentTypeOnline;
    } else if ([string isEqualToString:@"PreReleaseEnvironment"]){
        return FSEnvironmentTypePreRelease;
    } else {
        //Error
        return -1;
    }
}

- (NSString *)FSURLTypeToStringKey:(FSURLType)type{
    NSString *string = @"Unknow URLType";
    switch (type) {
        case FSURLTypeMainDomain:
            string = @"DomainURL";
            break;
        case FSURLTypeFinance:
            string = @"RPCURL";
            break;
        case FSURLTypeServiceWindow:
            string = @"ServiceWindowURL";
            break;
        case FSURLTypeMsgCenter:
            string = @"MsgCenterURL";
            break;
        case FSURLTypeForgetPwd:
            string = @"ForgetPwdURL";
            break;
        case FSURLTypeCookieDomain:
            string = @"CookieDomain";
            break;
        case FSURLTypeStock:
            string = @"StockURL";
            break;
        case FSURLTypeLotusseedKey:
            string = @"LotussedKey";
            break;
        case FSURLTypeMemberCenter:
            string = @"MemberCenter";
            break;
        default:
            string = @"Unknow URLType";
            break;
    }
    return string;
}

@end
