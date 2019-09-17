//
//  FSAccountSettingsViewController.m
//  FinanceApp
//
//  Created by 叶帆 on 16/03/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSAccountSettingsViewController.h"
#import "FinSettingTableViewCell.h"
#import "FinSettingTableViewCellViewModel.h"
#import "FSAccountInfoEntranceCell.h"
#import "FSAccountInfoEntranceCellViewModel.h"
#import "FSEmptyCell.h"
#import "FSEmptyCellViewModel.h"
#import "FSButtonCellViewModel.h"
#import "FSAssetLineCell.h"
#import "FSAssetLineCellViewModel.h"
#import <WCAnalytics/WCAnalytics.h>
#import <CMUIDisappearView/CMUIDisappearView.h>
#import <CMNSArray/CMNSArray.h>
#import "FSButtonCell.h"
#import "FSAccountSettingsHandler.h"
#import "FSAccountSettingsViewModelHandler.h"
#import "UIViewController+FSUtil.h"
#import <i-Finance-Library/FSSDKGotoUtility.h>


static NSString *const kSettingCell = @"SettingCell";
static NSString *const kFSAccountInfoEntranceCell = @"FSAccountInfoEntranceCell";
static NSString *const kFSEmptyCell = @"FSEmptyCell";
static NSString *const kFSAssetLineCell = @"FSAssetLineCell";
static NSString *const kFSButtonCell = @"FSButtonCell";

@interface FSAccountSettingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) FSAccountSettingsHandler *handler;
@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation FSAccountSettingsViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initListenEvents {
    extern NSString *kFSAccountSettingsNotificationListRefresh;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(delayReload)
                                                 name:kFSAccountSettingsNotificationListRefresh
                                               object:nil];
    
    extern NSString *kFSAccountSettingsNotificationLogout;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutAndBack)
                                                 name:kFSAccountSettingsNotificationLogout
                                               object:nil];
}

- (void)delayReload //减少短时间内刷新次数
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadDataSource) object:nil];
    [self performSelector:@selector(reloadDataSource) withObject:nil afterDelay:0.15];
}


- (void)reloadDataSource {
    NSArray *newDataSource = [self.handler updateDataSource];
    if ([newDataSource CM_isValidArray]) {
        self.dataSource = newDataSource;
        [self.tableView reloadData];
    }
}

- (void)loadLocalDataSource {
    NSArray *newDataSource = [self.handler localDataSource];
    if ([newDataSource CM_isValidArray]) {
        self.dataSource = newDataSource;
        [self.tableView reloadData];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initListenEvents];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadLocalDataSource];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    
    NSDictionary *s_att;
    if([[CMAppProfile sharedInstance] isLogin])
    {
        s_att = @{@"lc_login":@"1"};
    }
    else
    {
        s_att = @{@"lc_login":@"0"};
    }
    [UserAction skylineEvent:@"finance_wcb_accountsetting_enter_page" attributes:s_att];

    [self.handler fetchPageConfig];
    [self.handler fetchUserInfoIfNeeded];
}


- (void)setupUI {
    self.title = @"账户设置";
    self.view.backgroundColor = COLOR_DEFAULT_BACKGROUND;
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.tableHeaderView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        tableView.tableFooterView = nil;
        tableView.backgroundView = nil;
        tableView.backgroundColor = COLOR_DEFAULT_BACKGROUND;
        tableView.separatorColor = HEXCOLOR(0xe7e7e7);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[FinSettingTableViewCell class] forCellReuseIdentifier:kSettingCell];
        [tableView registerClass:[FSAccountInfoEntranceCell class] forCellReuseIdentifier:kFSAccountInfoEntranceCell];
        [tableView registerClass:[FSEmptyCell class] forCellReuseIdentifier:kFSEmptyCell];
        [tableView registerClass:[FSAssetLineCell class] forCellReuseIdentifier:kFSAssetLineCell];
        [tableView registerClass:[FSButtonCell class] forCellReuseIdentifier:kFSButtonCell];
        [self.view addSubview:tableView];
        tableView;
    });
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_NavigationBarHeight);
        make.right.bottom.left.equalTo(self.view);
    }];
}

#pragma mark - TableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cellViewModel = [self.dataSource fs_objectAtIndex:indexPath.row];
    if ([cellViewModel isKindOfClass:[FSAccountInfoEntranceCellViewModel class]]) {
        FSAccountInfoEntranceCellViewModel *accountInfoVM = cellViewModel;
        FSAccountInfoEntranceCell *cell = [tableView dequeueReusableCellWithIdentifier:kFSAccountInfoEntranceCell];
        cell.avatarImageView.image = accountInfoVM.avatar;
        cell.nicknameLabel.text = accountInfoVM.nickname;
        
        return cell;
    } else if ([cellViewModel isKindOfClass:[FSEmptyCellViewModel class]]) {
        FSEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:kFSEmptyCell];
        return cell;
    } else if ([cellViewModel isKindOfClass:[FinSettingTableViewCellViewModel class]]) {
        FinSettingTableViewCellViewModel *settingVM = cellViewModel;
        FinSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCell];
        cell.rightImageView.hidden = YES;
        cell.arrowImageView.hidden = ![settingVM.linkURL CM_isValidString];
        cell.detailTextLabel.hidden = NO;
        [cell titleToSuper];
        [cell detaialTitleToArrow];
        
        cell.settingTitleLabel.text = settingVM.title;
        cell.settingDetailLabel.text = settingVM.detail;
        cell.settingDetailLabel.textColor = settingVM.detailColor;
        
        return cell;
    } else if ([cellViewModel isKindOfClass:[FSButtonCellViewModel class]]){
        FSButtonCellViewModel *buttonVM = cellViewModel;
        FSButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kFSButtonCell];
        cell.backgroundColor = [UIColor clearColor];
        [cell configButtonTitle:buttonVM.title];

        return cell;
    } else if ([cellViewModel isKindOfClass:[FSAssetLineCellViewModel class]]){
        FSAssetLineCellViewModel *lineVM = cellViewModel;
        FSAssetLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kFSAssetLineCell];
        [cell setupLeftPadding:lineVM.leftPadding];
        return cell;
    } else {
        return [[UITableViewCell alloc] init];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id cellViewModel = [self.dataSource fs_objectAtIndex:indexPath.row];
    if ([cellViewModel isKindOfClass:[FSAccountInfoEntranceCellViewModel class]]) {
        
        FSAccountInfoEntranceCellViewModel *accountInfoVM = cellViewModel;
        // 埋点、URL 已转入 Model 中处理
        [UserAction skylineEvent:accountInfoVM.skylineEventName];
        if (USER_INFO.isLogged) {
            [FSSDKGotoUtility openURL:accountInfoVM.linkURL from:self];
        } else {
            
            self.fsRouterName = @"account_setting";
            [FSGotoUtility gotoLoginViewController:self success:^{}];
        }
    
        
    } else if ([cellViewModel isKindOfClass:[FSEmptyCellViewModel class]]) {
        
    } else if ([cellViewModel isKindOfClass:[FinSettingTableViewCellViewModel class]]) {
        
        FinSettingTableViewCellViewModel *settingVM = cellViewModel;
        if ([settingVM.skylineEventName CM_isValidString]) {
            NSDictionary *s_att = [[CMAppProfile sharedInstance] isLogin] ? @{@"lc_login":@"1"} : @{@"lc_login":@"0"};
            [UserAction skylineEvent:SafeString(settingVM.skylineEventName) attributes:s_att];
        }
        [FSSDKGotoUtility openURL:settingVM.linkURL from:self];
        
    } else if ([cellViewModel isKindOfClass:[FSButtonCellViewModel class]]){
        
        [UserAction skylineEvent:@"finance_wcb_accountsetting_logout_click"];
        [self signOut];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cellViewModel = [self.dataSource fs_objectAtIndex:indexPath.row];
    if ([cellViewModel isKindOfClass:[FSAccountInfoEntranceCellViewModel class]]) {
        return 75;
    } else if ([cellViewModel isKindOfClass:[FSEmptyCellViewModel class]]) {
        FSEmptyCellViewModel *emptyVM = cellViewModel;
        return emptyVM.cellHeight;
    } else if ([cellViewModel isKindOfClass:[FinSettingTableViewCell class]]) {
        return 56;
    } else if ([cellViewModel isKindOfClass:[FSButtonCellViewModel class]]) {
        return 49;
    } else if ([cellViewModel isKindOfClass:[FSAssetLineCellViewModel class]]) {
        return 1;
    } else {
        return 56;
    }}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark - Event method
- (void)signOut {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"安全退出" message:@"退出当前帐号，下次登录时\n依然可以使用本帐号。" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    
    [alertView show];
    
    [alertView.rac_willDismissSignal subscribeNext:^(NSNumber *index) {
        if (index.integerValue == 1) {
            [USER_INFO logout];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    }];
}

- (void)logoutAndBack {
    [CMUIDisappearView showMessage:@"登录失效,请重新登录"];
    [USER_INFO logout];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

- (FSAccountSettingsHandler *)handler {
    if (!_handler) {
        _handler = [[FSAccountSettingsHandler alloc] init];
    }
    return _handler;
}

@end
