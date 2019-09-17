//
//  FSFloatWindowViewModel.m
//  FinanceApp
//
//  Created by Alex on 6/29/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSFloatWindowViewModel.h"
#import "FSRequestManager.h"
#import "UserInfo.h"
#import <CMNSDate/CMNSDate.h>
#import <i-Finance-library/FSEventStatisticsAction.h>

static NSString *const kLastPopupDate = @"kLastPopupDate";

@interface FSFloatWindowViewModel ()

@property (nonatomic, strong)NSString *keyWithWindowAndUserID;

@end


@implementation FSFloatWindowViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userRegister = NO;
        self.userNeverLogin = NO;
        self.userLoggedIn = NO;
        @weakify(self);
        self.showPopupWindowCmd = [[RACCommand alloc] initWithEnabled:[self shouldPopup] signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[self showPopupWindowSignal] doNext:^(RACTuple *tuple) {
                NSUInteger scenario = [tuple.third integerValue];
                BOOL isRegisterPopupWin = (scenario == FSPopupWindowScenarioRegister);
                if (!isRegisterPopupWin) {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastPopupDate];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
                BOOL isHadBuyPopupWin = (scenario == FSPopupWindowScenarioHadLoggedIn);
                if (isHadBuyPopupWin) {
                    NSString *keyWithWindowAndUserID = [NSString stringWithFormat:@"window%@hasPopedTo%@", tuple.last, [UserInfo sharedInstance].mUserId];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:keyWithWindowAndUserID];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }];
        }];
    }
    
    return self;
}

- (BOOL)hasTodayDayPopuped {
    //由于之前使用 rac_channelTerminalForKey: 产生的信号与莲子冲突产生 Crash，因此采用普通方法进行绕过
    //相关 issue - http://git.caimi-inc.com/client/i-app-finance/issues/30
    NSDate *lastPopupDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastPopupDate];
    if (lastPopupDate) {
        NSDate *currentDate = [NSDate date];
        NSInteger dayInterval = [currentDate CM_nominalDaysToDate:lastPopupDate];
        BOOL hasTodayPopuped = (dayInterval == 0);
        if (hasTodayPopuped) {
            // 上报由于时间频率控制的防骚扰未弹出，帮助分析弹出率过低的瓶颈
            [FSEventAction skylineEvent:@"finance_wcb_homepopup_time_action"];
        }
        return hasTodayPopuped;
    } else {
        return NO;
    }
}

- (RACSignal *)shouldPopup {

    RACSignal *shouldPopupUserRegister = RACObserve(self, userRegister);
    
    // 添加 userLoggedIn 的判断, 如果已经登录, 不会触发, 这样如果 userNeverLogin 在老用户升级的时候判断出问题, 也不会弹
    // 例如 [LRHistoryUserManager historyUsers] 升级用户可能为空, 这样会被误判成从未登录过的用户
    RACSignal *shouldPopWhenUserNeverLogin =
    [[RACSignal combineLatest:@[RACObserve(self, userLoggedIn),
                               RACObserve(self, userNeverLogin)]
                      reduce:^id(NSNumber *userLoggedIn, NSNumber *userNeverLogin){
                          return @(![userLoggedIn boolValue] && [userNeverLogin boolValue]);
                      }] map:^id(NSNumber *value) {
                          return @([value boolValue] && ![self hasTodayDayPopuped]);
                      }];
    
    
    RACSignal *shouldPopWhenUserLoggedIn = [RACObserve(self, userLoggedIn) map:^id(id value) {
        return @([value boolValue] && ![self hasTodayDayPopuped]);
    }];

    return [[[RACSignal combineLatest:@[shouldPopupUserRegister,
                                       shouldPopWhenUserNeverLogin,
                                       shouldPopWhenUserLoggedIn]
                              reduce:^id(NSNumber *userRegister, NSNumber *shouldPopWhenUserNeverLogin, NSNumber *shouldPopWhenUserLoggedIn){
        return RACTuplePack(userRegister, shouldPopWhenUserNeverLogin, shouldPopWhenUserLoggedIn);
    }] distinctUntilChanged] or];
}



- (RACSignal *)showPopupWindowSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSNumber *myScenario = @1;
        if (self.userRegister) {
            myScenario = @(FSPopupWindowScenarioRegister);
        } else if (self.userNeverLogin) {
            myScenario = @(FSPopupWindowScenarioNeverLogin);
        } else if (self.userLoggedIn) {
            myScenario = @(FSPopupWindowScenarioHadLoggedIn);
        }

        NSDictionary *parameters = @{@"scenario": myScenario};
        NSURLSessionDataTask *task =
        [[FSRequestManager manager] getRequestURL:fs_popupwins
                                       parameters:parameters
                                          success:^(FSResponseData *response, id responseDic) {
                                              if (response.isSuccess) {
                                                  NSArray *windowArray = [responseDic fs_objectMaybeNilForKey:@"list" ofClass:[NSArray class]];
                                                  
                                                  __block NSString *linkUrl = @"";
                                                  __block NSString *imageUrl = @"";
                                                  __block NSString *mScenario = [myScenario stringValue];
                                                  __block NSString *windowID = @"";
                                                  __block BOOL foundWindowToPop = NO;

                                                  [windowArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                      if ([obj isKindOfClass:[NSDictionary class]]) {
                                                          NSDictionary *windowDictionary = (NSDictionary *)obj;
                                                          linkUrl = windowDictionary[@"linkUrl"] ?: @"";
                                                          imageUrl = windowDictionary[@"imgUrl"] ?: @"";
                                                          mScenario = windowDictionary[@"scenario"] ?: [myScenario stringValue];
                                                          windowID = windowDictionary[@"id"] ?: @"";
                                                          
                                                          BOOL isImageURLVaild = [imageUrl length] > 0;
                                                          if (isImageURLVaild) {
                                                              NSString *windowStoreId = [NSString stringWithFormat:@"window%@hasPopedTo%@",windowID, [UserInfo sharedInstance].mUserId];
                                                              BOOL hasPopped = [[[NSUserDefaults standardUserDefaults] objectForKey:windowStoreId] boolValue];
                                                              if (hasPopped) {
                                                                  // 上报由于重复控制的防骚扰未弹出，帮助分析弹出率过低的瓶颈
                                                                  NSDictionary *params = @{@"lc_banner_id": windowID};
                                                                  [FSEventAction skylineEvent:@"finance_wcb_homepopup_duplicate_action" attributes:params];
                                                              } else {
                                                                  *stop = YES;
                                                                  foundWindowToPop = YES;
                                                                  
                                                                  // 上报由于优先级过低的未弹出，帮助分析弹出率过低的瓶颈
                                                                  NSInteger unpoppedCount = windowArray.count - (idx + 1);
                                                                  if (unpoppedCount > 0) {
                                                                      NSRange range = NSMakeRange(idx + 1, unpoppedCount);
                                                                      NSArray *unpoppedWindows = [windowArray fs_subarrayWithRange:range];
                                                                      //TODO 修改为逗号分隔
                                                                      NSString *ids = [self convertParams:unpoppedWindows];
                                                                      NSDictionary *params = @{@"lc_banner_id": ids};
                                                                      [FSEventAction skylineEvent:@"finance_wcb_homepopup_priority_action" attributes:params];
                                                                  }

                                                                  
                                                                  RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[linkUrl, imageUrl, mScenario, windowID]];
                                                                  [subscriber sendNext:tuple];
                                                                  [subscriber sendCompleted];
                                                              }
                                                          }
                                                      }
                                                  }];
                                                  
                                                  if (!foundWindowToPop) {
                                                      [subscriber sendError:nil];
                                                  }
                                                  
                                              }
                                              
                                          } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                              
                                              [subscriber sendError:nil];
                                              
                                          }];
  
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    
}

- (NSString *)convertParams:(NSArray *)unpoppedWindows {
    NSMutableString *unpoppedIDs = [NSMutableString string];
    [unpoppedWindows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *windowDic = (NSDictionary *)obj;
            long windowID = [windowDic CM_longFrom:@"id"];
            if (idx == 0) {
                [unpoppedIDs appendFormat:@"%@", @(windowID)];
            } else {
                [unpoppedIDs appendFormat:@",%@", @(windowID)];
            }
        }
    }];
    return [unpoppedIDs copy];
}

@end
