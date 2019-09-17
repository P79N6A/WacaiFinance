//
//  FSDebugSettingsViewController.m
//  FinanceApp
//
//  Created by 叶帆 on 1/12/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSDebugSettingsViewController.h"
#import "TitleAndTextFieldCell.h"
#import "EnvironmentInfo.h"
#import "FSRootViewController.h"
#import "FinNotificationManager.h"
#import "FSStatusBar.h"

#import "FSDebugURLOpenViewController.h"
#import <FLEX.h>
#import "EGOCache.h"
#import <objc/runtime.h>
#import "FSHTTPDNSWhiteListManager.h"


static NSString *const kTitleAndTextFieldCell = @"TitleAndTextFieldCell";

@interface FSDebugSettingsViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)UISegmentedControl *segmentedControl;
@property (strong, nonatomic)UIView *environmentSectionHeaderView;

@property (nonatomic)BOOL environmentHasChanged;

@end


@implementation FSDebugSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"调试选项";
    self.backButton.hidden = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_NavigationBarHeight);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
}


#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
    } else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [self cleanCookie];
            [self showAlertWithTitle:@"Cookie清理" message:@"Cookie已清理" buttonText:@"OK" style:UIAlertViewStyleDefault];
        } else if (indexPath.row == 1){
            [[EGOCache globalCache] clearCache];
            [self showAlertWithTitle:@"缓存清理" message:@"应用缓存已清理" buttonText:@"OK" style:UIAlertViewStyleDefault];
        } else if (indexPath.row == 2){
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            [self showAlertWithTitle:@"Web缓存清理" message:@"请务必自行 Kill App 确保缓存清理生效" buttonText:@"OK" style:UIAlertViewStyleDefault];
        } else if (indexPath.row == 3){
            FSDebugURLOpenViewController *URLOpenVC = [FSDebugURLOpenViewController new];
            [self.navigationController pushViewController:URLOpenVC animated:YES];
        } else if (indexPath.row == 4){
            [EnvironmentInfo sharedInstance].needPrintBILog = YES;
            [self showAlertWithTitle:@"埋点打印" message:@"埋点将随操作在屏幕顶部显示\n（App重启后失效）" buttonText:@"OK" style:UIAlertViewStyleDefault];
        } else if (indexPath.row == 5){
#ifdef DEBUG
            [[FLEXManager sharedManager] showExplorer];
#endif
            
#ifdef TestHTTPDNS
            [[FLEXManager sharedManager] showExplorer];
#endif
         
            
        } else if (indexPath.row == 6){
            [self showAppAndUserInfo];
        } else if (indexPath.row == 7){
            [self showSwitchModelInfo];
        }
    }
}

#pragma mark - TableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.01;
    if (section == 0){
        height = self.environmentSectionHeaderView.frame.size.height;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView;
    if (section == 0) {
        headerView = self.environmentSectionHeaderView;
    }
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TitleAndTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:kTitleAndTextFieldCell];
    NSString *titleLabelText = @"";
    NSString *textFieldValue = @"";
    NSInteger cellTag = 0;
    BOOL textFieldisEnable = NO;
    if (indexPath.section == 0) {
        textFieldisEnable = YES;
        if (indexPath.row == 0) {
            cellTag = 1;
            titleLabelText = @"Domain";
            textFieldValue = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeMainDomain];
        } else if (indexPath.row == 1){
            cellTag = 2;
            titleLabelText = @"RPC";
            textFieldValue = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeFinance];
        } else if (indexPath.row == 2){
            cellTag = 3;
            titleLabelText = @"ServiceWindow";
            textFieldValue = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeServiceWindow];
        } else if (indexPath.row == 3){
            cellTag = 4;
            titleLabelText = @"MsgCenter";
            textFieldValue = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeMsgCenter];
        } else if (indexPath.row == 4){
            cellTag = 5;
            titleLabelText = @"Stock";
            textFieldValue = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeStock];
        } else if (indexPath.row == 5){
            cellTag = 6;
            titleLabelText = @"ForgetPwd";
            textFieldValue = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeForgetPwd];
        } else if (indexPath.row == 6){
            cellTag = 7;
            titleLabelText = @"MemberCenter";
            textFieldValue = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeMemberCenter];
        }
    } else if (indexPath.section == 1){
        textFieldisEnable = YES;
        if (indexPath.row == 0){
            cellTag = 10;
            titleLabelText = @"CookieDomain";
            textFieldValue = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeCookieDomain];
        } else if (indexPath.row == 1){
            cellTag = 11;
            titleLabelText = @"LotusseedKey";
            textFieldValue = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeLotusseedKey];
        }
    } else if (indexPath.section == 2){
        textFieldisEnable = NO;
        if (indexPath.row == 0) {
            titleLabelText = @"Cookie";
            textFieldValue = @"清除Cookie";
            textFieldisEnable = NO;
        } else if (indexPath.row == 1){
            titleLabelText = @"EGOCache";
            textFieldValue = @"清除应用缓存";
        } else if (indexPath.row == 2){
            titleLabelText = @"WebCache";
            textFieldValue = @"清除Web缓存";
        } else if (indexPath.row == 3){
            titleLabelText = @"WebView";
            textFieldValue = @"打开指定URL";
        } else if (indexPath.row == 4){
            titleLabelText = @"BILog";
            textFieldValue = @"打印BI埋点信息";
        } else if (indexPath.row == 5){
            titleLabelText = @"Flex";
            textFieldValue = @"打开Flex调试工具";
        } else if (indexPath.row == 6){
            titleLabelText = @"BasicInfo";
            textFieldValue = @"查看App&User信息";
        } else if (indexPath.row == 7){
            titleLabelText = @"SwitchModel";
            textFieldValue = @"查看SwitchModel信息";
        }
        
    }
    cell.titleLabel.text = titleLabelText;
    cell.textField.tag = cellTag;
    cell.textField.text = textFieldValue;
    cell.textField.enabled = textFieldisEnable;
    [cell.textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numberOfRow = 0;
    if (section == 0) {
        numberOfRow = 7;
    } else if (section == 1){
        numberOfRow = 2;
    } else if (section == 2){
        numberOfRow = 8;
    }
    return numberOfRow;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
#pragma mark - UITextField Delegate
- (void)textFieldValueChanged:(UITextField *)sender{
    if (!sender.tag) {
        return;
    }
    if (sender.tag < 12) {
        [[EnvironmentInfo sharedInstance] setURLString:sender.text ofEnvironment:self.segmentedControl.selectedSegmentIndex URLType:sender.tag];
        self.environmentHasChanged = YES;
    }
}

#pragma mark - Event Response
- (void)environmentSelectedBySegmentControl{
    FSEnvironmentType type = self.segmentedControl.selectedSegmentIndex;
    [[EnvironmentInfo sharedInstance] switchEnvironmentTo:type];
    [self.tableView reloadData];
    self.environmentHasChanged = YES;
}

- (void)onBackAction:(id)sender{
    if (self.environmentHasChanged) {
        // 由于 Prism 一定要将测试包 Crash 都统计到质量报告中，只能移除切换环境后自动退出的代码。
        [[EGOCache globalCache] clearCache];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [self cleanCookie];
        [self showAlertWithTitle:@"环境配置已切换" message:@"请务必自行 Kill App 确保配置生效" buttonText:@"OK" style:UIAlertViewStyleDefault];
    } else {
        [super onBackAction:nil];
    }
}

#pragma mark - AlertView & Delegate
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonText:(NSString *)buttonText style:(UIAlertViewStyle)style{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttonText otherButtonTitles:nil, nil];
    [alertView show];
}


#pragma mark - Action
- (void)cleanCookie {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

- (void)showSwitchModelInfo {
    
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray =  nil;
//    class_copyPropertyList([WCWcbSwitchModel class], &numberOfProperties);
    NSMutableString *switchModelDes = [NSMutableString new];
    
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
        NSObject *value = nil;
//        [[WCWcbSwitchModel sharedInstance] valueForKey:name];
        NSString *desString = [NSString stringWithFormat:@"%@ : %@\n",name, value];
        [switchModelDes appendString:desString];
    }
    free(propertyArray);
    [self showAlertWithTitle:@"SwitchModel Info" message:switchModelDes buttonText:@"OK" style:UIAlertViewStyleDefault];
}


- (void)showAppAndUserInfo {
    NSString *platform = [CMAppProfile sharedInstance].mPlatform;
    NSString *appver =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *pushToken = [CMAppProfile sharedInstance].mPushIDBlock();
    NSString *mUserId = [UserInfo sharedInstance].mUserId;
    NSString *mUserUdid = [UserInfo sharedInstance].mUserUdid;
    NSString *deviceID = [CMAppProfile sharedInstance].mDeviceID;
    NSString *basicInfoString = [NSString stringWithFormat:@"Platform:%@\nAppVer:%@\nPushToken:%@\nUserID:%@\nUDID:%@\nDeviceID:%@\n", platform, appver, pushToken, mUserId, mUserUdid, deviceID];
    [[UIPasteboard generalPasteboard] setString:basicInfoString];
    [self showAlertWithTitle:@"App&User Info" message:[NSString stringWithFormat:@"%@\n******以上信息已复制到剪贴板******", basicInfoString] buttonText:@"OK" style:UIAlertViewStyleDefault];

}

#pragma mark - Getter & Setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerClass:[TitleAndTextFieldCell class] forCellReuseIdentifier:kTitleAndTextFieldCell];
        _tableView.backgroundView = nil;
        _tableView.rowHeight = 50;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    }
    return _tableView;
}


- (UISegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"开发",@"测试1",@"测试2",@"预发",@"正式", nil]];
        [_segmentedControl addTarget:self action:@selector(environmentSelectedBySegmentControl) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.selectedSegmentIndex = [[EnvironmentInfo sharedInstance] currentEnvironment];
    }
    return _segmentedControl;
}

- (UIView *)environmentSectionHeaderView{
    if (!_environmentSectionHeaderView) {
        _environmentSectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        [_environmentSectionHeaderView addSubview:self.segmentedControl];
        [self.segmentedControl makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_environmentSectionHeaderView).offset(16);
            make.right.equalTo(_environmentSectionHeaderView).offset(-16);
            make.height.equalTo(@30);
            make.centerY.equalTo(_environmentSectionHeaderView.mas_centerY);
        }];
    }
    return _environmentSectionHeaderView;
}


//- (WCWcbSwitchModel *)switchModel{
//    if (!_switchModel) {
//        _switchModel = [WCWcbSwitchModel sharedInstance];
//    }
//    return _switchModel;
//}

//- (void)setSwitchModel:(WCWcbSwitchModel *)switchModel{
//    _switchModel = switchModel;
//    [[EGOCache globalCache] setObject:_switchModel forKey:kWcbSwitchCache];
//}



@end
