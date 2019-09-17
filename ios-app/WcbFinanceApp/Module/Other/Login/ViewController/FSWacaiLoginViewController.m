//
//  WacaiLoginViewController.m
//  financial
//
//  Created by wac on 14-6-18.
//  Copyright (c) 2014年 com.wacai.licai. All rights reserved.
//



#import "FSWacaiLoginViewController.h"
#import "FSBindMobileNumberViewController.h"
#import "FSLoginInputCell.h"
#import "UIImage+FSUtils.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>
#import "FSLoginHeaderView.h"
#import "MD5.h"
#import "EnvironmentInfo.h"
#import "FSEnterPasswordViewModel.h"
#import "LRHistoryUserManager.h"
#import "UIButton+WebCache.h"
#import <MBProgressHUD.h>
#import "FSEnterMobileNumberViewController.h"
#import "FSAgreementView.h"
#import "FSLRRequestFactory.h"
#import "FSLoginLoadingHandler.h"
#import <NeutronBridge/NeutronBridge.h>
#import "FSOriginalLoginViewController.h"
#import "UITableViewCell+FSBase.h"
#import "FSLoginForgetBtnCell.h"
#import "FSLoginButtonCell.h"
#import "FSThirdButtonCell.h"
#import "FSLoginViewModel.h"
#import "FSAgreementViewCell.h"
#import "FSSpaceCell.h"
#import "FSSignupConfig.h"
#import <FSHiveConfig/FSHCManager.h>
#import "FSAgreementManager.h"
#import "FSAgreementInfo.h"
#import <i-Finance-Library/FSSDKGotoUtility.h>

typedef NS_ENUM(NSUInteger, FSLoginCellType) {
    FSLoginCellTypeAccount,
    FSLoginCellTypePassword,
    FSLoginCellTypeVerifyCode,
    FSLoginCellTypeForgetPassword,
    FSLoginCellTypeLoginBtn,
    FSLoginCellTypeAgreements,
    FSLoginCellTypeThirdLogin,
    FSLoginCellTypeSpace,
};

@interface FSWacaiLoginViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton                   *loginButton;
@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;

@property (nonatomic, copy  ) NSString                    *loginName;
@property (nonatomic, copy  ) NSString                    *loginPassword;
@property (nonatomic, copy  ) NSString                    *loginPhone; //老用户通过注册登录传入

@property (nonatomic, strong) FSEnterPasswordViewModel    *viewModel;
@property (nonatomic, strong) FSLoginViewModel            *thirdLoginViewModel;

@property (nonatomic, strong) FSAgreementInfo *agreements;
@property (nonatomic, strong) FSLoginLoadingHandler *loadingHandler;

@property (nonatomic, assign) FSLoginViewCloseType closeType;
@property (nonatomic, strong) NSArray *sourceArray;

@property (nonatomic, strong) FSLoginButtonCell *loginBtnCell;
@property (nonatomic, strong) FSAgreementView   *agreementView;

@property (nonatomic, assign) BOOL needEdit;

@property (nonatomic, strong) FSSignupConfig *signupConfig;

@end

@implementation FSWacaiLoginViewController

#pragma mark - Life Cycle

- (instancetype)init {
    return [self initWithLoginPhone:nil];
}

- (instancetype)initWithLoginPhone:(NSString *)loginPhone {
    self = [super init];
    if (self) {
        [self setupViewModel];
        self.loginPhone = loginPhone;
    }
    return self;
}

- (instancetype)initWithLoginPhone:(NSString *)loginPhone
                         closeType:(FSLoginViewCloseType)type
                          needEdit:(BOOL)needEdit
{
    self = [super init];
    if(self)
    {
        [self setupViewModel];
        self.loginPhone = loginPhone;
        _closeType = type;
        _needEdit = needEdit;
    }
    return self;
}

- (void)setupViewModel
{
    _viewModel = [FSEnterPasswordViewModel new];
    _thirdLoginViewModel = [FSLoginViewModel new];
    _thirdLoginViewModel.fromRegistration = NO;
}

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *referURL = SafeString(self.comeFrom);
    NSDictionary *dic = @{@"lc_refer_url":referURL};
        
    [UserAction skylineEvent:@"finance_wcb_loginwacai_enter_page" attributes:dic];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self customNavigationBar];
    [self.view addSubview:self.tableView];
  
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_NavigationBarHeight);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    self.signupConfig = [HIVE_CONFIG localCacheOfKey:[FSSignupConfig configKey] class:[FSSignupConfig class]];

    __weak __typeof(self)weakSelf = self;
    [HIVE_CONFIG fetchKey:[FSSignupConfig configKey] class:[FSSignupConfig class] completion:^(BOOL isSuccess, id  _Nullable object) {
        if (isSuccess) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.signupConfig = object;
        }
    }];

    [self reloadTableView];
    [self p_fetchAgreements];
    [self bindViewModel];
    [self bindThirdLoginViewModel];
    
}


#pragma mark - NavigationBar
- (void)customNavigationBar
{
    if(self.closeType == FSLoginViewCloseTypePop)
    {
        self.rightButton.hidden = YES;
    }
    else
    {
        [self setupRightButtonTitle:@"注册"];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.0];
        if(!font){
            font = [UIFont systemFontOfSize:15.0];
        }
        [self.rightButton.titleLabel setFont:font];
        [self.rightButton setTitleColor:RGBColorHex(0x00a8ff) forState:UIControlStateNormal];
        
        self.backButton.hidden = NO;
        NSString *imageName = @"login_close";
        [self.backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self.backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    }
    self.baseLineView.hidden = YES;
}

#pragma mark - override
- (FSNavgationViewStyle)navgationStyle
{
    return FSNavgationViewStyleWhite;
}

- (void)onBackAction:(id)sender
{
    //先关闭键盘, 防止切换抖动
    [self.view endEditing:YES];
    if(self.closeType == FSLoginViewCloseTypePop)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:FSLoginCancelNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:FSLoginCancelNotification object:nil];
        [self closeView];
    }
}

- (void)onRightAction:(id)sender
{
    [UserAction skylineEvent:@"finance_wcb_loginwacai_register_click"];
    
    [self.view endEditing:YES];
    FSOriginalLoginViewController* vc = [[FSOriginalLoginViewController alloc] init];
    vc.comeFrom = self.comeFrom;
    self.navigationController.viewControllers = @[vc];
}

#pragma mark - RAC
- (void)bindViewModel
{
    @weakify(self);
    RAC(self.viewModel, accountString) = RACObserve(self, loginName);
    RAC(self.viewModel, pwdString) = RACObserve(self, loginPassword);

    [[self.viewModel.loginCmd.executing skip:1] subscribeNext:^(id x) {
       @strongify(self);
        if([x boolValue] == YES)
        {
            NSLog(@"开始执行");
            [self.loadingHandler addLoadingWithParentView:self.view activityView:self.loginButton];
        }
        else
        {
            NSLog(@"结束执行");
            [self.loadingHandler removeLoadingWithCompletion:^{

                [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
            }];
        }
        
    }];
    
    [[self.viewModel.loginCmd.executionSignals switchToLatest] subscribeNext:^(NSNumber *mobileHasRegiste) {
        @strongify(self);
        [UserAction skylineEvent:@"finance_wcb_loginwacai_loginbtn_click" attributes:@{@"lc_result" : @"1"}];
        
        [USER_INFO updateIsNewerIfNeededWithOnDoneBlock:nil];
        if ([mobileHasRegiste boolValue]) {
            [self closeView];
        } else {
            FSBindMobileNumberViewController *bindTelNumberView = [[FSBindMobileNumberViewController alloc] init];
            [self.navigationController pushViewController:bindTelNumberView animated:YES];
        }
    }];
    
    
    [self.viewModel.loginCmd.errors subscribeNext:^(NSError *error) {
        [UserAction skylineEvent:@"finance_wcb_loginwacai_loginbtn_click" attributes:@{@"result" : @"0"}];
        
        NSString *errorMessage = [error localizedDescription];
        NSString *errorReason = [error localizedFailureReason];
        @strongify(self);
        if (!(errorReason && [errorReason isEqualToString:@"InvalidValue"]))
        {
            [self reloadTableView];
            [self p_checkLoginBtnStatus];
        }
        if ([errorMessage length] <= 50) {
            [CMUIDisappearView showMessage:[error localizedDescription]];
        }
    }];
}

- (void)bindThirdLoginViewModel
{
    @weakify(self);
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    //先隐藏，防止首次弹出时就出现菊花
    [HUD setHidden:YES];
    
    RACSignal *viewDidDissappear = [self rac_signalForSelector:@selector(viewDidDisappear:)];
    [viewDidDissappear subscribeNext:^(id x) {
        [HUD  hideAnimated:YES];
    }];
    
    [self.thirdLoginViewModel.thirdLogin.errors subscribeNext:^(NSError *error) {
        
        [USER_INFO logout];
        [HUD  hideAnimated:YES];
        if ([error.localizedDescription length] > 0) {
            // 如果不延时，会马上在 executing 中被隐藏
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [CMUIDisappearView showMessage:error.localizedDescription];
            });
        }
    }];
    
    [self.thirdLoginViewModel.thirdLogin.executing subscribeNext:^(NSNumber *executing) {
        
        if ([executing boolValue]) {
            //展示
            [HUD setHidden:NO];
            [HUD showAnimated:YES];
        } else {
            [HUD hideAnimated:YES];
        }
    }];
    
    [self.thirdLoginViewModel.thirdLogin.executionSignals.switchToLatest subscribeNext:^(NSNumber *hasBindMobile) {
        @strongify(self);
        [USER_INFO updateIsNewerIfNeededWithOnDoneBlock:nil];
        if ([hasBindMobile boolValue]) {
            [self onLoginFinished];

        } else {
            [self bindTelNumber];
        };
    }];
}

#pragma mark - loginBtn
- (void)p_checkLoginBtnStatus
{
    [self p_changeLoginBtnColor];
}

- (void)p_changeLoginBtnColor
{
    if(self.viewModel.needVerifyCode)
    {
        //三个
        if(self.loginName.length > 0 && self.loginPassword.length > 0 && self.viewModel.verifyCode.length > 0 && self.agreementView.accepted)
        {
            [self p_setLoginBtnColorGray:NO];
        }
        else
        {
            [self p_setLoginBtnColorGray:YES];
        }
    }
    else
    {
        //二个
        if(self.loginName.length > 0 && self.loginPassword.length > 0 && self.agreementView.accepted)
        {
            [self p_setLoginBtnColorGray:NO];
        }
        else
        {
            [self p_setLoginBtnColorGray:YES];
        }
    }
}

- (void)p_setLoginBtnColorGray:(BOOL)gray
{
    UIColor *grayColor = RGBA(0xD9, 0x51, 0x49, 0.5);
    if(gray)
    {
        [_loginButton setBackgroundImage:[UIImage fs_imageWithColor:grayColor] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage fs_imageWithColor:grayColor] forState:UIControlStateHighlighted];
        [_loginButton setBackgroundImage:[UIImage fs_imageWithColor:grayColor] forState:UIControlStateDisabled];
    }
    else
    {
        [_loginButton setBackgroundImage:[UIImage fs_imageWithColor:HEXCOLOR(0xD95149)] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage fs_imageWithColor:HEXCOLOR(0xB8453F)] forState:UIControlStateHighlighted];
        [_loginButton setBackgroundImage:[UIImage fs_imageWithColor:grayColor] forState:UIControlStateDisabled];
    }
    
    [self.loginBtnCell setEnable:!gray];
    
}

- (void)reloadTableView
{
    NSArray *tmp;
    if (self.viewModel.needVerifyCode)
    {
        tmp = @[@(FSLoginCellTypeAccount),
                @(FSLoginCellTypePassword),
                @(FSLoginCellTypeVerifyCode),
                @(FSLoginCellTypeForgetPassword),
                @(FSLoginCellTypeLoginBtn),
                @(FSLoginCellTypeAgreements),
                @(FSLoginCellTypeSpace),
                @(FSLoginCellTypeThirdLogin)];
    }
    else
    {
        tmp = @[@(FSLoginCellTypeAccount),
                @(FSLoginCellTypePassword),
                @(FSLoginCellTypeForgetPassword),
                @(FSLoginCellTypeLoginBtn),
                @(FSLoginCellTypeAgreements),
                @(FSLoginCellTypeSpace),
                @(FSLoginCellTypeThirdLogin)];
        
        //无需验证码时，清理掉上次输入的验证码
        self.viewModel.verifyCode = @"";
    }
    self.sourceArray = tmp;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *num = self.sourceArray[indexPath.row];
    NSInteger value = [num integerValue];
    if(value == FSLoginCellTypeAccount)
    {
        FSLoginInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSLoginInputCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        __weak FSLoginInputCell *weakCell = cell;
        __weak FSWacaiLoginViewController *weakSelf = self;
        
        cell.iconImageView.image = [UIImage imageNamed:@"new_user"];
        cell.inputTextField.secureTextEntry = NO;
        cell.rightButton.hidden = YES;
        cell.inputTextField.placeholder = @"手机 / 邮箱 / 帐号";
        cell.textFieldBlock = ^{
            weakSelf.loginName = weakCell.inputTextField.text;
            weakSelf.loginPhone = weakCell.inputTextField.text;
            
            [weakSelf p_checkLoginBtnStatus];
        };
        [cell setHideRighButton];
        
        NSString *lastLoginAccount = [[NSUserDefaults standardUserDefaults] objectForKey:@"kWacaibaoLastLoginAccount"];
        if (!lastLoginAccount && !self.loginPhone) {
            //不自动获取焦点
        } else {
            NSString *accountString = @"";
            if (self.loginPhone) {
                accountString = self.loginPhone;
            } else {
                accountString = lastLoginAccount;
            }
            cell.inputTextField.text = accountString;
            weakSelf.loginName =accountString;
        }
        
        return cell;
        
    }
    else if(value == FSLoginCellTypePassword)
    {
        FSLoginInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSLoginInputCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak FSLoginInputCell *weakCell = cell;
        __weak FSWacaiLoginViewController *weakSelf = self;
        
        cell.iconImageView.image = [UIImage imageNamed:@"new_password"];
        [cell.rightButton setImage:[UIImage imageNamed:@"close_eyes"] forState:UIControlStateNormal];
        [cell.rightButton setImage:[UIImage imageNamed:@"open_eyes"] forState:UIControlStateSelected];
        cell.inputTextField.clearButtonMode = UITextFieldViewModeNever;
        cell.rightButton.hidden = YES;
        cell.inputTextField.secureTextEntry = YES;
        cell.inputTextField.placeholder = @"密码";
        
        cell.inputTextField.text = self.loginPassword;
        
        cell.buttonBlock = ^{
            weakCell.inputTextField.secureTextEntry = !weakCell.inputTextField.secureTextEntry;
            weakCell.rightButton.selected = !weakCell.rightButton.selected;
            [weakSelf.view endEditing:YES];
            
        };
        
        cell.textFieldBlock = ^{
            weakSelf.loginPassword = weakCell.inputTextField.text;
            if ([weakCell.inputTextField.text length] > 0) {
                weakCell.rightButton.hidden = NO;
            } else {
                weakCell.rightButton.hidden = YES;
            }
            [weakSelf p_checkLoginBtnStatus];
        };
        
        [cell setShowRighButton];
    
        NSString *lastLoginAccount = [[NSUserDefaults standardUserDefaults] objectForKey:@"kWacaibaoLastLoginAccount"];
        BOOL hasUser =  (lastLoginAccount || self.loginPhone);
        
        if (_needEdit && hasUser) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [cell.inputTextField becomeFirstResponder];
            });
        }
        
        return cell;
    }
    else if(value == FSLoginCellTypeVerifyCode)
    {
        FSLoginInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSLoginInputCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak FSLoginInputCell *weakCell = cell;
        __weak FSWacaiLoginViewController *weakSelf = self;
        
        @weakify(cell);
        cell.iconImageView.image = [UIImage imageNamed:@"verifyCode_icon"];
        [cell.rightButton sd_setImageWithURL:self.viewModel.verifyCodeImageURL
                                    forState:UIControlStateNormal
                            placeholderImage:[UIImage imageNamed:@"verifyCode_loading"]
                                     options:SDWebImageRefreshCached | SDWebImageAvoidAutoSetImage | SDWebImageRetryFailed
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       @strongify(cell);
                                       if (error) {
                                           [cell.rightButton setImage:[UIImage imageNamed:@"verifyCode_error"] forState:UIControlStateNormal];
                                       } else if (cacheType != SDImageCacheTypeNone) {
                                           [cell.rightButton setImage:[UIImage imageNamed:@"verifyCode_loading"] forState:UIControlStateNormal];
                                       } else {
                                           [cell.rightButton setImage:image forState:UIControlStateNormal];
                                       }
                                   }];
        
        cell.inputTextField.text = self.viewModel.verifyCode;
        cell.inputTextField.placeholder = @"请输入右侧验证码";
        
        
        cell.buttonBlock = ^{
            self.viewModel.verifyCode = @"";
            weakCell.inputTextField.text = @"";
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self p_checkLoginBtnStatus];
        };
        cell.textFieldBlock = ^{
            if ([weakCell.inputTextField.text length] > 10) {
                weakCell.inputTextField.text = [weakCell.inputTextField.text substringWithRange:NSMakeRange(0, 10)];
            }
            weakSelf.viewModel.verifyCode = weakCell.inputTextField.text;
            [self p_checkLoginBtnStatus];
        };
        
        [cell setShowRighButton];
        
        return cell;
    }
    else if(value == FSLoginCellTypeForgetPassword)
    {
        FSLoginForgetBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:[FSLoginForgetBtnCell FSCellIdentifier]];
        __weak FSWacaiLoginViewController *weakSelf = self;
        cell.actionBlock = ^{
            [weakSelf forgetBtnAction];
        };
        return cell;
    }
    else if(value == FSLoginCellTypeLoginBtn)
    {
        FSLoginButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:[FSLoginButtonCell FSCellIdentifier]];
        
        [cell fillContent:@"登录"];
        self.loginBtnCell = cell;
        self.loginButton = self.loginBtnCell.button;
        [self p_checkLoginBtnStatus];
        
        return cell;
    }
    else if(value == FSLoginCellTypeAgreements)
    {
        FSAgreementViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FSAgreementViewCell FSCellIdentifier]];
        
        self.agreementView = cell.agreementView;
        __weak __typeof(self)weakSelf = self;
        self.agreementView.checkBlock = ^(BOOL status) {
            [weakSelf p_checkLoginBtnStatus];
            weakSelf.viewModel.acceptAgreements = status;
        };
        
        [self.agreementView updateViewWithAgreements:self.agreements];
        return cell;
    }
    else if(value == FSLoginCellTypeThirdLogin)
    {
        FSThirdButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:[FSThirdButtonCell FSCellIdentifier]];
        
        cell.buttonBlock = ^(FSThirdButtonType type) {
          
            if (type == FSThirdButtonTypeQQ) {
                [UserAction skylineEvent:@"finance_wcb_login_qqlogin_click"];
                
                [self.thirdLoginViewModel.thirdLogin execute:@(LRThirdLoginWayQQ)];
            }
            else if(type == FSThirdButtonTypeSina){
                [UserAction skylineEvent:@"finance_wcb_login_sinalogin_click"];
                
                
                [self.thirdLoginViewModel.thirdLogin execute:@(LRThirdLoginWaySinaWeibo)];
            }
            else if(type == FSThirdButtonTypeTencent){
                [self.thirdLoginViewModel.thirdLogin execute:@(LRThirdLoginWayQQWeibo)];
            }
            else if(type == FSThirdButtonTypeWeChat){
                [UserAction skylineEvent:@"finance_wcb_login_wechatlogin_click"];
                
                [self.thirdLoginViewModel.thirdLogin execute:@(LRThirdLoginWayWeChat)];
            }
        };
        
        return cell;
    }
    else if(value == FSLoginCellTypeSpace)
    {
        FSSpaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSSpaceCell"];
        [cell setViewBackgroundColor:[UIColor whiteColor]];
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *num = self.sourceArray[indexPath.row];
    NSInteger value = [num integerValue];
    if(value == FSLoginCellTypeLoginBtn)
    {
        [self.viewModel.loginCmd execute:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *num = self.sourceArray[indexPath.row];
    NSInteger value = [num integerValue];
    if(value == FSLoginCellTypeAccount
       || value == FSLoginCellTypePassword
       || value == FSLoginCellTypeVerifyCode)
    {
        return 55;
    }
    else if(value == FSLoginCellTypeForgetPassword)
    {
        return 50.0;
    }
    else if(value == FSLoginCellTypeLoginBtn)
    {
        return 46;
    }
    else if(value == FSLoginCellTypeAgreements)
    {
        return 86;
    }
    else if(value == FSLoginCellTypeSpace)
    {
        return [self spaceHeight];
    }
    else if(value == FSLoginCellTypeThirdLogin)
    {
        return [FSThirdButtonCell cellHeight];
    }
    
    return 0.0;
}

- (CGFloat)spaceHeight
{
    //headView 102
    //account password VerifyCode 55
    //loginBtn 46
    //agreements 86
    //thirdLogin 158
    NSInteger inputCellsHeight = 55 * 2;
    if(self.viewModel.needVerifyCode)
    {
        inputCellsHeight = 55 *3;
    }
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - FS_NavigationBarHeight - 102 - inputCellsHeight - 50.0 - 46 - 86 - [FSThirdButtonCell cellHeight] ;
    if (height <= 0.) {
        return 0.;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


#pragma mark - Action
- (void)closeView {
    [self.view endEditing:YES];
    [self.navigationController.topViewController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)forgetBtnAction
{
    [UserAction skylineEvent:@"finance_wcb_loginwacai_forgotpassword_click"];
    
    NSString *forgetPasswordUrl = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeForgetPwd];
    [FSSDKGotoUtility openURL:forgetPasswordUrl from:self];
}

- (void)bindTelNumber
{
    if(self.signupConfig.thirdNeedBindPhone)
    {
        FSBindMobileNumberViewController *bindTelNumberView = [[FSBindMobileNumberViewController alloc] init];
        [self.navigationController pushViewController:bindTelNumberView animated:YES];
    }
    else
    {
        [self onLoginFinished];
    }
}

- (void)onLoginFinished {
    
    [self onBackAction:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:FSLoginDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:LRUserDidLoginSuccessNotification
                                                        object:nil];
}

#pragma mark - Getter and Setter
- (TPKeyboardAvoidingTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = 50;
        
        [_tableView registerClass:[FSLoginInputCell class] forCellReuseIdentifier:@"FSLoginInputCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"FSLoginForgetBtnCell" bundle:nil] forCellReuseIdentifier:[FSLoginForgetBtnCell FSCellIdentifier]];
        [_tableView registerNib:[UINib nibWithNibName:@"FSLoginButtonCell" bundle:nil] forCellReuseIdentifier:[FSLoginButtonCell FSCellIdentifier]];
        
        [_tableView registerClass:[FSThirdButtonCell class] forCellReuseIdentifier:[FSThirdButtonCell FSCellIdentifier]];
        
        [_tableView registerNib:[UINib nibWithNibName:@"FSAgreementViewCell" bundle:nil] forCellReuseIdentifier:[FSAgreementViewCell FSCellIdentifier]];
        
        [_tableView registerClass:[FSSpaceCell class] forCellReuseIdentifier:@"FSSpaceCell"];
        
        _tableView.backgroundView = nil;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        FSLoginHeaderView *headerView = [[FSLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 102)];
        _tableView.tableHeaderView = headerView;
    }
    
    return _tableView;
}

- (FSLoginLoadingHandler *)loadingHandler
{
    if(!_loadingHandler)
    {
        _loadingHandler = [[FSLoginLoadingHandler alloc] init];
    }
    return _loadingHandler;
}

#pragma mark - agreements
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


@end
