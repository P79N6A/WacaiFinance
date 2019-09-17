//
//  FSWelcomeSlidesViewController.m
//  FinanceApp
//
//  Created by 叶帆 on 27/09/2016.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSWelcomeSlidesViewController.h"
#import "FSStringUtils.h"
#import "AppDelegate.h"
#import "FSRootViewController.h"
#import "FSTouchIDHelper.h"
#import "FSWelcomeSlidesView.h"


//每个版本发布前请确认图片资源与数量
static const NSInteger kNumberOfSlides = 3;

@interface FSWelcomeSlidesViewController ()

@property (strong, nonatomic)UIPageControl *pageControl;
@property (strong, nonatomic)UIButton *skipButton;

@end

@implementation FSWelcomeSlidesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self)weakSelf = self;
    FSWelcomeSlidesView *slidesView = [FSWelcomeSlidesView viewWithSlidesNumber:kNumberOfSlides dismissBlock:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf dismissAndVerify];
    }];
    [self.view addSubview:slidesView];
    [slidesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - helper
+ (BOOL)shouldShow {
    
    if (USER_INFO.isLogged) {
        [self markShowed];
        return NO;
    }
    //如果图片数为0，说明该版本没有启动引导图
 
    if (kNumberOfSlides <= 0) {
        return NO;
    }
    
    //是否展示过
    if ([FSWelcomeSlidesViewController hasShowed]) {
        return NO;
    }
    return YES;
}

+ (BOOL)hasShowed {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:[FSStringUtils getWelcomeSlidesVersionKey]]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)markShowed {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:[FSStringUtils getWelcomeSlidesVersionKey]];
}

- (void)dismissAndVerify {
    [FSWelcomeSlidesViewController markShowed];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FSRootViewController *root = [FSRootViewController new];
    appDelegate.fs_navgationController = [[UINavigationController alloc] initWithRootViewController:root];
    appDelegate.window.rootViewController = appDelegate.fs_navgationController;
    [appDelegate showGestureLockIfShould];
//    [FSTouchIDHelper verifyTouchIDIfAppAvailableWithSuccessAction:^{
//        [appDelegate dismiss];
//    }];
}

@end
