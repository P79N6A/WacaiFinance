//
//  FSAccountInfoViewModel.m
//  FinanceApp
//
//  Created by 叶帆 on 16/03/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSAccountInfoViewModel.h"
#import <LoginRegisterSDK+PersonalCenter.h>
#import <LRRequestFactory.h>
#import <NeutronBridge/NeutronBridge.h>
#import <CMUIViewController/UIViewController+CMUtil.h>
#import <NativeQS/NQSParser.h>
#import <CMNSString/NSString+CMUtil.h>

@implementation FSAccountInfoViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        @weakify(self);
        RACSignal *userAvatarRequest = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            [LoginRegisterSDK asyncGetAvatar:^(UIImage * _Nullable image) {
                if (image) {
                    [subscriber sendNext:image];
                }
            } placeHolder:self.userAvatar];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }] take:2] takeUntil:self.rac_willDeallocSignal];
        
        RACSignal *userInfoRequest = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            [subscriber sendNext:self.userNickname];
            
            NSString *source = [NSString stringWithFormat:@"%@", @"nt://sdk-user/fetchCurrentUserModel"];
            UIViewController * fromVC = [UIViewController CM_curViewController];
            NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:fromVC];
            [ns ntWithSource:source
          fromViewController:fromVC
                  transiaion:NTBViewControllerTransitionPush
                      onDone:^(NSString * _Nullable result) {
                          NSDictionary * info = [result CM_JsonStringToDictionary];
                          if([info[@"status"] isEqualToString:@"success"])
                          {
                              [subscriber sendNext:[info fs_objectMaybeNilForKey:@"nickName"]];
                              [subscriber sendCompleted];
                          }
                          else
                          {
                              NSError *error = [NSError errorWithDomain:@"sdk-user" code:-1 userInfo:nil];
                              [subscriber sendError:error];
                          }
                      } onError:^(NSError * _Nullable error) {
                          [subscriber sendError:error];
                      }];
            
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
        
        RACSignal *allRequestDone = [[RACSignal combineLatest:@[userAvatarRequest, userInfoRequest]
                                                      reduce:^id(UIImage *avatar, NSString *nickName){
                                                          return RACTuplePack(avatar, nickName);
                                                      }] doNext:^(RACTuple *tuple) {
                                                          USER_INFO.userAvator = [tuple first];
                                                          USER_INFO.mNickName = [tuple second];
                                                          [USER_INFO save];
                                                      }];
        self.requestCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return allRequestDone;
        }];
        
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

#pragma mark - getter & setter
- (UIImage *)userAvatar {
    if (!_userAvatar) {
        if (!USER_INFO.userAvator) {
            //默认头像
            _userAvatar = [UIImage imageNamed:@"default_profile"];
        } else {
            _userAvatar = USER_INFO.userAvator;
        }
    }
    return _userAvatar;
}

- (NSString *)userNickname {
    if (!_userNickname) {
        if (!USER_INFO.mNickName || [USER_INFO.mNickName isEqualToString:@""]) {
            _userNickname = @"";
        } else {
            _userNickname = USER_INFO.mNickName;
        }
    }
    return _userNickname;
}

- (NSString *)userAccount {
    return USER_INFO.mUserAccount;
}

@end
