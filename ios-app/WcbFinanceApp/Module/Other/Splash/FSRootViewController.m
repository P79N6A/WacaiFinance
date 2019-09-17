//
//  SplashViewController.m
//  FinanceApp
//
//  Created by 叶帆 on 10/9/15.
//  Copyright © 2015 com.wacai.licai. All rights reserved.
//

#import "FSRootViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "FSTabbarData.h"
#import "FSRequestInterface.h"
#import "FSStringUtils.h"
#import "FSTabbar.h"

#import "EGOCache.h"
#import "FSTabbarController.h"
//#import "FSHomeViewController.h"
#import "FSPageController.h"
#import "FSAssetViewController.h"
#import "FSDiscoveryViewController.h"
#import "FSFloatWindowViewModel.h"
#import "FSFloatWindowHandler.h"
#import <SdkFinanceHome/FSSDKHomeViewController.h>
#import "FSDiscoveryBadgeViewModel.h"
#import <NeutronBridge/NeutronBridge.h>
#import <NativeQS/NQSParser.h>

#define kTableTypeListCache    @"TableTypeListCache"

static NSString *const kFSDiscoverNewsSwitch = @"FSDiscoverNewsSwitch";

@interface FSRootViewController ()

@property (assign, nonatomic)BOOL canCloseMyself;
@property (strong, nonatomic)UIImageView *adImageView;
@property (strong, nonatomic)UIButton *adImageButton;
@property (strong, nonatomic)UIImageView *backgroundView;

@property (nonatomic, strong) FSFloatWindowHandler *floatWindowHandler;
@property (nonatomic, strong) FSDiscoveryBadgeViewModel *badgeViewModel;

@end

@implementation FSRootViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupRootViewController];
    
    [self bindViewModel];
    [self.badgeViewModel requestBadgeCount];
    
    [self initListenEvents];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initListenEvents
{
    //SdkFinanceHome
    extern NSString *FSSDKHomeFindMoreFinanceProductNotification;
    extern NSString *FSSDKHomeFindMoreFundNotification;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNotifyMoreProduct:) name:FSSDKHomeFindMoreFinanceProductNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNotifyMoreFund:) name:FSSDKHomeFindMoreFundNotification
                                               object:nil];
    
}

- (void)onNotifyMoreProduct:(NSNotification *)notification
{
    UIViewController *viewCtrl = [self.viewControllers fs_objectAtIndex:1];
    if ([viewCtrl isKindOfClass:[FSPageController class]])
    {
        [self setSelectedIndex:1];
        FSPageController *pageController = (FSPageController*)viewCtrl;
        pageController.selectIndex = 0;
    }
}

- (void)onNotifyMoreFund:(NSNotification *)notification
{
    UIViewController *viewCtrl = [self.viewControllers fs_objectAtIndex:1];
    if ([viewCtrl isKindOfClass:[FSPageController class]])
    {
        [self setSelectedIndex:1];
        FSPageController *pageController = (FSPageController*)viewCtrl;
        pageController.selectIndex = 1;
    }
}

- (void)bindViewModel
{
    @weakify(self);
    
    [[[[RACObserve(self.badgeViewModel, unreadCount) filter:^BOOL(NSNumber *count) {
        @strongify(self);
        BOOL isCountExist = count;
        NSNumber *isNotificationOn = [[NSUserDefaults standardUserDefaults] objectForKey:kFSDiscoverNewsSwitch];
        BOOL switchState = (isNotificationOn != nil) ? [isNotificationOn boolValue] : YES;
        return isCountExist && switchState;
    }] distinctUntilChanged] deliverOnMainThread] subscribeNext:^(NSNumber *count) {
        @strongify(self);
        NSString *badgeValue = count.integerValue == 0 ? nil : count.stringValue;
        self.viewControllers.lastObject.tabBarItem.badgeValue = badgeValue;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}


- (NSMutableArray *)tabbarArray{
    
    NSDictionary *responseDic =  (NSDictionary *)[FSNetworkCache cacheForURL:fs_tabbar parameters:@{@"area":@"appBottom"}];
    
    NSArray *responseArray = [responseDic fs_objectMaybeNilForKey:@"classifies"];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary *dic in  responseArray) {
        FSTabbarData *tabbarData = [FSTabbarData modelObjectWithDictionary:dic];
        [resultArray addObject:tabbarData];
    }
    
    return resultArray;
}

- (void)setupRootViewController{
    
    self.itemTitleColor = [UIColor colorWithHexString:@"#999999"];
    self.selectedItemTitleColor = [UIColor colorWithHexString:@"#d84a3f"];
    
    @weakify(self)
    NSDictionary *parameters = @{};
    NSString *source = [NSString stringWithFormat:@"%@?%@", @"nt://sdk-finance-home/get-home-v2", [NQSParser queryStringifyObject:parameters]];
    NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:self];
    [ns pageForNtWithSource:source
                     onDone:^(UIViewController *vc) {
                         UIViewController *home = vc;
                         NSAssert(home != nil, @"Home should not be nil");
                         @strongify(self)
                         //从首页中抽离出逻辑
                         self.floatWindowHandler = [[FSFloatWindowHandler alloc] initWithViewController:home];
                         
                         [self setupController:home
                                         title:@"精品推荐"
                                   normalImage:@"tab_recommend_normal"
                                   selectImage:@"tab_recommend_selected"];
                         
                         FSPageController *page   = [[FSPageController alloc] init];
                         [self setupController:page
                                         title:@"理财产品"
                                   normalImage:@"tab_list_normal"
                                   selectImage:@"tab_list_selected"];
                         
                         
                         FSAssetViewController *asset = [[FSAssetViewController alloc] init];
                         [self setupController:asset
                                         title:@"我的资产"
                                   normalImage:@"tab_asset_normal"
                                   selectImage:@"tab_asset_selected"];
                         
                         
                         FSDiscoveryViewController *discovery = [[FSDiscoveryViewController alloc] init];
                         
                         [self setupController:discovery
                                         title:@"发现"
                                   normalImage:@"tab_discover_normal"
                                   selectImage:@"tab_discover_selected"];
                         
                         NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:0];
                         
                         [viewControllers addObject:home];
                         [viewControllers addObject:page];
                         [viewControllers addObject:asset];
                         [viewControllers addObject:discovery];
                         
                         self.viewControllers = viewControllers;
                         
                         
                         NSArray *tabbarArray = [self tabbarArray];
                         
                         if ([tabbarArray count] == 4) {
                             self.tabbarDataArray = tabbarArray;
                         }
                         
                         
                         [[FSRequestManager manager] getRequestURL:fs_tabbar
                                                        parameters:@{@"area":@"appBottom"}
                                                           success:^(FSResponseData *response, id responseDic) {
                                                               
                                                               NSArray *responseArray = [responseDic fs_objectMaybeNilForKey:@"classifies"];
                                                               NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
                                                               
                                                               for (NSDictionary *dic in  responseArray) {
                                                                   FSTabbarData *tabbarData = [FSTabbarData modelObjectWithDictionary:dic];
                                                                   [resultArray fs_addObject:tabbarData];
                                                               }
                                                               self.tabbarDataArray = resultArray;
                                                               
                                                           } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                               
                                                           }];
                     } onError:^(NSError * _Nullable error) {
                         
                     }];
    
}
- (void)setupController:(UIViewController *)controller
                  title:(NSString *)title
            normalImage:(NSString *)normalName
            selectImage:(NSString *)selectImage{
    
    controller.title = title;
    
    controller.tabBarItem.image = [[UIImage imageNamed:normalName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}



- (FSDiscoveryBadgeViewModel *)badgeViewModel {
    if (!_badgeViewModel) {
        _badgeViewModel = [[FSDiscoveryBadgeViewModel alloc] init];
    }
    return _badgeViewModel;
}

@end
