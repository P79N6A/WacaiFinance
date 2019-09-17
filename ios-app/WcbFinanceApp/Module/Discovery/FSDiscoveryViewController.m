//
//  FSDiscoveryViewController.m
//  Financeapp
//
//  Created by 叶帆 on 08/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryViewController.h"
#import <IGListKit.h>
#import <MJRefresh/MJRefresh.h>
#import "FSAssetRefreshHeader.h"
#import "FSParallaxHeaderView.h"
#import "FSDcvrSpaceEntity.h"
#import "FSDcvrSpaceSectionController.h"
#import "FSMenuData.h"
#import "FSDiscoveryEntity.h"
#import "FSDiscoveryTypeTitleData.h"
#import "FSDiscoveryTagSectionController.h"
#import "FSDiscoveryPostSectionController.h"
#import "FSDiscoveryBindPromotionSectionController.h"
#import "FSDiscoveryNavView.h"
#import "FSDiscoveryTagContainerView.h"
#import "FSDiscoveryBannerSectionController.h"
#import "FSDiscoveryPost.h"
#import "FSDiscoveryBanner.h"
#import "FSDiscoveryMenuViewModel.h"
#import "FSDiscoveryBannerViewModel.h"
#import "FSDiscoveryTagViewModel.h"
#import "FSDiscoveryPostViewModel.h"
#import "FSDiscoveryBindPromotionViewModel.h"
#import "FSDiscoveryExceptionSectionController.h"
#import <UIView+FSUtils.h>
#import <CMNSArray/CMNSArray.h>

#import "FSDiscoveryFinancialServiceSectionController.h"

#import "FSDcvrBindPromotionViewModel.h"
#import "FSDcvrFinServerMenuViewModel.h"
#import "FSDcvrBannerViewModel.h"
#import "FSDcvrTagViewModel.h"
#import "FSDcvrPostViewModel.h"
#import "FSDcvrDataExceptionViewModel.h"
#import "FSCanShowAccordingAppStoreInfoHandler.h"
#import "FSDcvrFinServerBannerSectionController.h"

#import "FSDiscoveryRefreshHeader.h"
#import "FSDcvrTypeTitleSectionController.h"
#import "FSDiscoveryViewController+FSWeChatPop.h"
#import "DNSConfigViewController.h"
#import "FSHTTPDNSWhiteListManager.h"

#import <NeutronBridge/NeutronBridge.h>
#import <i-Finance-Library/FSSDKGotoUtility.h>

@interface FSDiscoveryViewController ()
<
IGListAdapterDataSource,
FSDiscoveryTagContainerViewDelegate,
FSDiscoveryPostSectionDelegate,
FSDiscoveryBannerSectionDelegate,
FSDiscoveryNavViewDelegate,
FSDcvrFinServerBannerSectionDelegate,
FSDiscoveryWeChatPopViewDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FSParallaxHeaderView *parallaxView;
@property (nonatomic, strong) FSDiscoveryNavView *navView;
@property (nonatomic, strong) FSDiscoveryTagContainerView *tagContainerView;

@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic, strong) NSMutableArray<id<IGListDiffable>> *dataSource;

@property (nonatomic, strong) FSDiscoveryMenuViewModel *menuViewModel;
@property (nonatomic, strong) FSDiscoveryBannerViewModel *bannerViewModel;
@property (nonatomic, strong) FSDiscoveryTagViewModel *tagViewModel;
@property (nonatomic, strong) FSDiscoveryPostViewModel *postViewModel;
@property (nonatomic, strong) FSDiscoveryBindPromotionViewModel *bindPromotionViewModel;
@property (nonatomic, strong) FSDiscoveryBannerViewModel *financeServerBannerViewModel;

@property (nonatomic, assign) BOOL shouldRefreshForTagSelected;
@property (nonatomic, assign) BOOL isLastLeaveForPostDetail;
@property (nonatomic, assign) BOOL isLastLeaveForBannerDetail;
@property (nonatomic, assign) BOOL isLastLeaveForServerBannerDetail;

@property (nonatomic, assign) BOOL isLoggedLastLeave;


@property (nonatomic, strong) FSDcvrFinServerMenuViewModel *finMenuViewModel;


@end

//static CGFloat const kNavHeight = FS_NavigationBarHeight;
static CGFloat const kTagViewHeight = 52;
static CGFloat const kTagFinanceServerMenuErrorViewHeight = 120;

@implementation FSDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self bindViewModel];
    
#ifdef TestHTTPDNS
    [self setupHttpDnsSetting];
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarItem.badgeValue = nil;
    
    if (!(self.isLastLeaveForPostDetail || self.isLastLeaveForBannerDetail || self.isLastLeaveForServerBannerDetail) || [self isBackWithLoginChanged]) {
        // 添加未登录状态下的刷新逻辑，不然在帖子详情页完成登录之后，发现页的头像和昵称会不显示
        [self pageRefreshRequest];
    }
    self.isLastLeaveForPostDetail = NO;
    self.isLastLeaveForBannerDetail = NO;
    self.isLastLeaveForServerBannerDetail = NO;
    
    [self requestAndShowWeChatPopIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UserAction skylineEvent:@"finance_wcb_find_enter_page"];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = [NSMutableArray array];
        self.menuViewModel = [FSDiscoveryMenuViewModel new];
        self.bannerViewModel = [[FSDiscoveryBannerViewModel alloc] initWithBelongModule:@"0"];
        
        self.tagViewModel = [FSDiscoveryTagViewModel new];
        self.postViewModel = [FSDiscoveryPostViewModel new];
        self.bindPromotionViewModel = [FSDiscoveryBindPromotionViewModel new];
        
        self.financeServerBannerViewModel = [[FSDiscoveryBannerViewModel alloc] initWithBelongModule:@"1"];
        
        self.shouldRefreshForTagSelected = NO;
        self.isLastLeaveForPostDetail = NO;
        self.isLastLeaveForBannerDetail = NO;
        self.isLoggedLastLeave = [USER_INFO isLogged];
    }
    
    return self;
}

- (void)pageRefreshRequest {
    [self.menuViewModel.menuCommand execute:nil];
    [self.financeServerBannerViewModel.bannerCommand execute:nil];
    [self.bindPromotionViewModel.promotionTextCommand execute:nil];
    [self.tagViewModel.tagCommand execute:nil];
    [self.bannerViewModel.bannerCommand execute:nil];
}

- (void)bindViewModel {
    @weakify(self);
    
    RACSignal *menuDataChanged = [RACObserve(self.menuViewModel, menuModels) distinctUntilChanged];
    RACSignal *bindPromotionChanged = [RACObserve(self.bindPromotionViewModel, bindPromotionText) distinctUntilChanged];
    
    RACSignal *otherInfoChanged = [[RACSignal combineLatest:@[menuDataChanged, bindPromotionChanged]] skip:1];
    [[otherInfoChanged deliverOnMainThread] subscribeNext:^(RACTuple *x) {
        
        [self reloadDataSource];
    }];
    
    
    
    RACSignal *tagDataRefreshed = [RACObserve(self.tagViewModel, tags) filter:^BOOL(NSArray *tags) {
        BOOL shouldRequestPostData = tags.count > 0;
        return shouldRequestPostData;
    }];
    [[tagDataRefreshed deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        [self.postViewModel.firstPagePostCommand execute:[self tagIDofIndex:0]];
    }];
    
    RACSignal *postDataChanged = [RACObserve(self.postViewModel, posts) distinctUntilChanged];
    RACSignal *bannerDataChanged = [RACObserve(self.bannerViewModel, banners) distinctUntilChanged];
    
    RACSignal *serverBannerDataChanged = [RACObserve(self.financeServerBannerViewModel, banners) distinctUntilChanged];
    
    RACSignal *contentDataChanged = [[RACSignal combineLatest:@[postDataChanged, bannerDataChanged]] skip:1];
    [[contentDataChanged deliverOnMainThread] subscribeNext:^(RACTuple *x) {
        @strongify(self);
        [self reloadDataSource];
    }];
    
    [[self.financeServerBannerViewModel.bannerCommand.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == NO)
        {
            [self reloadDataSource];
        }
    }];
    
    
    self.collectionView.mj_header.refreshingBlock = ^{
        @strongify(self);
        [self pageRefreshRequest];
    };
    
    NSArray *pageRefreshCombines = @[self.menuViewModel.menuCommand.executing,
                                     self.bindPromotionViewModel.promotionTextCommand.executing,
                                     self.tagViewModel.tagCommand.executing,
                                     self.bannerViewModel.bannerCommand.executing,
                                     self.postViewModel.firstPagePostCommand.executing,
                                     self.financeServerBannerViewModel.bannerCommand.executing];
    
    RACSignal *pageSignal = [RACSignal combineLatest:pageRefreshCombines];
    [[[pageSignal filter:^BOOL(RACTuple *excutingTuple) {
        BOOL hasAllExcutingDone =
        ![[excutingTuple objectAtIndex:0] boolValue] &&
        ![[excutingTuple objectAtIndex:1] boolValue] &&
        ![[excutingTuple objectAtIndex:2] boolValue] &&
        ![[excutingTuple objectAtIndex:3] boolValue] &&
        ![[excutingTuple objectAtIndex:4] boolValue] &&
        ![[excutingTuple objectAtIndex:5] boolValue] &&
        ![[excutingTuple objectAtIndex:6] boolValue] &&
        ![[excutingTuple objectAtIndex:7] boolValue];
        return hasAllExcutingDone;
    }] skip:1] subscribeNext:^(id x) {
        [self.collectionView.mj_header endRefreshing];
    }];
    
    self.collectionView.mj_footer.refreshingBlock = ^{
        @strongify(self);
        [self.postViewModel.morePostCommand execute:[self tagIDofSelectedTag]];
    };
    
    [[[self.postViewModel.morePostCommand.executing deliverOnMainThread] skip:1] subscribeNext:^(NSNumber *isExcuting) {
        @strongify(self);
        if (![isExcuting boolValue]) {
            if (self.postViewModel.noMorePosts || self.postViewModel.morePostError) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.collectionView.mj_footer endRefreshing];
            }
        }
    }];
    
    [[[self.postViewModel.firstPagePostCommand.executing deliverOnMainThread] skip:1] subscribeNext:^(NSNumber *isExcuting) {
        @strongify(self);
        if (![isExcuting boolValue]) {
            
            [self reloadDataSource];
            
            if (self.postViewModel.noMorePosts) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.collectionView.mj_footer endRefreshing];
            }
        }
    }];
    
    
    RACSignal *scrollOffsetSignal = RACObserve(self.collectionView, contentOffset);
    [[scrollOffsetSignal deliverOnMainThread] subscribeNext:^(NSValue *offsetValue) {
        CGPoint contentOffset = offsetValue.CGPointValue;
        //[self.parallaxView layoutHeaderViewForScrollViewOffset:contentOffset];
        
        [self forceAdjustcTag:contentOffset];
        
    }];
}

- (void)forceAdjustcTag:(CGPoint)collectionViewContentOffset
{
    CGPoint contentOffset = collectionViewContentOffset;
    if ([self shouldStickyTagView:contentOffset.y]) {
        
        self.tagContainerView.frame = [self tagViewFrame];
        [self.tagContainerView showBottomLine];
        
    }else{
        
        self.tagContainerView.top = [self tagViewInitYPosition];
        [self.tagContainerView hideBottomLine];
    }
}

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor colorWithHex:0xF6F6F6];
    
    
    self.collectionView = ({
        IGListCollectionViewLayout *collectionViewlayout = [[IGListCollectionViewLayout alloc] initWithStickyHeaders:NO
                                                                                                     topContentInset:0
                                                                                                       stretchToEdge:NO];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                              collectionViewLayout:collectionViewlayout];
        collectionView.backgroundColor = [UIColor clearColor];
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:nil];
        [footer setTitle:@"加载更多消息..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"继续往下，惊喜更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"挖不出来了(＞﹏＜)" forState:MJRefreshStateNoMoreData];
        footer.stateLabel.font = [UIFont systemFontOfSize:13];
        footer.stateLabel.textColor = RGBColorHex(0x878787);
        footer.refreshingTitleHidden = YES;
        footer.hidden = YES;
        collectionView.mj_footer = footer;
        
        FSDiscoveryRefreshHeader *header = [FSDiscoveryRefreshHeader headerWithRefreshingBlock:nil];
        collectionView.mj_header = header;
        
        collectionView;
    });
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_NavigationBarHeight);
        make.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-FS_TabbarHeight);
    }];
    
    self.navView = ({
        FSDiscoveryNavView *view = [[FSDiscoveryNavView alloc] init];
        
        view.delegate = self;
        
        view.frame = CGRectMake(0, 0, self.view.bounds.size.width,FS_NavigationBarHeight);
        view;
    });
    [self.view addSubview:self.navView];
    
    self.tagContainerView = ({
        FSDiscoveryTagContainerView *containerView = [FSDiscoveryTagContainerView viewWithTags:self.tagViewModel.tags];
        containerView.frame = [self tagViewFrame];
        containerView.clickDelegate = self;
        containerView.hidden = YES;
        containerView;
    });
    [self.collectionView addSubview:self.tagContainerView];
    
    self.adapter = ({
        IGListAdapter *adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init]
                                                         viewController:self];
        adapter.collectionView = self.collectionView;
        adapter.dataSource = self;
        adapter;
    });
    
    
    self.weChatPopView = ({
        FSDiscoveryWeChatPopView *weChatPopView = [[FSDiscoveryWeChatPopView alloc] init];
        weChatPopView.delegate = self;
        weChatPopView.hidden = YES; //默认隐藏，需要时展示。
        weChatPopView;
    });
    [self.view addSubview:self.weChatPopView];
    [self.weChatPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(48);
        make.width.mas_equalTo(308);
        make.top.equalTo(self.view).mas_offset(NaviBarHeight + StatusBarHeight);
        make.right.equalTo(self.view).mas_offset(-8);
    }];
}

- (void)reloadDataSource
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
    
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.15];
}


- (void)reloadData
{
    [self.dataSource removeAllObjects];
    
    [self addBindPromotion:self.dataSource];
    
    //金融服务(已更名“发现精彩”)
    [self addTitleData:@"发现精彩" source:self.dataSource];
    
    //金融服务四个menu
    [self addFinanceServerMenu:self.dataSource];
    
    //金融服务运营栏
    [self addFinanceServerBanner:self.dataSource];
    
    //空格
    [self addSpace:self.dataSource];
    
    //精选内容
    [self addTitleData:@"精选内容" source:self.dataSource];
    
    //tags
    [self addDiscoverTags:self.dataSource];
    
    //posts
    [self addPostData:self.dataSource];
    if ([self isPostDataValid]) {
        self.collectionView.mj_footer.hidden = NO;
    }
    
    [self.adapter performUpdatesAnimated:NO completion:^(BOOL finished) {
        if (self.shouldRefreshForTagSelected) {
            self.shouldRefreshForTagSelected = NO;
            NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.collectionView scrollToItemAtIndexPath:firstIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }
        
        //强制刷新一次，否则特殊情况下会导致tagview 位置异常
        [self forceAdjustcTag:self.collectionView.contentOffset];
    }];
}


- (void)addTitleData:(NSString *)title source:(NSMutableArray *)array
{
    FSDiscoveryTypeTitleData *finacneTitle = [[FSDiscoveryTypeTitleData alloc] init];
    finacneTitle.name = title;
    [array addObject:finacneTitle];
}

- (void)addSpace:(NSMutableArray *)source
{
    [self.dataSource addObject:[[FSDcvrSpaceEntity alloc] init]];
}


- (void)addBindPromotion:(NSMutableArray *)source
{
    if ([self shouldShowBindPromotion])
    {
        FSDcvrBindPromotionViewModel *model = [[FSDcvrBindPromotionViewModel alloc] init];
        model.bindPromotionText = self.bindPromotionViewModel.bindPromotionText;
        [source addObject:model];
    }
}

- (void)addFinanceServerMenu:(NSMutableArray *)source
{
    self.finMenuViewModel = nil;
    if(self.menuViewModel.error)
    {
        FSDcvrDataExceptionViewModel *expModel = [[FSDcvrDataExceptionViewModel alloc] init];
        expModel.exceptionCellHeight = kTagFinanceServerMenuErrorViewHeight;
        [source addObject:expModel];
    }
    else
    {
        FSDcvrFinServerMenuViewModel *model = [[FSDcvrFinServerMenuViewModel alloc] init];
        model.menuArray = self.menuViewModel.menuModels;
        self.finMenuViewModel = model;
        
        [source addObject:model];
    }
}

- (void)addFinanceServerBanner:(NSMutableArray *)source
{
    if(self.financeServerBannerViewModel.error)
    {
        FSDcvrDataExceptionViewModel *expModel = [[FSDcvrDataExceptionViewModel alloc] init];
        expModel.exceptionCellHeight = kTagFinanceServerBannerErrorViewHeight;
        [source addObject:expModel];
    }
    else if(self.financeServerBannerViewModel.banners.count > 0)
    {
        FSDcvrBannerViewModel *model = [[FSDcvrBannerViewModel alloc] init];
        model.banners = self.financeServerBannerViewModel.banners;
        model.error   = self.financeServerBannerViewModel.error;
        model.belongMode = self.financeServerBannerViewModel.belongModule;
        [source addObject:model];
    }
}

- (void)addDiscoverTags:(NSMutableArray *)source
{
    if ([self shouldShowDiscoveryTags]) {
        //CollectionView 添加 Tag 的占位符
        FSDcvrTagViewModel *model = [[FSDcvrTagViewModel alloc] init];
        [self.dataSource addObject:model];
        //更新真正的Tag View
        [self.tagContainerView setTags:self.tagViewModel.tags];
        self.tagContainerView.hidden = NO;
    } else {
        self.tagContainerView.hidden = YES;
    }
}

- (void)addPostData:(NSMutableArray *)source
{
    if (![self isPostDataError]) {
        [self.postViewModel.posts enumerateObjectsUsingBlock:^(FSDiscoveryPost * _Nonnull post, NSUInteger idxInPosts, BOOL * _Nonnull stop) {
            post.isInFirstTag = self.tagContainerView.selectedTagIndex == 0;
            
            FSDcvrPostViewModel *model = [[FSDcvrPostViewModel alloc] init];
            model.post = post;
            
            [self.dataSource addObject:model];
            
            if ([self shouldShowDiscoveryBanner:idxInPosts])
            {
                FSDcvrBannerViewModel *bannerModel = [[FSDcvrBannerViewModel alloc] init];
                bannerModel.banners = self.bannerViewModel.banners;
                bannerModel.belongMode = self.bannerViewModel.belongModule;
                
                [self.dataSource addObject:bannerModel];
            }
            
        }];
    } else {
        
        FSDcvrDataExceptionViewModel *model = [[FSDcvrDataExceptionViewModel alloc] init];
        model.exceptionCellHeight = 320;
        [self.dataSource addObject:model];
    }
}


#pragma mark - IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return [self.dataSource copy];
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    
    if ([object isKindOfClass:[FSDcvrBindPromotionViewModel class]])
    {
        return [[FSDiscoveryBindPromotionSectionController alloc] init];
    }
    else if([object isKindOfClass:[FSDcvrFinServerMenuViewModel class]])
    {
        return  [[FSDiscoveryFinancialServiceSectionController alloc] init];
    }
    else if([object isKindOfClass:[FSDcvrBannerViewModel class]])
    {
        FSDcvrBannerViewModel *vModel = object;
        if([vModel.belongMode isEqualToString:@"1"])
        {
            FSDcvrFinServerBannerSectionController *controller = [[FSDcvrFinServerBannerSectionController alloc] init];
            controller.delegate = self;
            
            return controller;
        }
        else
        {
            FSDiscoveryBannerSectionController *bannerSectionController = [[FSDiscoveryBannerSectionController alloc] init];
            bannerSectionController.delegate = self;
            
            return bannerSectionController;
        }
        
    }
    else if([object isKindOfClass:[FSDcvrTagViewModel class]])
    {
        return [[FSDiscoveryTagSectionController alloc] init];
    }
    else if([object isKindOfClass:[FSDcvrPostViewModel class]])
    {
        FSDiscoveryPostSectionController *postSectionController = [[FSDiscoveryPostSectionController alloc] init];
        postSectionController.delegate = self;
        return postSectionController;
    }
    else if([object isKindOfClass:[FSDcvrBindPromotionViewModel class]])
    {
        return [[FSDiscoveryBindPromotionSectionController alloc] init];
    }
    else if([object isKindOfClass:[FSDcvrDataExceptionViewModel class]])
    {
        return [[FSDiscoveryExceptionSectionController alloc] init];
    }
    else if([object isKindOfClass:[FSDcvrSpaceEntity class]]){
        return [[FSDcvrSpaceSectionController alloc] init];
    } else if([object isKindOfClass:[FSDiscoveryTypeTitleData class]]){
        return [[FSDcvrTypeTitleSectionController alloc] init];
    } else {
        return [[IGListSectionController alloc] init];
    }
    
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - Post Delegate
- (void)discoveryPostSectionDidClicked {
    self.isLastLeaveForPostDetail = YES;
    self.isLoggedLastLeave = [USER_INFO isLogged];
}

#pragma mark - Banner Delegate
- (void)discoveryBannerSectionDidClicked {
    self.isLastLeaveForBannerDetail = YES;
    self.isLoggedLastLeave = [USER_INFO isLogged];
}

#pragma mark - FSDcvrFinServerBannerSectionDelegate
- (void)dcvrFinServerBannerSectionDidClicked
{
    self.isLastLeaveForServerBannerDetail = YES;
}


#pragma mark - Tag Delegate
- (void)didSelectedTagAtIndex:(NSUInteger)index {
    [self.collectionView.mj_footer endRefreshing];
    self.postViewModel.noMorePosts = NO;
    self.shouldRefreshForTagSelected = YES;
    NSString *tagID = [self tagIDofSelectedTag];
    [self.postViewModel.firstPagePostCommand execute:tagID];    
    [UserAction skylineEvent:@"finance_wcb_find_tag_click" attributes:@{@"lc_label_id": tagID}];
}

#pragma mark - FSDiscoveryNavViewDelegate
- (void)navViewSettingBtnTap:(UIButton *)btn
{
    [self hideWeChatPopViewForever]; //@花州 & 冰清 - 交互需求：点击「账户设置」时，关闭微信绑定气泡
    [UserAction skylineEvent:@"finance_wcb_find_accountsetting_click"];
    [FSSDKGotoUtility openURL:@"wacaifinance://accountSettings" from:self];
    
}


- (nonnull NSString *)tagIDofSelectedTag {
    return [self tagIDofIndex:self.tagContainerView.selectedTagIndex];
}

- (nonnull NSString *)tagIDofIndex:(NSUInteger)index {
    FSDiscoveryTag *tag = [self.tagViewModel.tags fs_objectAtIndex:index];
    return tag.tagID ?: @"";
}

#pragma mark - FSDiscoveryWeChatPopViewDelegate
- (void)onWeChatPopCloseAreaClicked {
    [self hideWeChatPopViewForever];
}

#pragma mark - Helper Methods
- (BOOL)isBackWithLoginChanged {
    return (self.isLoggedLastLeave != [USER_INFO isLogged]);
    
}

- (BOOL)shouldShowDiscoveryTags {
    return self.tagViewModel.tags.count > 0;
}

- (BOOL)shouldShowDiscoveryBanner:(NSUInteger)idxInPosts {
    BOOL isBannerDataExist = self.bannerViewModel.banners.count > 0;
    BOOL isBannerIndex = idxInPosts == 2;
    BOOL isBannerTag = self.tagContainerView.selectedTagIndex == 0;
    if (isBannerIndex && isBannerTag && isBannerDataExist) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)shouldShowMenu
{
    return YES;
}

- (BOOL)shouldShowFinanceServerBanner
{
    if(self.financeServerBannerViewModel.banners.count > 0 || self.financeServerBannerViewModel.error)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)shouldShowBindPromotion {
    NSString *text = self.bindPromotionViewModel.bindPromotionText;
    BOOL isTextExist = text && ![text isEqualToString:@""];
    return isTextExist;
}


- (BOOL)isPostDataError {
    return self.postViewModel.firstPostError;
}

- (BOOL)isPostDataValid {
    return [self.postViewModel.posts CM_isValidArray];
}

- (CGRect)tagViewFrame {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return CGRectMake(0, [self tagViewYPosition], width, kTagViewHeight);
}

- (CGFloat)tagViewYPosition {
    if ([self shouldStickyTagView:self.collectionView.contentOffset.y]) {
        return self.collectionView.contentOffset.y;
    } else {
        return [self tagViewInitYPosition];
    }
}

- (CGFloat)tagViewInitYPosition {
    CGFloat offset = 41.0;
    if ([self shouldShowBindPromotion]) {
        offset = offset + 45;
    }
    
    offset += 41.0; //title
    offset += 12; //space
    
    if ([self shouldShowMenu])
    {
        if(self.menuViewModel.error)
        {
            offset = offset + kTagFinanceServerMenuErrorViewHeight;
        }
        else
        {
            offset = offset + [self.finMenuViewModel heightForMenus];
        }
    }
    
    if ([self shouldShowFinanceServerBanner])
    {
        if(self.financeServerBannerViewModel.error)
        {
            offset = offset + kTagFinanceServerBannerErrorViewHeight;
        }
        else
        {
            offset = offset + [FSDcvrBannerViewModel bannerHeight];
        }
    }
    return offset;
}

- (CGFloat)tagViewStickyYPosition {
    return - [self tagViewInitYPosition];
}

- (BOOL)shouldStickyTagView:(CGFloat)scrollViewContentYOffset {
    return -scrollViewContentYOffset < [self tagViewStickyYPosition];
}

#pragma mark - httpdns test back btn
- (void)setupHttpDnsSetting
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"httpDns" forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.frame = CGRectMake(20, 30, 100, 40);
    [self.navView addSubview:btn];
    [btn addTarget:self action:@selector(onBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)onBackAction:(id)sender
{
    DNSConfigViewController *dnsConfigViewController = [[DNSConfigViewController alloc] initWithNibName:@"DNSConfigViewController" bundle:nil];
    [self.navigationController pushViewController:dnsConfigViewController animated:YES];

}
@end
