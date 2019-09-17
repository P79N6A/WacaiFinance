//
//  FSPasswordManageViewController.m
//  FinanceApp
//
//  Created by 叶帆 on 2/18/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSPasswordManageViewController.h"
#import "TitleWithSwitchCell.h"
#import "FinSettingTableViewCell.h"
#import "LRPersonalCenterViewController.h"
#import "FSGotoUtility.h"
#import "FSStringUtils.h"
#import "FSTouchIDHelper.h"
#import "LRCenterManager.h"
#import "FSSubTitleAndDetailCell.h"
#import "FSPasswordManageViewController+FSHelper.h"

#import "FSBankAccountEntranceRequest.h"
#import "FSBankAccountEntranceModel.h"
#import "FSBankAccountEntranceViewModel.h"
#import <YYModel/YYModel.h>

static NSString *const kFinSettingTableViewCell = @"FinSettingTableViewCell";
static NSString *const kFSSubTitleAndDetailCell = @"FSSubTitleAndDetailCell";

typedef NS_ENUM(NSInteger, FSSectionType) {
    FSSectionTypeWacaiBaoling = 0,
    FSSectionTypeBankPassword,
    FSSectionTypeGestureAuth,
    FSSectionTypeBiometricsAuth,
    FSSectionTypeModifyWacaiPassword,
};

@interface FSPasswordManageViewController ()<UITableViewDelegate, UITableViewDataSource, TitleWithSwitchCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) FSBankAccountEntranceViewModel *bankAccountEntranceviewModel;

@end

@implementation FSPasswordManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码管理";
    self.bankAccountEntranceviewModel = [[FSBankAccountEntranceViewModel alloc] init];
    self.view.backgroundColor = COLOR_DEFAULT_BACKGROUND;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_NavigationBarHeight);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestBankAccountInfo];
}

#pragma mark - tableView related
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == FSSectionTypeBankPassword) {
        return self.bankAccountEntranceviewModel.shouldShow ? 1 : 0;
    } else if (section == FSSectionTypeGestureAuth) {
        return 2;
    } else if (section == FSSectionTypeBiometricsAuth) {
        return [FSTouchIDHelper isDeviceSupported] ? 1 : 0;
    } else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == FSSectionTypeWacaiBaoling) {
        FSSubTitleAndDetailCell *cell = [_tableView dequeueReusableCellWithIdentifier:kFSSubTitleAndDetailCell];
        cell.mTitleLabel.text = @"挖财宝令";
        cell.mSubtitleLabel.text = @"挖财平台的交易核验密码";
        return cell;
    } else if (indexPath.section == FSSectionTypeBankPassword) {
        FSSubTitleAndDetailCell *cell = [_tableView dequeueReusableCellWithIdentifier:kFSSubTitleAndDetailCell];
        cell.mTitleLabel.text = @"银行存管账户交易密码";
        cell.mSubtitleLabel.text = @"用于网贷充值、投资和提现等";
        cell.mDetailLabel.text = self.bankAccountEntranceviewModel.stateText;
        cell.mDetailLabel.textColor = self.bankAccountEntranceviewModel.stateColor;
        cell.hidden = !self.bankAccountEntranceviewModel.shouldShow;
        return cell;
    } else if (indexPath.section == FSSectionTypeGestureAuth){
        if (indexPath.row == 0) {
            TitleWithSwitchCell *cell = [TitleWithSwitchCell cellWithTitle:@"手势密码"
                                                                  subTitle:NSLocalizedString(@"tips_gesture_password", nil)
                                                               switchState:[self hasSetGesture]
                                                                  delegate:self];
            cell.tag = FSSectionTypeGestureAuth;
            if (![self hasSetGesture]) {
              cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, ScreenWidth);
            }
            return cell;
        } else {
            FinSettingTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:kFinSettingTableViewCell];
            cell.settingTitleLabel.text = @"修改手势密码";
            [cell titleToSuper];
            cell.hidden = ![self hasSetGesture];
            return cell;
        }
     } else if (indexPath.section == FSSectionTypeBiometricsAuth) {
         TitleWithSwitchCell *cell = [TitleWithSwitchCell cellWithTitle:FS_iPhoneX ? @"Face ID" : @"Touch ID"
                                                               subTitle:FS_iPhoneX ? @"设置手势密码，即可启用面容解锁" : @"设置手势密码，即可启用指纹解锁"
                                                            switchState:[FSTouchIDHelper isTouchIDOfAppOn]
                                                               delegate:self];
         cell.tag = FSSectionTypeBiometricsAuth;
         cell.mSwitch.enabled = [self shouldEnableBiometricsAuthSwitch];
         cell.hidden = ![FSTouchIDHelper isDeviceSupported];
         return cell;
     } else if (indexPath.section == FSSectionTypeModifyWacaiPassword){
        FinSettingTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:kFinSettingTableViewCell];
        cell.settingTitleLabel.text = @"修改登录密码";
        [cell titleToSuper];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == FSSectionTypeWacaiBaoling) {
        [self onClickWacaiBaoling];
    } else if (indexPath.section == FSSectionTypeBankPassword) {
        
        [self onClickBankPassword:self.bankAccountEntranceviewModel.pwdUrl];
        
    } else if (indexPath.section == FSSectionTypeGestureAuth) {
        if (indexPath.row == 1) {
            [self onModifyGesture];
        }
    } else if (indexPath.section == FSSectionTypeBiometricsAuth){
        if ([FSTouchIDHelper checkTouchIDStatusOfSystem] != FSTouchIDStatusSystemAvailable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:FS_iPhoneX ? @"请开启系统设置中的\n“Face ID与密码": @"请开启系统设置中的\n“Touch ID与密码”" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    } else if (indexPath.section == FSSectionTypeModifyWacaiPassword){
        if (indexPath.row == 0) {
            [self onModifyPassword];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat detailRowHeight = 64;
    CGFloat simpleRowHeight = 55;
    if (indexPath.section == FSSectionTypeBankPassword) {
        return self.bankAccountEntranceviewModel.shouldShow ? detailRowHeight : CGFLOAT_MIN;
    } else if (indexPath.section == FSSectionTypeGestureAuth) {
        if (indexPath.row == 1) {
            return [self hasSetGesture] ? simpleRowHeight : CGFLOAT_MIN;
        } else {
            return detailRowHeight;
        }
    } else if (indexPath.section == FSSectionTypeBiometricsAuth) {
        return [FSTouchIDHelper isDeviceSupported] ? detailRowHeight : CGFLOAT_MIN;
    } else if (indexPath.section == FSSectionTypeModifyWacaiPassword) {
        return simpleRowHeight;
    } else {
        return detailRowHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat defaultHeight = 12;
    if (section == FSSectionTypeBiometricsAuth) {
        return [FSTouchIDHelper isDeviceSupported] ? defaultHeight : CGFLOAT_MIN;
    } else if (section == FSSectionTypeBankPassword) {
        return self.bankAccountEntranceviewModel.shouldShow ? defaultHeight : CGFLOAT_MIN;
    }
    return defaultHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 12)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - getter & setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[FinSettingTableViewCell class] forCellReuseIdentifier:kFinSettingTableViewCell];
        [_tableView registerClass:[FSSubTitleAndDetailCell class] forCellReuseIdentifier:kFSSubTitleAndDetailCell];
        _tableView.sectionHeaderHeight = CGFLOAT_MIN;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = HEXCOLOR(0xe7e7e7);
    }
    return _tableView;
}

#pragma mark - TitleWithSwitchCellDelegate
- (void)switchStateTo:(BOOL)isOn switchCell:(TitleWithSwitchCell *)sender{
    if (sender.tag == FSSectionTypeGestureAuth) {
 
        [FSGotoUtility gotoGestureLockViewController:self.navigationController
                                                type: isOn ? FSGestureLockTypeSet : FSGestureLockTypeClose
                                            animated:YES];
    } else if (sender.tag == FSSectionTypeBiometricsAuth) {
        if (isOn) {
            [FSTouchIDHelper switchTouchIDOfAppOn];
        } else {
            [FSTouchIDHelper switchTouchIDOfAppOff];
        }
    }
  
}

- (void)requestBankAccountInfo {
    FSBankAccountEntranceRequest *request = [[FSBankAccountEntranceRequest alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof CMBaseRequest * _Nonnull request) {
        NSDictionary *responseDic = [request.responseJSONObject fs_objectMaybeNilForKey:@"data"
                                                                                ofClass:[NSDictionary class]];
        FSBankAccountEntranceModel *model = [FSBankAccountEntranceModel yy_modelWithJSON:responseDic];
        if (model) {
            
            self.bankAccountEntranceviewModel = [self convertViewModelOfBankAccountEntranceModel:model];
            [self.bankAccountEntranceviewModel saveData];
            
            [self.tableView reloadData];
        }
    } failure:^(__kindof CMBaseRequest * _Nonnull request) {
        
    }];
}

@end
