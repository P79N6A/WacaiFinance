//
//  FSLoginManager.m
//  FinanceApp
//
//  Created by Alex on 5/5/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSLoginManager.h"
#import "FSOriginalLoginViewController.h"
#import "FSWacaiLoginViewController.h"
#import <NeutronBridge/NeutronBridge.h>

@interface FSLoginManager ()

@property (nonatomic, copy) CompletionBlock p_successBlock;
@property (nonatomic, copy) CancelBlock p_cancelBlock;


@end

@implementation FSLoginManager

+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    static FSLoginManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDidFinish:) name:FSLoginDidFinishNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDidCancel:) name:FSLoginCancelNotification object:nil];
    }
    
    return self;
}

- (UINavigationController *)loginViewControllerSuccess:(CompletionBlock)successBlock cancel:(CancelBlock)cancelBlock comeFrom:(NSString *)comFrom;
{
    UIViewController *loginViewController = [self loginViewController:successBlock cancel:cancelBlock comeFrom:comFrom];
    
    UINavigationController *navitgationViewController = [[UINavigationController alloc]
                                   initWithRootViewController:loginViewController];

    return navitgationViewController;
}



- (UIViewController *)loginViewController:(CompletionBlock)successBlock cancel:(CancelBlock)cancelBlock comeFrom:(NSString *)comeFrom
{
    UIViewController *viewController = [[self class] appropriateLoginViewController:comeFrom];
    //FSOriginalLoginViewController *loginViewController = [[FSOriginalLoginViewController alloc] init];
    // 如果 successBlock ＝ nil 也同样赋值，防止登录成功后执行上一次的 successBlock
    self.p_successBlock = successBlock;
    self.p_cancelBlock = cancelBlock;

    return viewController;
}

- (void)loginDidFinish:(id)sender
{
    if (self.p_successBlock) {
        self.p_successBlock();
        self.p_successBlock = nil;
    }
}


- (void)loginDidCancel:(id)sender
{
    if (self.p_cancelBlock) {
        self.p_cancelBlock();
        self.p_cancelBlock = nil;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (UIViewController *)appropriateLoginViewController:(NSString *)comeFrom
{
    NSString *lastLoginAccount = [[NSUserDefaults standardUserDefaults] objectForKey:@"kWacaibaoLastLoginAccount"];
    
    UIViewController *viewController;
    if(lastLoginAccount)
    {
        FSWacaiLoginViewController *loginViewController = [[FSWacaiLoginViewController alloc] initWithLoginPhone:nil closeType:FSLoginViewCloseTypeDismiss needEdit:YES];
        loginViewController.comeFrom = comeFrom;
        
        viewController = loginViewController;
    }
    else
    {
        FSOriginalLoginViewController *originViewController = [[FSOriginalLoginViewController alloc] init];
        originViewController.comeFrom = comeFrom;
        
        viewController = originViewController;
    }
    
    return viewController;
}

+ (UIViewController *)ntLoginViewController
{
    FSWacaiLoginViewController *viewController = [[FSWacaiLoginViewController alloc] initWithLoginPhone:nil closeType:FSLoginViewCloseTypePop needEdit:YES];
    viewController.comeFrom = @"others";
    
    return viewController;
}


@end
