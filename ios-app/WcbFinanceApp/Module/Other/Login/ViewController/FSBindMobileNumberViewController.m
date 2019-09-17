//
//  BindTelNumberViewController.m
//  financial
//
//  Created by wac on 14-6-18.
//  Copyright (c) 2014年 com.wacai.licai. All rights reserved.
//

#import "FSBindMobileNumberViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "InputTableViewCell.h"
#import "FSVoiceCodeSectionFooterView.h"
#import "FSBindeMobileNumberViewModel.h"
#import <LoginRegisterSDK.h>
#import "FSAgreementView.h"
#import "FSVerificationCodeAlertView.h"
#import <CMCustomAlertView.h>
#import "FSLRRequestFactory.h"
#import "FSAgreementInfo.h"
#import "FSAgreementManager.h"
#import <NeutronBridge/NeutronBridge.h>

static NSString *const kInputCellIdentifier = @"InputCellIdentifier";


@interface FSBindMobileNumberViewController ()
<
UITextFieldDelegate,
UITableViewDataSource,
UITableViewDelegate
>


@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, copy) NSString *phoneString;
@property (nonatomic, copy) NSString *codeString;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) FSVoiceCodeSectionFooterView *voiceCodeSectionFooterView;
@property (nonatomic, strong) FSBindeMobileNumberViewModel *viewModel;

@property(nonatomic, strong) FSAgreementView *agreementView;
@property(nonatomic, strong) FSAgreementInfo *agreements;

@end

@implementation FSBindMobileNumberViewController


#pragma mark - Life Cycle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewModel = [FSBindeMobileNumberViewModel new];
        _shouldClearnUserInfoWhenBack = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"nav_title_bind_phone", nil);

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_NavigationBarHeight);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        
    }];
    
    [self bindViewModel];
    [self p_fetchAgreements];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UserAction skylineEvent:@"finance_wcb_bindmobile_enter_page"];
}




- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)p_fetchAgreements
{
    [FSAgreementManager loadRegisterAgreements:^(FSAgreementInfo * _Nullable agreementInfo, BOOL isCache) {
        if (!agreementInfo) { return; }
        self.agreements = agreementInfo;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.agreementView updateViewWithAgreements:self.agreements];
        });
    }];
}

- (void)p_checkBtnStatus
{
    //color
    if(self.phoneString.length > 0 &&
       self.codeString.length > 0 &&
       self.agreementView.accepted)
    {
        //修改颜色
        [_sureButton setBackgroundImage:[UIImage fs_imageWithColor:HEXCOLOR(0xD95149)] forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage fs_imageWithColor:HEXCOLOR(0xB8453F)] forState:UIControlStateHighlighted];
        [_sureButton setBackgroundImage:[UIImage fs_imageWithColor:RGBA(0xD9, 0x51, 0x49, 0.5)] forState:UIControlStateDisabled];
    }
    else
    {
        UIColor *grayColor = RGBA(0xD9, 0x51, 0x49, 0.5);
        [_sureButton setBackgroundImage:[UIImage fs_imageWithColor:grayColor] forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage fs_imageWithColor:grayColor] forState:UIControlStateHighlighted];
        [_sureButton setBackgroundImage:[UIImage fs_imageWithColor:grayColor] forState:UIControlStateDisabled];
    }
}


#pragma mark - Bind Data
- (void)bindViewModel
{
    @weakify(self);
    RAC(self.viewModel, mobile) = RACObserve(self, phoneString);
    RAC(self.viewModel, code) = RACObserve(self, codeString);
    RAC(self.viewModel, acceptAgreements) = RACObserve(self.agreementView.checkBtn, selected);
    
    self.sureButton.rac_command = self.viewModel.bindMobileCmd;
    
    [[self.viewModel.getSMSCodeCmd.executionSignals switchToLatest] subscribeNext:^(id x) {
        @strongify(self);
        
        id json = x;
        if(json[@"tips"])
        {
            CGFloat delayOfImageVercodeAlertView = 0.f;
            NSString *errorCode = [json objectForKey:@"code"];
            
            // 后端错误码.
            //   2899 图形验证码输入有误
            //   2900 单个手机号5分钟内3次以上请求（包含第三次）或者单个ip2分钟内3次以上请求（包含第三次），需要输入图形验证码。
            if ([errorCode isEqualToString:@"2899"] || [errorCode isEqualToString:@"2900"]) {
                delayOfImageVercodeAlertView = 1.0f;
                [CMUIDisappearView showMessage:[json objectForKey:@"error"]];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayOfImageVercodeAlertView * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self showSmsVercodeAlertViewWithTips:json[@"tips"]];
            });
            
            return;
        }
        
        NSString *errorCode = [json objectForKey:@"code"];
        if(![errorCode isEqualToString:@"0"])
        {
            [CMUIDisappearView showMessage:[json objectForKey:@"error"]];
        }
        else
        {
            NSString *sectionTitle = [NSString stringWithFormat:@"已向%@发送短信验证码，请注意查收", self.phoneString];
            [CMUIDisappearView showMessage:sectionTitle];
        }
    }];
    
    
    [[self.viewModel.getVoiceCodeCmd.executionSignals switchToLatest] subscribeNext:^(id x) {
        @strongify(self);
        
        id json = x;
        if(json[@"tips"])
        {
            CGFloat delayOfImageVercodeAlertView = 0.f;
            NSString *errorCode = [json objectForKey:@"code"];
            
            // 后端错误码.
            //   2899 图形验证码输入有误
            //   2900 单个手机号5分钟内3次以上请求（包含第三次）或者单个ip2分钟内3次以上请求（包含第三次），需要输入图形验证码。
            if ([errorCode isEqualToString:@"2899"] || [errorCode isEqualToString:@"2900"]) {
                delayOfImageVercodeAlertView = 1.0f;
                [CMUIDisappearView showMessage:[json objectForKey:@"error"]];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayOfImageVercodeAlertView * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self showVoiceVercodeAlertViewWithTips:json[@"tips"]];
            });
            
            return;
        }
        
        NSString *errorCode = [json objectForKey:@"code"];
        if(![errorCode isEqualToString:@"0"])
        {
            [CMUIDisappearView showMessage:[json objectForKey:@"error"]];
        }
        else
        {
            NSString *sectionTitle = [NSString stringWithFormat:@"已向%@发送语音验证码，请注意查收", self.phoneString];
            [CMUIDisappearView showMessage:sectionTitle];
        }
        
    }];
    
    
    [[self.viewModel.bindMobileCmd.executionSignals switchToLatest] subscribeNext:^(id x) {
        
        [UserAction skylineEvent:@"finance_wcb_bindmobile_ok_click" attributes:@{@"lc_result":@"1"}];
        
        @strongify(self);
        [self closeView];
        [[NSNotificationCenter defaultCenter] postNotificationName:FSLoginDidFinishNotification object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:LRUserDidLoginSuccessNotification
 object:nil];

    }];
    
    
    
    [[RACSignal merge:@[self.viewModel.bindMobileCmd.errors,
                        self.viewModel.getSMSCodeCmd.errors,
                        self.viewModel.getVoiceCodeCmd.errors]]
     subscribeNext:^(NSError *error) {
         
         [UserAction skylineEvent:@"finance_wcb_bindmobile_ok_click" attributes:@{@"lc_result":@"0"}];
         [CMUIDisappearView showMessage:[error localizedDescription]];
     }];
}

//短信
- (void)showSmsVercodeAlertViewWithTips:(NSString *)tips
{
    FSVerificationCodeAlertView *alertView = [[FSVerificationCodeAlertView alloc] init];
    alertView.parentView = self.view;
    alertView.tips = tips;
    
    @weakify(alertView);
    @weakify(self);
    alertView.onButtonTouchUpInside = ^(CMCustomAlertView *unused, int buttonIndex) {
        
        @strongify(alertView);
        @strongify(self);
        
        if(buttonIndex != 1)
        {
            return;
        }
        
        NSString *imgVercode = alertView.imageVercode;
        self.viewModel.smsImageVerCode = imgVercode;
        self.viewModel.smsTips = tips;
        [self.viewModel.getSMSCodeCmd execute:nil];
        
        [unused close];
    };
    
    [alertView show];
}

//语音
- (void)showVoiceVercodeAlertViewWithTips:(NSString *)tips
{
    FSVerificationCodeAlertView *alertView = [[FSVerificationCodeAlertView alloc] init];
    alertView.parentView = self.view;
    alertView.tips = tips;
    
    @weakify(alertView);
    @weakify(self);
    alertView.onButtonTouchUpInside = ^(CMCustomAlertView *unused, int buttonIndex) {
        
        @strongify(alertView);
        @strongify(self);
        
        if(buttonIndex != 1)
        {
            return;
        }
        
        NSString *imgVercode = alertView.imageVercode;
        self.viewModel.voiceImageVerCode = imgVercode;
        self.viewModel.voiceTips = tips;
        [self.viewModel.getVoiceCodeCmd execute:nil];
        [unused close];
    };
    
    [alertView show];
}



#pragma mark - Delegate
#pragma mark UITableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kInputCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak InputTableViewCell *weakCell = cell;
    __weak FSBindMobileNumberViewController *weakSelf = self;
    
    if (indexPath.row == 0) {
        cell.iconImageView.image = [UIImage imageNamed:@"icon_phone"];
        cell.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.inputTextField.placeholder = @"请输入手机号";
        cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textFieldBlock = ^{
            if ([weakCell.inputTextField.text length] > 11) {
                weakCell.inputTextField.text = [weakCell.inputTextField.text substringWithRange:NSMakeRange(0, 11)];
            }
            weakSelf.phoneString = weakCell.inputTextField.text;
            [weakSelf p_checkBtnStatus];
        };
        [cell.inputTextField becomeFirstResponder];
    } else if (indexPath.row == 1) {
        cell.iconImageView.image = [UIImage imageNamed:@"icon_code"];
        cell.inputTextField.secureTextEntry = NO;
        cell.rightButton.hidden = NO;
        [cell.rightButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        cell.inputTextField.placeholder = @"请输入6位数字验证码";
        cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        cell.buttonBlock = ^{
            [UserAction skylineEvent:@"finance_wcb_bindmobile_verificationcode_click"];
            
            if ([weakSelf.phoneString length] != 11) {
                NSString* errorInfo = NSLocalizedString(@"error_invalid_phone_number", nil);
                [CMUIDisappearView showMessage:errorInfo];
            } else {
                [weakSelf.viewModel.getSMSCodeCmd execute:nil];
                [weakCell startTimer];
            }
        };
        
        cell.textFieldBlock = ^{
            
            if ([weakCell.inputTextField.text length] > 6) {
                weakCell.inputTextField.text = [weakCell.inputTextField.text substringWithRange:NSMakeRange(0, 6)];
            }
            weakSelf.codeString = weakCell.inputTextField.text;
            [weakSelf p_checkBtnStatus];
            
        };
    }
    
    
    
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    } else {
        return 0.01;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [NSString new];
    sectionTitle = @"请绑定手机号码以接受资金信息";

    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    sectionView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, self.view.frame.size.width, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.text = sectionTitle;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = HEXCOLOR(0x444546);
    [sectionView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView).offset(16);
        make.bottom.equalTo(sectionView.mas_bottom).offset(-10);
    }];
    
    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        __weak FSBindMobileNumberViewController *weakSelf = self;
        self.voiceCodeSectionFooterView = [[FSVoiceCodeSectionFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        [self.voiceCodeSectionFooterView setVoiceButtonEnable:YES];
        self.voiceCodeSectionFooterView.buttonActonBlock = ^{
            
            if ([weakSelf.phoneString length] != 11) {
                NSString* errorInfo = NSLocalizedString(@"error_invalid_phone_number", nil);
                [CMUIDisappearView showMessage:errorInfo];
                
                return;
            }
            
            NSLog(@"send voice code");
            
            [UserAction skylineEvent:@"finance_wcb_bindmobile_verificationspeech_click"];
            
            UIAlertView *voiceCodeAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"系统将拨打您的电话，播报语音验证码" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            
            [voiceCodeAlertView show];
            
            [[voiceCodeAlertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *index) {
                if ([index integerValue] == 1)
                {
                    [weakSelf.viewModel.getVoiceCodeCmd execute:nil];
                }
            }];
        };
        
        return self.voiceCodeSectionFooterView;
    } else {
        return nil;
    }
}


#pragma mark - Events



- (void)onBackAction:(id)sender
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注册是投资理财第一步，注册即获好礼，您是否选择放弃～" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self logCancelEvent];
        [self.view endEditing:YES];
        if (self.shouldClearnUserInfoWhenBack) {
            [USER_INFO logout];
        }
        [super onBackAction:sender];
    }];
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"继续注册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self logContinueEvent];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:registerAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)logCancelEvent {
    LRThirdLoginWay loginWay = [LoginRegisterSDK loginWay];
    
    [UserAction skylineEvent:@"finance_wcb_registerpopup_abandon_click" attributes:@{@"lc_source_id":@"Binding"}];
}

- (void)logContinueEvent {
    LRThirdLoginWay loginWay = [LoginRegisterSDK loginWay];
    
    [UserAction skylineEvent:@"finance_wcb_registerpopup_continue_click" attributes:@{@"lc_source_id":@"Binding"}];
}

- (void)closeView {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{}];
}



#pragma mark - Getter and Setter
- (TPKeyboardAvoidingTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.rowHeight = 50;
        [_tableView registerClass:[InputTableViewCell class] forCellReuseIdentifier:kInputCellIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = HEXCOLOR(0xe7e7e7);

        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];
        footerView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = footerView;
        
        
        
        [footerView addSubview:self.agreementView];
        __weak __typeof(self)weakSelf = self;
        self.agreementView.checkBlock = ^(BOOL status) {
            [weakSelf p_checkBtnStatus];
        };
        [self.agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(20);
        }];
        
        [footerView addSubview:self.sureButton];
        [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.top.equalTo(self.agreementView.mas_bottom).offset(13);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(48);
        }];
        
    
    }
    
    return _tableView;
}
- (FSAgreementView *)agreementView{
    if (!_agreementView) {
        _agreementView = [[FSAgreementView alloc] init];
        _agreementView.backgroundColor = [UIColor clearColor];
    }
    return _agreementView;
}

- (UIButton *)sureButton
{
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _sureButton.layer.cornerRadius = 3;
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton setTitle:NSLocalizedString(@"btn_sure", nil) forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
 
        [_sureButton setBackgroundImage:[UIImage fs_imageWithColor:HEXCOLOR(0xD95149)] forState:UIControlStateNormal];
        
        UIColor *grayColor = RGBA(0xD9, 0x51, 0x49, 0.5);
        
        [_sureButton setBackgroundImage:[UIImage fs_imageWithColor:grayColor] forState:UIControlStateDisabled];
    }
    
    return _sureButton;
}



@end
