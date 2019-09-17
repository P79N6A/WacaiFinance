//
//  FSAccountSettingsHandler.m
//  WcbFinanceApp
//
//  Created by 叶帆 on 2018/10/16.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSAccountSettingsHandler.h"
#import "FSAppConfigRequest.h"
#import "FSUserStatusRequest.h"
#import <CMNSDictionary/CMNSDictionary.h>
#import <LoginRegisterSDK+PersonalCenter.h>
#import <NeutronBridge/NeutronBridge.h>
#import <CMNSDictionary/CMNSDictionary.h>
#import "FSAccountSettingsUserInfo.h"
#import "FSAccountSettingsUserStatus.h"
#import "FSAccountSettingsViewModelHandler.h"
#import "FSHiveConfigEvent.h"
#import <FSHiveConfig/FSHCManager.h>
#import "FSAccountSettingsModelList.h"
#import <CMUIViewController/UIViewController+CMUtil.h>
#import <NativeQS/NQSParser.h>
#import <CMNSString/NSString+CMUtil.h>

NSString *const kFSAccountSettingsNotificationListRefresh = @"kFSAccountSettingsNotificationListRefresh";
NSString *const kFSAccountSettingsNotificationLogout = @"kFSAccountSettingsNotificationLogout";

NSString *const kFSAccountSettingsConfigLoggedKey = @"accountSettings_logged";
NSString *const kFSAccountSettingsConfigUnloggedKey = @"accountSettings_unlogged";


@interface FSAccountSettingsHandler ()

@property (assign, nonatomic) BOOL isUserLogined;
@property (strong, nonatomic) NSDictionary *configDic;
@property (nonatomic, strong) FSAccountSettingsModelList * configModel;

@property (strong, nonatomic) FSAccountSettingsUserInfo *userInfo;
@property (strong, nonatomic) FSAccountSettingsUserStatus *userStatus;
@property (strong, nonatomic) FSAccountSettingsViewModelHandler *vmHandler;

@end

@implementation FSAccountSettingsHandler

- (NSArray *)localDataSource {
    id localSource = [HIVE_CONFIG localCacheOfKey:[self configKey] class:[FSAccountSettingsModelList class]];
    if ([localSource isMemberOfClass:[FSAccountSettingsModelList class]]) {
        FSAccountSettingsModelList * modelList = (FSAccountSettingsModelList *)localSource;
        self.configModel = modelList;
        return [self updateDataSource];
    }
    
    return [NSArray array];
}

- (NSArray *)updateDataSource {
    return [self.vmHandler buildPageViewModelWithConfig:self.configModel
                                               userInfo:self.userInfo
                                             userStatus:self.userStatus];
}


#pragma mark - Network Request
- (void)postRefreshNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kFSAccountSettingsNotificationListRefresh object:nil];
}

- (void)fetchPageConfig {
    NSString *configKey = [self configKey];
    
    [HIVE_CONFIG fetchKey:configKey class:[FSAccountSettingsModelList class] completion:^(BOOL isSuccess, id  _Nullable object) {
        if ([object isMemberOfClass:[FSAccountSettingsModelList class]]) {
            FSAccountSettingsModelList * modelList = (FSAccountSettingsModelList *)object;
            self.configModel = modelList;
            [self fetchUserStatusIfNeeded];
            [self postRefreshNotification];
        }
    }];
}

- (void)fetchUserInfoIfNeeded {
    if (!USER_INFO.isLogged) { return; }
    [self fetchAvatar];
    [self fetchNickname];
}

- (void)fetchAvatar {
    [LoginRegisterSDK asyncGetAvatar:^(UIImage * _Nullable image) {
        if (image) {
            self.userInfo.avatar = image;
            USER_INFO.userAvator = image;
            [self postRefreshNotification];
        }
    } placeHolder:self.userInfo.avatar];
}

- (void)fetchNickname {
    NSString *source = [NSString stringWithFormat:@"%@", @"nt://sdk-user/fetchCurrentUserModel"];
    
    UIViewController * fromVC = [UIViewController CM_curViewController];
    NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:fromVC];
    @weakify(self)
    [ns ntWithSource:source
  fromViewController:fromVC
          transiaion:NTBViewControllerTransitionPush
              onDone:^(NSString * _Nullable result) {
                  @strongify(self)
                  NSDictionary * info = [result CM_JsonStringToDictionary];
                  if([info[@"status"] isEqualToString:@"success"]) {
                      NSString *nickname = [info fs_objectMaybeNilForKey:@"nickName"];
                      self.userInfo.nickname = nickname;
                      USER_INFO.mNickName = nickname;
                      [self postRefreshNotification];
                  }
              } onError:^(NSError * _Nullable error) {
                  
              }];
    
}

- (void)fetchUserStatusIfNeeded {
    if (!USER_INFO.isLogged) { return; }
    FSUserStatusRequest *request = [[FSUserStatusRequest alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof CMBaseRequest * _Nonnull request) {
        NSDictionary *data = [request.responseJSONObject CM_dictionaryForKey:@"data"];
        self.userStatus = [[FSAccountSettingsUserStatus alloc] initWithData:data];
        [self postRefreshNotification];
    } failure:^(__kindof CMBaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark - setter & getter
- (NSString *)configKey {
    return USER_INFO.isLogged ? kFSAccountSettingsConfigLoggedKey : kFSAccountSettingsConfigUnloggedKey;
}

- (FSAccountSettingsUserInfo *)userInfo {
    if (!_userInfo) {
        _userInfo = [[FSAccountSettingsUserInfo alloc] init];
    }
    return _userInfo;
}

- (FSAccountSettingsUserStatus *)userStatus {
    if (!_userStatus) {
        _userStatus = [[FSAccountSettingsUserStatus alloc] init];
    }
    return _userStatus;
}

- (FSAccountSettingsViewModelHandler *)vmHandler {
    if (!_vmHandler) {
        _vmHandler = [[FSAccountSettingsViewModelHandler alloc] init];
    }
    return _vmHandler;
}



@end
