//
//  FSAssetViewController.m
//  FinanceApp
//
//  Created by xingyong on 5/30/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSAssetViewController.h"
#import <AFNetworking.h>
#import "FSPositionDetailViewController.h"
#import "FSAssetRefreshHeader.h"
#import "FSProductData.h"
#import "FSAssetListCell.h"
#import "FSTypeTitleCell.h"
#import "FSAssetLineCell.h"
#import "FSBalanceCell.h"
#import "FSSpaceCell.h"
#import "FSExpireCell.h"
#import "FSWelfareCell.h"
#import "FSNetworkCell.h"
#import "FSEmptyCell.h"
#import "FSNavHeaderView.h"
#import "FSAssetEntity.h"
#import "FSAssetViewModel.h"
#import "FSWelfareData.h"
#import "FSAnnouncementViewModel.h"
#import "FSAnnouncementCell.h"
#import "FSAnnounceNotification.h"
#import <i-Finance-Library/FSSDKGotoUtility.h>
#import "KLCPopup.h"
#import "FSAssetGuideView.h"
#import "FSAssetTopView.h"
#import "FSParallaxHeaderView.h"
#import "FSStringUtils.h"
#import "FSGuideManager.h"
#import <UIView+FSUtils.h>
#import "FSAssetExplanationViewModel.h"
#import "FSAssetViewController+NotificationReminder.h"
#import "FSAssetUserLevelViewModel.h"
#import "FSAssetGuideMaskView.h"
#import "FSAssetUserAssetView.h"
#import "FSMarketViewModel.h"
#import "FSMarketingData.h"
#import "FSActivityCell.h"
#import "EnvironmentInfo.h"
 

@interface FSAssetViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong ) FSAnnouncementViewModel *announcementViewModel;
@property (nonatomic,strong ) NSMutableArray          *dataSource;
@property (nonatomic,strong ) NSArray                 *assetArray;
@property (nonatomic,copy   ) NSString                *errorMessage;

@property (nonatomic,strong ) FSNavHeaderView         *navHeaderView;
@property (nonatomic,strong ) FSAssetViewModel        *assetViewModel;

@property (nonatomic, strong) FSAnnounceNotification  *notificationData;
@property (nonatomic, strong) FSParallaxHeaderView    *parallaxHeaderView;
@property (nonatomic, strong) FSAssetUserAssetView          *topView;
@property (nonatomic, strong) FSAssetExplanationViewModel *assetExplanationViewModel;
@property (nonatomic, strong) FSMarketViewModel  *marketViewModel;

@property (nonatomic, strong) FSAssetUserLevelViewModel *userInfoViewModel;
@property (nonatomic, strong) FSAssetGuideMaskView *guideMaskView;

@end

@implementation FSAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    self.assetArray = [NSArray array];
    
    [self setupSubView];
    [self bindViewModel];
    
    [self.assetExplanationViewModel.fetchAssetExplanationCommand execute:nil];
    [self popNotificationReminderIfNeeded];
}

- (void)setupSubView{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-FS_TabbarHeight);
        
    }];
    self.titleLabel.hidden = YES;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    _navHeaderView = [[FSNavHeaderView alloc] initWithFrame:CGRectMake(0, 0, width,FS_iPhoneX ? kHeaderHeight_X : kHeaderHeight)];
    __weak typeof(self) wself = self;
    _navHeaderView.buttonActionBlock = ^(FSHeaderButtonType type){
        if (type == FSHeaderButtonTypeHelp) {
            [wself showGuideView];
        }
        else if(type == FSHeaderButtonTypeUserInfo){
            
            [wself showMemberCenterAndStore];
        }
        else
        {
            [wself reloadDataSource];
        }
        
    };
    
    [self.view addSubview:_navHeaderView];
    
    _topView = [[FSAssetUserAssetView alloc] initWithFrame:CGRectMake(0., -FS_NavigationBarHeight, width, FS_NavigationBarHeight)];
    [self.view addSubview:_topView];
    
    
    _parallaxHeaderView = [FSParallaxHeaderView parallaxHeaderViewWithCGSize:CGSizeMake(self.view.bounds.size.width, FS_iPhoneX ? kHeaderHeight_X : kHeaderHeight)];
    _parallaxHeaderView.headerImage = [UIImage imageNamed:@"asset_header_bg"];
    // insert index = 1 盖在 navigationbar 上面
    [self.view insertSubview:_parallaxHeaderView atIndex:1];
    
    
    self.tableView.tableHeaderView = _navHeaderView;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [FSAssetRefreshHeader headerWithRefreshingBlock:^{
        
        [weakSelf.assetViewModel.assetCommand execute:nil];
        
    }];
}

#pragma mark - 阴影提示
- (void)showGuideMaskView
{
    BOOL shouldShow = [FSAssetGuideMaskView maskViewShouldShow];
    if(shouldShow)
    {
        CGFloat top = [self.navHeaderView userInfoViewBottom];
        //inset
        top += 16;
        
        self.guideMaskView = [[FSAssetGuideMaskView alloc] initWithFrame:self.view.bounds arrowTop:top];
        
        [self.tabBarController.view addSubview:self.guideMaskView];
        [self.guideMaskView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.edges.equalTo(self.tabBarController.view);
        }];
    }
}

//调整距离
- (void)updateGuideMaskView
{
    if(self.guideMaskView)
    {
        CGRect frame = [self.navHeaderView userInfoViewFrame];
        //inset
        frame = CGRectInset(frame, -8,  -8);
        
        CGRect newFrame =  [self.navHeaderView convertRect:frame toView:self.guideMaskView];
        NSLog(@"new Frame is %@", NSStringFromCGRect(newFrame));
        [self.guideMaskView updateClipFrame:newFrame];
    }
}

- (void)removeGuideMaskView
{
    if(self.guideMaskView)
    {
        [self.guideMaskView removeFromSuperview];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = -scrollView.contentOffset.y;
    
    [_parallaxHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    
    if (offsetY < -154.) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.topView.top = 0;
        } completion:^(BOOL finished) {
            [self.topView hiddenMoney];
        }];
        
    }else{
        _topView.top = -FS_NavigationBarHeight;
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.errorMessage = @"";
    [UserAction skylineEvent:@"finance_wcb_myassets_enter_page"];
    
}

- (void)bindViewModel{
    
    @weakify(self);
    RACSignal *viewWillAppear = [self rac_signalForSelector:@selector(viewWillAppear:)];
    
    [[RACSignal
      merge:@[viewWillAppear]]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.announcementViewModel.announcementCommand execute:@(FSNotificationAreaMyAsset)];
         [self.assetViewModel.assetCommand execute:nil];
         [self.marketViewModel.marketCommand execute:@(FSMarketTypeAsset)];
         [self.userInfoViewModel.userLevelCommand execute:nil];
     }];
    
    // 持仓列表
    [[RACObserve(self.assetViewModel, dataArray) ignore:nil]
     subscribeNext:^(NSArray *assetArray) {
         @strongify(self);
         [self.tableView.mj_header endRefreshing];
         self.assetArray = assetArray;
         
         FSProductData *firstData   = [self.assetArray fs_objectAtIndex:0];
         self.navHeaderView.productData = firstData;
         self.topView.productData       = firstData;
         
         if ([firstData.mtext1 doubleValue]) {
             [self firstLaunch];
         }
         
         [self reloadDataSource];
         
     }];
    
    [RACObserve(self.assetViewModel,errorMsg)
     subscribeNext:^(NSString *errorMsg) {
         @strongify(self);
         self.errorMessage = errorMsg;
         [self reloadDataSource];
     }];
    
    [RACObserve(self.marketViewModel, marketData)
     subscribeNext:^(id x) {
         @strongify(self);
         [self reloadDataSource];
     }];
    
    [self.assetViewModel.assetCommand.errors subscribeNext:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
    // 公告
    [[[RACObserve(self.announcementViewModel, annoiuncementData)
       ignore:nil]
      distinctUntilChanged]
     subscribeNext:^(id x) {
         @strongify(self);
         self.notificationData = x;
         [self reloadDataSource];
         
     }];
    
    [RACObserve(self.announcementViewModel, hideAnnoiuncement)
     subscribeNext:^(NSNumber *hide) {
         @strongify(self);
         if ([hide boolValue]) {
             self.notificationData = nil;
             [self reloadDataSource];
         }
     }];
    
    
    [self bindUserInfoViewModel];
}

- (void)bindUserInfoViewModel
{
    @weakify(self);
    RACSignal *userLevelInfoChanged = [RACObserve(self.userInfoViewModel, levelInfo) distinctUntilChanged];
    
    [[userLevelInfoChanged deliverOnMainThread] subscribeNext:^(FSUserLevelInfo *levelInfo) {
        @strongify(self);
        [self.navHeaderView updateUserLevelView:levelInfo];
        
    }];
}



- (void)registTableViewCell{
    
    NSArray *cellNameArray = @[@"FSTypeTitleCell",@"FSBalanceCell",@"FSSpaceCell",
                               @"FSAssetListCell",@"FSAssetLineCell",@"FSExpireCell",
                               @"FSWelfareCell",@"FSAnnouncementCell",@"FSNetworkCell",
                               @"FSEmptyCell",@"FSActivityCell"];
    
    [cellNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj isKindOfClass:[NSString class]]){
            [self.tableView registerClass:NSClassFromString(obj) forCellReuseIdentifier:obj];
        }
    }];
     
    
}
- (void)reloadDataSource{
    [self.dataSource removeAllObjects];
    
    NSMutableArray *lastArray = [NSMutableArray arrayWithCapacity:0];
    if ([self.errorMessage length]) {
        [self.dataSource addObject:[FSAssetEntity entityWithStyle:FSAssetCellStyleNetwork]];
        if([self.assetArray count] == 0){
            [self.dataSource addObject:[FSAssetEntity entityWithStyle:FSAssetCellStyleEmpty]];
        }
    }
    else{
        if (self.notificationData && ![FSAnnouncementCell hasManualClose:self.notificationData]) {
            [self.dataSource addObject:[FSAssetEntity entityWithStyle:FSAssetCellStyleAnouncement]];
        }
        
        if (self.marketViewModel.marketData) {
                
            [self.dataSource addObject:[FSAssetEntity entityWithStyle:FSAssetCellStyleActivity]];
            [self.dataSource addObject:[FSAssetEntity entityWithStyle:FSAssetCellStyleSpace]];
        
        }
    }
    
 
    
    NSMutableArray *assetMutableArray = [NSMutableArray arrayWithArray:self.assetArray];
    if ([assetMutableArray count]) {
        [assetMutableArray removeObjectAtIndex:0];
    }
    
    [assetMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        FSProductData *productData = (FSProductData *)obj;
        
        if ([productData.mclassifyName length]) {
            [self.dataSource addObject:[FSAssetEntity entityWithStyle:FSAssetCellStyleSpace]];
            [self.dataSource addObject:[FSAssetEntity entityWithStyle:FSAssetCellStyleTypeTitle productData:productData]];
            
        }else{
            if (![productData.mtype isEqualToString:@"4"]) {
                if (idx > 0) {
                    [self.dataSource addObject:[FSAssetEntity entityWithStyle:FSAssetCellStyleLine]];
                }
            }
            
        }
        
        if (idx == 0) {
            
            [self.dataSource addObject:[FSAssetEntity entityWithStyle:FSAssetCellStyleBalance productData:productData]];
            
        }else{
            
            if([productData.mtag2 length]){
                
                [self.dataSource addObject:[FSAssetEntity entityWithStyle:FSAssetCellStyleExpire productData:productData]];
            }else{
                if (![productData.mtype isEqualToString:@"4"]) {
                    [self.dataSource addObject:[FSAssetEntity entityWithStyle:FSAssetCellStyleList productData:productData]];
                    
                }
                else{
                    
                    [lastArray fs_addObject:productData];
                }
                
            }
        }
        
    }];
    
    
    NSInteger count = [lastArray count];
    NSInteger line = count%2 > 0 ? count/2+1 : count/2; //代表几行
    
    for (NSInteger index = 0; index<line ; index++) {
        FSWelfareData *welfare      = [[FSWelfareData alloc] init];
        FSProductData *leftProduct  = [lastArray fs_objectAtIndex:index*2];
        FSProductData *rightProduct = [lastArray fs_objectAtIndex:index*2 + 1];
        
        welfare.leftTitle        = leftProduct.mname;
        welfare.leftDetailTtitle = leftProduct.mtag1;
        welfare.leftIcon         = leftProduct.micon;
        welfare.leftUrl          = leftProduct.murl;
        welfare.leftEventId      = leftProduct.meventId;
        welfare.leftEventCode    = leftProduct.meventCode;
        
        welfare.rightTitle        = rightProduct.mname;
        welfare.rightDetailTtitle = rightProduct.mtag1;
        welfare.rightIcon         = rightProduct.micon;
        welfare.rightUrl          = rightProduct.murl;
        welfare.rightEventId      = rightProduct.meventId;
        welfare.rightEventCode    = rightProduct.meventCode;
        
        [self.dataSource fs_addObject:[FSAssetEntity entityWithStyle:FSAssetCellStyleWelfare welfareData:welfare]];
        
    }
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSAssetEntity *entity = [self.dataSource fs_objectAtIndex:indexPath.row];
    if (entity.style == FSAssetCellStyleList) {
        FSAssetListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSAssetListCell"];
        cell.productData = entity.productData;
        return cell;
    }else if (entity.style == FSAssetCellStyleTypeTitle){
        FSTypeTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSTypeTitleCell"];
        cell.typeTitle = entity.productData.mclassifyName;
        return cell;
    }else if (entity.style == FSAssetCellStyleLine || entity.style == FSAssetCellStyleLongLine){
        FSAssetLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSAssetLineCell"];
        if (entity.style == FSAssetCellStyleLongLine) {
            [cell setupLeftPadding:0.];
        } else {
            [cell setupLeftPadding:50.];
        }
        return cell;
    }else if (entity.style == FSAssetCellStyleBalance){
        FSBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSBalanceCell"];
        cell.productData = entity.productData;
        return cell;
    }else if (entity.style == FSAssetCellStyleSpace){
        FSSpaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSSpaceCell"];
        return cell;
    }else if (entity.style == FSAssetCellStyleExpire){
        FSExpireCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSExpireCell"];
        cell.productData = entity.productData;
        return cell;
    }else if (entity.style == FSAssetCellStyleWelfare){
        FSWelfareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSWelfareCell"];
        cell.welfareData = entity.welfareData;
        return cell;
    }else if(entity.style == FSAssetCellStyleAnouncement){
        FSAnnouncementCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"FSAnnouncementCell"];
        cell.announceData = self.notificationData;
        cell.skyLineEventName = @"finance_wcb_myassets_notice_click";
        __weak typeof(self) weakSelf = self;
        cell.announceButtonBlock = ^(void){
            
            [weakSelf.dataSource removeObject:entity];
            [tableView reloadData];
        };

        
        return cell;
    }else if (entity.style == FSAssetCellStyleNetwork){
        FSNetworkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSNetworkCell"];
        cell.errorMessage = self.errorMessage;
        return cell;
    }else if (entity.style == FSAssetCellStyleEmpty){
        
        FSEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSEmptyCell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.emptyImageView.image = [UIImage imageNamed:@"icon_unconnected"];
        cell.emptyLabel.text = @"网络异常，数据加载不出来，请稍后刷新试试";
        return cell;
    } else if (entity.style == FSAssetCellStyleActivity) {
        FSActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSActivityCell"];
        cell.detailText = self.marketViewModel.marketData.content;
        cell.buttonText = self.marketViewModel.marketData.contentSrc;
        
        cell.closeButtonBlock = ^{
            [self removeActivityCell];
        };
        return cell;
 
    }
    return nil;
}
// 移除活动位
- (void)removeActivityCell{
    
    NSString *lc_banner_id = [NSString stringWithFormat:@"%@", @(self.marketViewModel.marketData.ID)];
    
    [UserAction skylineEvent:@"finance_wcb_myassets_closedirectionalad_click" attributes:@{@"lc_banner_id":lc_banner_id}];
    
    [self.marketViewModel.marketUpCommand execute:@(self.marketViewModel.marketData.ID)];
    self.marketViewModel.marketData = nil;
    
    // 先判断是否有公告
    if (self.notificationData && ![FSAnnouncementCell hasManualClose:self.notificationData]) {
        [self.dataSource removeObjectAtIndex:1];//移除数据源的数据
    }else{
        [self.dataSource removeObjectAtIndex:0];//移除数据源的数据
    }
    [self reloadDataSource];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSAssetEntity *entity = [self.dataSource fs_objectAtIndex:indexPath.row];
    return entity.cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FSAssetEntity *entity = [self.dataSource fs_objectAtIndex:indexPath.row];
    
    if(entity.style == FSAssetCellStyleActivity){ //运营活动跳转
        
        NSString *lc_banner_id = [NSString stringWithFormat:@"%@", @(self.marketViewModel.marketData.ID)];
        
        [UserAction skylineEvent:@"finance_wcb_myassets_directionalad_click" attributes:@{@"lc_banner_id":lc_banner_id}];
        
        [FSSDKGotoUtility openURL:self.marketViewModel.marketData.contentHref from:self];
    }else{
        
        if (![entity.productData.murl CM_isValidString]){
            return;
        }
        
        NSString *eventCode = SafeString(entity.productData.meventCode);
        if ([eventCode CM_isValidString]) {
            [UserAction skylineEvent:eventCode];
        }
        
        [FSSDKGotoUtility openURL:entity.productData.murl from:self];
        
    }
}


#pragma mark - Actions
- (void)showGuideView{
    
    FSAssetGuideView *guideView = [[FSAssetGuideView alloc] initWithFrame:CGRectMake(30., 0., self.view.bounds.size.width - 60.,[UIScreen mainScreen].bounds.size.height)];
    guideView.contentArray = self.assetExplanationViewModel.contentArray;
    
    guideView.buttonGuideBlock = ^(UIButton *button){
        [button dismissPresentingPopup];
    };
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter,KLCPopupVerticalLayoutCenter);
    
    KLCPopup* popup = [KLCPopup popupWithContentView:guideView
                                            showType:KLCPopupShowTypeBounceIn
                                         dismissType:KLCPopupDismissTypeBounceOut
                                            maskType:KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:NO
                               dismissOnContentTouch:NO];
    
    [popup showWithLayout:layout];
    
}

- (void)showMemberCenterAndStore {

    NSString *memberCenterHost = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeMemberCenter];
    NSString *URLString = [NSString stringWithFormat:@"%@/member/index.html?need_login=1&need_zinfo=1", memberCenterHost];
    NSString *UTF8URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [FSSDKGotoUtility openURL:UTF8URLString from:self];
}


#pragma mark - 首次进入持仓界面
- (void)firstLaunch{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *firstLaunch = [NSString stringWithFormat:@"alertGestureLock%@",USER_INFO.mUserId];
    NSString *gesturePassword = [userDefault objectForKey:[FSStringUtils getPasswordKey]];
    
    if(![userDefault boolForKey:firstLaunch] && ![gesturePassword CM_isValidString]) {
        [userDefault setBool:YES forKey:firstLaunch];
        [userDefault synchronize];
        
      
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置手势密码" message:@"为了您的账户安全,请设置手势密码" preferredStyle:UIAlertControllerStyleAlert];
      
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
 
            }];
            
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [FSGotoUtility gotoGestureLockViewController:self.navigationController
                                                        type:FSGestureLockTypeSet
                                                    animated:YES];
             }];
            
            [alert addAction:cancelAction];
            [alert addAction:confirmAction];
        
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        
    }
    
}

- (FSAssetViewModel *)assetViewModel{
    if (!_assetViewModel) {
        _assetViewModel = [[FSAssetViewModel alloc] init];
    }
    return _assetViewModel;
}
- (FSAnnouncementViewModel *)announcementViewModel{
    if (!_announcementViewModel) {
        _announcementViewModel = [[FSAnnouncementViewModel alloc] init];
    }
    return _announcementViewModel;
}

- (FSAssetExplanationViewModel *)assetExplanationViewModel {
    if (!_assetExplanationViewModel) {
        _assetExplanationViewModel = [[FSAssetExplanationViewModel alloc] init];
    }
    return _assetExplanationViewModel;
}

- (FSMarketViewModel *)marketViewModel {
    if (!_marketViewModel) {
        _marketViewModel = [[FSMarketViewModel alloc] init];
    }
    return _marketViewModel;
}

- (FSAssetUserLevelViewModel *)userInfoViewModel
{
    if(!_userInfoViewModel)
    {
        _userInfoViewModel = [[FSAssetUserLevelViewModel alloc] init];
    }
    return _userInfoViewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
