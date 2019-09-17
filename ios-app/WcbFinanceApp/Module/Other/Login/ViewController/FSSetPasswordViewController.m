//
//  FinancialRegisterViewController.m
//  financial
//
//  Created by wac on 14-6-16.
//  Copyright (c) 2014年 com.wacai.licai. All rights reserved.
//

#import "FSSetPasswordViewController.h"
#import "InputTableViewCell.h"
#import "UIImage+FSUtils.h"
#import "TPKeyboardAvoidingTableView.h"
#import "FSVoiceCodeSectionFooterView.h"
#import "FSRequestManager.h"
#import "FSSetPasswordViewModel.h"
#import "EnvironmentInfo.h"
#import "FSPopupUtils.h"
#import "FSAgreementView.h"
#import "LoginRegisterSDK.h"
#import "LRCenterManager.h"
#import "FSVerificationCodeAlertView.h"
#import <CMCustomAlertView.h>
#import "FSLRRequestFactory.h"
#import "FSAgreementInfo.h"
#import "FSAgreementManager.h"
#import "FSLoginLoadingHandler.h"
#import <NeutronBridge/NeutronBridge.h>

static NSString *const kInputCellIdentifier = @"InputCellIdentifier";


@interface FSSetPasswordViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, strong) UIButton *sureButton;

@property(nonatomic, strong) FSAgreementView *agreementView;

/**
 *  通过这个对象retain cell中的 textField, 达到同时控制两个textfield的secrety状态
 */
@property (nonatomic, strong) UITextField *comfirTextField;
@property (nonatomic, strong) UIButton *sendSMSCodeButton;
@property (nonatomic, strong) FSVoiceCodeSectionFooterView *voiceCodeSectionFooterView;
@property (nonatomic, strong) FSSetPasswordViewModel *viewModel;

@property (nonatomic, strong) FSAgreementInfo *agreements;

@property (nonatomic, strong) FSLoginLoadingHandler *loadingHandler;

@end

@implementation FSSetPasswordViewController

@synthesize mTelephone;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewModel = [FSSetPasswordViewModel new];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

 

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"nav_title_set_password", nil);
    
    [self.view addSubview:self.tableView];
 
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_NavigationBarHeight);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        
    }];
    
    [self bindViewModel];
    [self fetchAgreements];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.viewModel.getSMSCodeCmd execute:nil];
    });
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UserAction skylineEvent:@"finance_wcb_setpassword_enter_page"];
    //防止从协议页面回来后也发验证码
//    if (self.sendSMSCodeButton.enabled) {
//    }
}

- (void)fetchAgreements
{
    [FSAgreementManager loadRegisterAgreements:^(FSAgreementInfo * _Nullable agreementInfo, BOOL isCache) {
        if (!agreementInfo) { return; }
        self.agreements = agreementInfo;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.agreementView updateViewWithAgreements:self.agreements];
        });
    }];
}


#pragma mark - Bind Data
- (void)bindViewModel
{
    @weakify(self);
    RAC(self.viewModel, account)         = RACObserve(self, mTelephone);
    RAC(self.viewModel, code)            = RACObserve(self, codeString);
    RAC(self.viewModel, password)        = RACObserve(self, passwordString);
    RAC(self.viewModel, confirmPassword) = RACObserve(self, confirmPasswordString);
    RAC(self.viewModel, agreeProtocol)   = RACObserve(self.agreementView.checkBtn, selected);
  
    self.viewModel.floatWindowViewModel.userRegister = YES;

    self.sureButton.rac_command = self.viewModel.registerCmd;
    self.sendSMSCodeButton.rac_command = self.viewModel.getSMSCodeCmd;
    
    
    [[self.viewModel.registerCmd.executing skip:1] subscribeNext:^(id x) {
        
        @strongify(self);
        if([x boolValue] == YES) //
        {
            NSLog(@"开始执行");
            [self.loadingHandler addLoadingWithParentView:self.view activityView:self.sureButton];
        }
        else
        {
            NSLog(@"结束执行");
            [self.loadingHandler removeLoadingWithCompletion:^{
                [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
            }];
        }
    }];
    
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
            NSString *sectionTitle = [NSString stringWithFormat:@"已向%@发送短信验证码，请注意查收", [self secrectTel]];
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
            NSString *sectionTitle = [NSString stringWithFormat:@"已向%@发送语音验证码，请注意查收", [self secrectTel]];
            [CMUIDisappearView showMessage:sectionTitle];
        }

    }];
    
    
    [[self.viewModel.registerCmd.executionSignals switchToLatest] subscribeNext:^(id x) {
        @strongify(self);
        [UserAction skylineEvent:@"finance_wcb_setpassword_ok_click" attributes:@{@"lc_result":@"1"}];
        
        [self closeView];
        [[NSNotificationCenter defaultCenter] postNotificationName:FSLoginDidFinishNotification object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:LRUserDidLoginSuccessNotification
                                                            object:nil];
        [self.viewModel.floatWindowViewModel.showPopupWindowCmd execute:nil];
    }];
    
    
    [[self.viewModel.floatWindowViewModel.showPopupWindowCmd.executionSignals switchToLatest] subscribeNext:^(RACTuple *tupleValue) {
        NSString *linkUrl = tupleValue.first;
        NSString *imageUrl = tupleValue.second;
        NSString *eventId = tupleValue.fourth;
        
        
        NSDictionary *attributes = @{@"lc_banner_id": eventId ?: @"",
                                     @"lc_name":@"",
                                     @"lc_banner_url":imageUrl ?: @"",
                                     @"lc_jump_url":linkUrl ?: @""
                                     };
        [UserAction skylineEvent:@"finance_wcb_homepopup_enter_page" attributes:attributes];
 
        [[FSPopupUtils sharedInstance] showImageUrl:imageUrl
                                            linkUrl:linkUrl
                                            eventId:eventId clickBlock:^{
                                                
                                                                                                     [UserAction skylineEvent:@"finance_wcb_homepopup_banner_click" attributes:attributes];
                                                
                                            } closeBlock:^{
                                                
                                                                                                     [UserAction skylineEvent:@"finance_wcb_homepopup_shutdown_click" attributes:attributes];
                                                
                                            }];
    }];
    
    [[RACSignal merge:@[self.viewModel.registerCmd.errors,
                        self.viewModel.getSMSCodeCmd.errors,
                        self.viewModel.getVoiceCodeCmd.errors]]
     subscribeNext:^(NSError *error) {
         [CMUIDisappearView showMessage:[error localizedDescription]];
         [UserAction skylineEvent:@"finance_wcb_setpassword_ok_click" attributes:@{@"lc_result":@"0"}];
     }];
    
    [self checkBtnStatus];
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

- (void)checkBtnStatus
{
    if(self.codeString.length > 0 &&
       self.passwordString.length > 0 &&
       self.confirmPasswordString.length  > 0 && self.agreementView.accepted)
    {
        //修改颜色
        [_sureButton setBackgroundImage:[UIImage fs_imageWithColor:HEXCOLOR(0xD95149)] forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage fs_imageWithColor:HEXCOLOR(0xB8453F)] forState:UIControlStateHighlighted];
        [_sureButton setBackgroundImage:[UIImage fs_imageWithColor:RGBA(0xD9, 0x51, 0x49, 0.5)] forState:UIControlStateDisabled];
    }
    else
    {
        UIColor *color = RGBA(0xD9, 0x51, 0x49, 0.5);
        
        [_sureButton setBackgroundImage:[UIImage fs_imageWithColor:color] forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage fs_imageWithColor:color] forState:UIControlStateHighlighted];
        [_sureButton setBackgroundImage:[UIImage fs_imageWithColor:color] forState:UIControlStateDisabled];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kInputCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    @weakify(self);
    @weakify(cell);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.sendSMSCodeButton = cell.rightButton;
            cell.iconImageView.image = [UIImage imageNamed:@"icon_code"];
            cell.inputTextField.secureTextEntry = NO;
            cell.rightButton.hidden = NO;
            [cell.rightButton setTitle:@"重发验证码" forState:UIControlStateNormal];
            cell.inputTextField.placeholder = @"请输入6位数字验证码";
            cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell startTimer];
            cell.buttonBlock = ^{
                @strongify(self);
                @strongify(cell);
                
                [UserAction skylineEvent:@"finance_wcb_setpassword_verificationcode_click"];
                
                
                [self.viewModel.getSMSCodeCmd execute:nil];
                [cell startTimer];
            };
            
            cell.textFieldBlock = ^{
                @strongify(self);
                @strongify(cell);
                
                if ([cell.inputTextField.text length] > 6) {
                    cell.inputTextField.text = [cell.inputTextField.text substringWithRange:NSMakeRange(0, 6)];
                }
                self.codeString = cell.inputTextField.text;
                [self checkBtnStatus];
            };
            [cell.inputTextField becomeFirstResponder];

        }
    } else {
        if (indexPath.row == 0) {
            cell.iconImageView.image = [UIImage imageNamed:@"icon_password"];
            cell.rightButton.hidden = YES;
            [cell.rightButton setImage:[UIImage imageNamed:@"icon_eye_2"] forState:UIControlStateNormal];
            [cell.rightButton setImage:[UIImage imageNamed:@"icon_eye_1"] forState:UIControlStateSelected];
            cell.inputTextField.secureTextEntry = YES;
            cell.inputTextField.placeholder = @"6-16位数字、字母或字符";
            cell.inputTextField.clearButtonMode = UITextFieldViewModeNever;
            cell.buttonBlock = ^{
                @strongify(self);
                @strongify(cell);
                cell.inputTextField.secureTextEntry = !cell.inputTextField.secureTextEntry;
                self.comfirTextField.secureTextEntry = !self.comfirTextField.secureTextEntry;
                cell.rightButton.selected = !cell.rightButton.selected;
                [self.view endEditing:YES];
            };
            
            cell.textFieldBlock = ^{
                @strongify(self);
                @strongify(cell);
                self.passwordString = cell.inputTextField.text;
                if ([cell.inputTextField.text length] > 0) {
                    cell.rightButton.hidden = NO;
                } else {
                    cell.rightButton.hidden = YES;
                }
                
                [self checkBtnStatus];
            };
            
        } else if (indexPath.row == 1) {
            self.comfirTextField = cell.inputTextField;
            cell.iconImageView.image = nil;

            cell.rightButton.hidden = YES;
            cell.inputTextField.clearButtonMode = UITextFieldViewModeNever;
            cell.inputTextField.secureTextEntry = YES;
            cell.inputTextField.placeholder = @"确认密码";
            cell.textFieldBlock = ^{
                @strongify(self);
                @strongify(cell);
                self.confirmPasswordString = cell.inputTextField.text;
                
                [self checkBtnStatus];
            };

        }
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    } else {
        return 20;
    }
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
    if (section == 0) {
        sectionTitle = [NSString stringWithFormat:@"已向%@发送短信验证码，请注意查收", [self secrectTel]];
    } else {
        sectionTitle = @"设置密码";
    }
    
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

        self.voiceCodeSectionFooterView = [[FSVoiceCodeSectionFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        [self.voiceCodeSectionFooterView setVoiceButtonEnable:YES];
        @weakify(self);
        self.voiceCodeSectionFooterView.buttonActonBlock = ^{
            NSLog(@"send voice code");
            
            [UserAction skylineEvent:@"finance_wcb_setpassword_verificationspeech_click"];
            
            UIAlertView *voiceCodeAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                         message:@"系统将拨打您的电话，播报语音验证码"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"取消"
                                                               otherButtonTitles:@"确认", nil];
            [voiceCodeAlertView show];
            
            [[voiceCodeAlertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *index) {
                @strongify(self);
                if ([index integerValue] == 1) {
                    [self.viewModel.getVoiceCodeCmd execute:nil];
                }
            }];
        };
        
        return self.voiceCodeSectionFooterView;
    } else {
        return nil;
    }
}


#pragma mark - Event

- (void)closeView {
    [self.view endEditing:YES];
    [self.navigationController.topViewController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Helper method
- (NSString*)secrectTel {
    return [mTelephone fs_isValidPhoneNumber] ? [mTelephone CM_getsecretString] : @"";
}

#pragma mark - Navigation Back
- (void)onBackAction:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注册是投资理财第一步，注册即获好礼，您是否选择放弃～" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UserAction skylineEvent:@"finance_wcb_registerpopup_abandon_click" attributes:@{@"lc_source_id":@"SetPassword"}];
        
        [super onBackAction:sender];
    }];
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"继续注册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {        
         [UserAction skylineEvent:@"finance_wcb_registerpopup_continue_click" attributes:@{@"lc_source_id":@"SetPassword"}];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:registerAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}



#pragma mark - Getter and Setter
- (TPKeyboardAvoidingTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.rowHeight = 50;
        [_tableView registerClass:[InputTableViewCell class] forCellReuseIdentifier:kInputCellIdentifier];
        _tableView.backgroundView = nil;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_DEFAULT_BACKGROUND;

        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];
        footerView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = footerView;
        _tableView.separatorColor = HEXCOLOR(0xe7e7e7);
        
        
        [footerView addSubview:self.agreementView];
        __weak __typeof(self)weakSelf = self;
        
        self.agreementView.checkBlock = ^(BOOL status) {

            [weakSelf checkBtnStatus];
        };
        
        [self.agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(30);
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

- (UIButton *)sureButton
{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.layer.cornerRadius = 3;
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton setTitle:NSLocalizedString(@"btn_sure", nil) forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureButton setBackgroundImage:[UIImage fs_imageWithColor:HEXCOLOR(0xD95149)] forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage fs_imageWithColor:HEXCOLOR(0xB8453F)] forState:UIControlStateHighlighted];
        
        [_sureButton setBackgroundImage:[UIImage fs_imageWithColor:RGBA(0xD9, 0x51, 0x49, 0.5)] forState:UIControlStateDisabled];
    }
    
    return _sureButton;
}


- (FSAgreementView *)agreementView{
    if (!_agreementView) {
        _agreementView = [[FSAgreementView alloc] init];
        _agreementView.backgroundColor = [UIColor clearColor];
    }
    return _agreementView;
}

- (FSLoginLoadingHandler *)loadingHandler
{
    if(!_loadingHandler)
    {
        _loadingHandler = [[FSLoginLoadingHandler alloc] init];
    }
    
    return _loadingHandler;
}


@end
