//
//  FSMoreSettingsViewController.m
//  FinanceApp
//
//  Created by 叶帆 on 15/03/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSMoreSettingsViewController.h"
#import "FinSettingTableViewCell.h"
#import "TitleWithSwitchCell.h"
#import "EnvironmentInfo.h"
#import "FSDepositViewModel.h"
#import <i-Finance-Library/FSSDKGotoUtility.h>

static NSString *const kSettingCell = @"SettingCell";
static NSString *const kTitleWithSwitchCell = @"TitleWithSwitchCell";
static NSString *const kFSDiscoverNewsSwitch = @"FSDiscoverNewsSwitch";

@interface FSMoreSettingsViewController ()<UITableViewDelegate, UITableViewDataSource, TitleWithSwitchCellDelegate>

@property (nonatomic,strong) UITableView *tableView;
//是否展示存管协议入口
@property (nonatomic,assign,getter=isShouldShowDeposit) BOOL shouldShowDeposit;

@property(nonatomic, strong) FSDepositViewModel *depositViewModel;
@property(nonatomic, copy) NSString *depositUrl;

@end

@implementation FSMoreSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    self.shouldShowDeposit       = NO;
    
    [self bindModel];
    
}


#pragma mark - bindModel

- (void)bindModel{
    [self.depositViewModel.depositCommand execute:nil];
    
    @weakify(self);
  
    [[[RACObserve(self.depositViewModel, depositData) distinctUntilChanged] deliverOnMainThread]
     subscribeNext:^(FSDepositData *depositData) {
        @strongify(self);
 
        if (depositData) {
            self.shouldShowDeposit = [depositData.depositAuthorizeSwitch boolValue];
            self.depositUrl = depositData.jumpUrl;
            [self.tableView reloadData];
        }

    }];
}

- (NSInteger)numberOfSectionCount{
    return self.isShouldShowDeposit ? 4 : 3;
}
#pragma mark - TableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        NSNumber *isOn = [[NSUserDefaults standardUserDefaults] objectForKey:kFSDiscoverNewsSwitch];
        BOOL switchState = (isOn != nil) ? [isOn boolValue] : YES;
        TitleWithSwitchCell *titleWithSwitchCell = [TitleWithSwitchCell cellWithTitle:@"精选发现更新提醒"
                                                                              switchState:switchState
                                                                                 delegate:self];
        return titleWithSwitchCell;
        
    }else{
        
        FinSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCell];
        cell.rightImageView.hidden = YES;
        cell.arrowImageView.hidden = NO;
        cell.detailTextLabel.hidden = YES;
        [cell titleToSuper];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        
        NSString *title = nil;
        
        if (self.isShouldShowDeposit) {
            
            switch (indexPath.section) {
                case 1:
                    title = @"银行存管授权"; //八佰
                    break;
                case 2:
                    title = @"法律协议";
                    break;
                case 3:
                    title = @"挖财隐私权政策";
                    break;
                
            }
            
        }else{
            
            switch (indexPath.section) {
                case 1:
                    title = @"法律协议";
                    break;
                case 2:
                    title = @"挖财隐私权政策";
                    break;
                
            }
            
        }
        
        cell.settingTitleLabel.text = title;
        
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *targetUrl = nil;
    NSString *baseUrl   = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeFinance];

    if (self.isShouldShowDeposit) {
        
        switch (indexPath.section) {
            case 1:{
                 targetUrl = self.depositUrl;
                break;
            }
                
            case 2:{
                 targetUrl = [NSString stringWithFormat:@"%@/finance/h5/uagreementlist.action?need_zinfo=1",baseUrl];
                break;
            }
                
            case 3:{
                targetUrl = [NSString stringWithFormat:@"%@/finance/h5/agreement-detail.action?id=15&navTitle=挖财隐私权政策",baseUrl];
                break;
            }
                
            
             
        }
        
    }else{
        
        switch (indexPath.section) {
            
                
            case 1:{
                 targetUrl = [NSString stringWithFormat:@"%@/finance/h5/uagreementlist.action?need_zinfo=1",baseUrl];
                break;
            }
                
            case 2:{
                targetUrl = [NSString stringWithFormat:@"%@/finance/h5/agreement-detail.action?id=15&navTitle=挖财隐私权政策",baseUrl];
                break;
            }
                
            
                
        }
        
    }
        
    [FSSDKGotoUtility openURL:targetUrl from:self];
 
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0., 0., ScreenWidth, 20.)];
    view.backgroundColor = [UIColor colorWithHex:0xF6F6F6];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100.)];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0., 0.,ScreenWidth, 0.5)];
        lineView.backgroundColor = HEXCOLOR(0xe7e7e7);
        [sectionFooterView addSubview:lineView];
        
        sectionFooterView.backgroundColor = [UIColor whiteColor];
        UILabel *hintLabel = [[UILabel alloc] init];
        hintLabel.text = @"关闭后，有精选发现更新内容时，界面下面的“发现”切换按钮不再出现红点提示";
        hintLabel.textColor = [UIColor grayColor];
        hintLabel.font = [UIFont systemFontOfSize:12];
        hintLabel.numberOfLines = 0;
        [sectionFooterView addSubview:hintLabel];
        
        [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(sectionFooterView).offset(-12);
            make.left.equalTo(sectionFooterView).offset(12);
            make.centerY.equalTo(sectionFooterView);
        }];
        return sectionFooterView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 50.;
    }
    return 0.;
}

#pragma mark - FSDepositViewModel alloc

- (FSDepositViewModel *)depositViewModel{
    if (_depositViewModel == nil) {
        _depositViewModel = [[FSDepositViewModel alloc] init];
    }
    return _depositViewModel;
}

#pragma mark - TitleWithSwitchCell Delegate
- (void)switchStateTo:(BOOL)isOn switchCell:(id)sender {
   
    [[NSUserDefaults standardUserDefaults] setObject:@(isOn) forKey:kFSDiscoverNewsSwitch];
}


- (void)setupUI {
    self.title = @"更多";
    self.view.backgroundColor = COLOR_DEFAULT_BACKGROUND;
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.backgroundView = nil;
        tableView.backgroundColor = COLOR_DEFAULT_BACKGROUND;
        tableView.rowHeight = 55;
        
        tableView.separatorColor = HEXCOLOR(0xe7e7e7);
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[FinSettingTableViewCell class] forCellReuseIdentifier:kSettingCell];
        [tableView registerClass:[TitleWithSwitchCell class] forCellReuseIdentifier:kTitleWithSwitchCell];
        [self.view addSubview:tableView];
        tableView;
    });
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_NavigationBarHeight);
        make.right.bottom.left.equalTo(self.view);
    }];
    
}
@end
