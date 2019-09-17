//
//  FSPageController.m
//  FinanceApp
//
//  Created by xingyong on 3/4/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSPageController.h"
#import "FSProductTabData.h"
#import "FSStringUtils.h"
#import <React/RCTImageView.h>
#import <Neutron/Neutron.h>
#import "CMCommon.h"
#import <NeutronBridge/NeutronBridge.h>
#import <Planck/TPKWebViewController.h>
#import "EnvironmentInfo.h"

#import <SdkFinanceShelf/FSAppProductListViewController.h>

@interface FSPageController ()<WMMenuViewDataSource, WMMenuViewDelegate>

@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic) BOOL isReload;
@property(nonatomic, strong) UIViewController *financeShelfViewController;
@property(nonatomic, strong) UIViewController *fundShelfViewController;

@end

@implementation FSPageController

- (instancetype)init {
    if (self = [super init]) {
 
        self.menuViewStyle = WMMenuViewStyleLine;
  
        self.titleColorSelected = [UIColor whiteColor];
        self.titleColorNormal   = [UIColor colorWithWhite:1 alpha:0.5];
        self.titleSizeNormal    = 16;
        self.titleSizeSelected  = 16;
        self.progressWidth      = 40;
        self.menuItemWidth      = 80;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.bounces = YES;
        self.titles = @[@"理财"];
        self.selectIndex = 0;
        self.pageAnimatable = YES;
        self.showOnNavigationBar = NO;
    }
    return self;
}


- (void)fundShelfVCFromNeutronWithVCBlock:(void(^)(UIViewController * _Nullable))result {
    NSString *fundShelfSource = [NSString stringWithFormat:@"%@", @"nt://sdk-fund-wax/fund-shelf?wacaiClientNav=0"];
    NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:self];
    [ns pageForNtWithSource:fundShelfSource
                     onDone:^(UIViewController *vc) {
                         UIViewController * container = [self discardStatusBar:vc];
                         result(container);
                     } onError:^(NSError * _Nullable error) {
                         
                     }];
}

- (void)financeShelfVCFromNeutronWithVCBlock:(void(^)(UIViewController * _Nullable))result {
    NSString *financeShelfSource = [NSString stringWithFormat:@"%@", @"nt://sdk-finance-shelf/app_shelf"];
    NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:self];
    [ns pageForNtWithSource:financeShelfSource
                     onDone:^(UIViewController *vc) {
                         result(vc);
                     } onError:^(NSError * _Nullable error) {
                         
                     }];
}

- (UIViewController *)discardStatusBar:(UIViewController *)vc {
    UIViewController *tmp = vc ?: [UIViewController new];
    
    UIViewController *container = [[UIViewController alloc] init];
    container.view.bounds = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    tmp.view.frame = CGRectMake(0, -FS_StatusBarHeight, ScreenWidth, ScreenHeight - FS_NavigationBarHeight + FS_StatusBarHeight - FS_TabbarHeight);
    tmp.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    [container addChildViewController:tmp];
    [container.view addSubview:tmp.view];
    
    [tmp didMoveToParentViewController:container];
    
    return container;
}

- (void)viewDidLoad {
 
    [super viewDidLoad];
    self.menuView.scrollView.backgroundColor = [UIColor colorWithHex:0xd84a3f];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, FS_NavigationBarHeight)];
    topView.backgroundColor = [UIColor colorWithHex:0xd84a3f];
    [self.view addSubview:topView];
    
    self.titles = @[@"理财"];
    self.dataArray = [NSMutableArray array];
    
    @weakify(self)
    [self financeShelfVCFromNeutronWithVCBlock:^(UIViewController * _Nullable result) {
        @strongify(self)
        self.financeShelfViewController = result;
    }];
    [self fundShelfVCFromNeutronWithVCBlock:^(UIViewController * _Nullable result) {
        @strongify(self)
        self.fundShelfViewController = result;
    }];
    
    [self requestTabData];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
 
    if ([self.dataArray count] == 0 && self.isReload) {
        [self requestTabData];
    }
    else{
        if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
            [self sendRequest:NO];
         }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark --------- 请求tab数据 ---------

- (void)requestTabData{
    
    NSDictionary *responseDic = [FSNetworkCache cacheForURL:fs_productTab parameters:nil];
    if (responseDic) {

        [self parseResponseDic:responseDic];
        [self sendRequest:NO];
    }
    else
    {
        [self sendRequest:YES];
    }
    
    
}
- (void)sendRequest:(BOOL)isRefresh{
    
    [[FSRequestManager manager] getRequestURL:fs_productTab
                                   parameters:nil
                                      success:^(FSResponseData *response, id responseDic) {
                             if(response.isSuccess){
                                 self.isReload = NO;
                                 if (isRefresh) {
                                     [self parseResponseDic:responseDic];
                                 }
                                 
                             }
                             
                         } failure:^(NSURLSessionDataTask *task, NSError *error) {
                             self.isReload = YES;
                             
                             NSDictionary *responseDic = [FSNetworkCache cacheForURL:fs_productTab
                                                                          parameters:nil];
                             [self parseResponseDic:responseDic];
                         }];
    
}

- (void)parseResponseDic:(NSDictionary *)responseDic{
    
    NSMutableArray *segmentArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *responseArray = [responseDic fs_objectMaybeNilForKey:@"classifies" ofClass:[NSArray class]];
    [responseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        FSProductTabData *segmentData = [FSProductTabData modelObjectWithDictionary:dic];
        [segmentArray addObject:segmentData.mtabName];
        [self.dataArray addObject:segmentData];
       
    }];
    
    if([segmentArray count]){
        self.titles = segmentArray;
    }
    [self reloadData];


}
- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    
    NSInteger index = [[info fs_objectMaybeNilForKey:@"index"] integerValue] ;
    FSProductTabData *tabData = [self.dataArray fs_objectAtIndex:index];
    
    [UserAction skylineEvent:@"finance_wcb_shelf_toptab_click" attributes:@{@"lc_tab" : [NSString stringWithFormat:@"%@",tabData.mtabId] ?: @""}];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}



#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    
    return [self.titles count];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    FSProductTabData *tabData = [self.dataArray fs_objectAtIndex:index];
    NSInteger tabID = [tabData.mtabId integerValue];
    UIViewController *viewController = nil;
 
    if (tabID == 1) {
        viewController = self.financeShelfViewController;
    } else if (tabID == 2) {
        viewController = self.fundShelfViewController;
    }else if (tabID == 4) {
        viewController = [self treasureViewController];
    }

    return viewController ?: [UIViewController new];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    FSProductTabData *tabData = [self.dataArray fs_objectAtIndex:index];
 
    return tabData.mtabName;
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, FS_StatusBarHeight, ScreenWidth, 44.);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    
    return CGRectMake(0, FS_NavigationBarHeight, ScreenWidth, ScreenHeight - FS_NavigationBarHeight);
}

- (NSString *)treasureURL {
    FSEnvironmentType currentEnv = [[EnvironmentInfo sharedInstance] currentEnvironment];
    switch (currentEnv) {
        case FSEnvironmentTypeTest1:
            return @"http://www.fund-h51.k2.test.wacai.info/pe-account/home?wacaiclientnav=0";
            break;
        case FSEnvironmentTypeTest2:
            return @"http://www.fund-h52.k2.test.wacai.info/pe-account/home?wacaiclientnav=0";
            break;
        default:
            return @"https://fund.wacai.com/pe-account/home?wacaiclientnav=0";
            break;
    }
}

- (UIViewController *)treasureViewController {
    NSString *treasureURL = [self treasureURL];
    TPKWebViewController *webVC = [[TPKWebViewController alloc] initWithURLString:treasureURL];
    UIViewController *container = [[UIViewController alloc] init];
    container.view.bounds = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    webVC.view.frame = CGRectMake(0, -FS_StatusBarHeight, ScreenWidth, ScreenHeight - FS_NavigationBarHeight + FS_StatusBarHeight - FS_TabbarHeight);
    webVC.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    [container.view addSubview:webVC.view];
    [container addChildViewController:webVC];
    return container;
}


@end
