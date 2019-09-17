//
//  FSFloatWindowHandler.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/5/28.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSFloatWindowHandler.h"
#import "FSFloatWindowViewModel.h"
#import "FSiRateDelegate.h"
#import "AppDelegate.h"
#import "FSStringUtils.h"
#import "FSPopupUtils.h"
#import "LRHistoryUserManager.h"

@interface FSFloatWindowHandler()

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) FSFloatWindowViewModel  *floatWindowViewModel;
@property (nonatomic, assign) BOOL isDidLoad;

@end

@implementation FSFloatWindowHandler

- (instancetype)initWithViewController:(UIViewController *)viewController;
{
    self = [super init];
    if(self)
    {
        _viewController = viewController;
        [self bindCommand];
        
        _isDidLoad = YES;
        
        if (![self openedGestureLock]) {
            [self requestPopupData];
        }
        
        [self initListenEvents];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initListenEvents
{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"kGestureUnlockSuccessNotification" object:nil] subscribeNext:^(NSNotification *notification) {
        [self requestPopupData];
        
    }];
}



- (void)bindCommand
{
    @weakify(self);
    
    if(!self.viewController)
    {
        return;
    }
    
    RACSignal *didAppearSignal      = [self.viewController rac_signalForSelector:@selector(viewDidAppear:)];
    RACSignal *willDisappearSignal  = [self.viewController rac_signalForSelector:@selector(viewWillDisappear:)];
    
    RACSignal *canceliRateSignal = [RACSignal merge:@[willDisappearSignal,self.floatWindowViewModel.showPopupWindowCmd.executionSignals.switchToLatest]];
    
    
    [didAppearSignal subscribeNext:^(id x) {
       
        [self requestPopupDataWhenViewDidLoad];
        
    }];
    
    // 停留三秒后弹出好评弹窗
    NSTimeInterval rateDelayTime = 3;
    [[[didAppearSignal delay:rateDelayTime] takeUntil:canceliRateSignal] subscribeNext:^(id x) {
        [[FSiRateDelegate shareInstance] promptForRating];
    }];
    
    
    [[self.floatWindowViewModel.showPopupWindowCmd.executionSignals switchToLatest] subscribeNext:^(RACTuple *tupleValue) {
        NSString *linkUrl  = tupleValue.first;
        NSString *imageUrl = tupleValue.second;
        NSString *scenario     = tupleValue.third;
        
        NSString *eventId;
        if(tupleValue.fourth)
        {
            eventId = [NSString stringWithFormat:@"%@", tupleValue.fourth];
        }
        else
        {
            eventId = @"";
        }
        
        if (![self containGestureLock]) {
            
            
            NSDictionary *attributes = @{@"lc_banner_id": eventId ?: @"",
                                         @"lc_name":@"",
                                         @"lc_banner_url":imageUrl ?: @"",
                                         @"lc_jump_url":linkUrl ?: @""
                                         };

            [UserAction skylineEvent:@"finance_wcb_homepopup_enter_page" attributes:attributes];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[FSPopupUtils sharedInstance] showImageUrl:imageUrl
                                                    linkUrl:linkUrl
                                                    eventId:eventId
                                                 clickBlock:^{
                                                     
                                                     [UserAction skylineEvent:@"finance_wcb_homepopup_banner_click" attributes:attributes];
                                                     
                                                     
                                                 }
                                                 closeBlock:^{
                                                     
                                                     [UserAction skylineEvent:@"finance_wcb_homepopup_shutdown_click" attributes:attributes];
                                                 }];
            });
            
        }
        
    }];
    
}

- (void)requestPopupDataWhenViewDidLoad
{
    if(!_isDidLoad)
    {
        [self requestPopupData];
    }
    _isDidLoad = NO;
}

// 弹窗
- (void)requestPopupData{
    
    NSArray *hsitoryUsers = [LRHistoryUserManager historyUsers];
    self.floatWindowViewModel.userNeverLogin = ([hsitoryUsers count] == 0);
    self.floatWindowViewModel.userLoggedIn = [USER_INFO.token length] > 0;
    [self.floatWindowViewModel.showPopupWindowCmd execute:nil];
}


- (BOOL)openedGestureLock{
    
    NSString *savedPassword = [[NSUserDefaults standardUserDefaults] objectForKey:[FSStringUtils getPasswordKey]];
    
    return [savedPassword CM_isValidString];
}
- (BOOL)containGestureLock{
    __block BOOL isExist  = NO;
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appdelegate.fs_navgationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *viewController = (UIViewController *)obj;
        if ([viewController isKindOfClass:[FSGestureLockViewController class]]) {
            isExist = YES;
            *stop = YES;
        }
    }];
    
    
    return isExist;
}

- (FSFloatWindowViewModel *)floatWindowViewModel{
    if (!_floatWindowViewModel) {
        _floatWindowViewModel = [[FSFloatWindowViewModel alloc] init];
    }
    return _floatWindowViewModel;
}

@end
