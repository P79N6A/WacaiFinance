//
//  FSOriginalLoginViewController.m
//  FinanceApp
//
//  Created by 叶帆 on 5/3/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//


#import "FSOriginalLoginViewController.h"
#import "FSEnterMobileNumberViewController.h"
#import "FSBindMobileNumberViewController.h"
#import "FSWacaiLoginViewController.h"
#import "FSTitleDescCell.h"
#import "FSSpaceCell.h"
#import "FSThirdButtonCell.h"
#import "FSLoginViewModel.h"
#import <MBProgressHUD.h>
#import "FSNewUserRegisterCell.h"
#import "FSSetPasswordViewController.h"
#import "LoginRegisterSDK.h"
#import "LRCenterManager.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>
#import "FSLoginInputCell.h"
#import "FSLoginButtonCell.h"
#import "FSEnterMobileNumberViewModel.h"
#import "FSSignupConfig.h"
#import "FSLoginLoadingHandler.h"
#import <FSHiveConfig/FSHCManager.h>

static const NSInteger MaxPhoneLength = 11;
static NSString *NextCellText = @"立即加入";

typedef NS_ENUM(NSUInteger, FSNewLoginCellStyle) {
    FSNewLoginCellStyleTitleDesc,
    FSNewLoginCellStyleAccountButton,
    FSNewLoginCellStyleThirdButton,
    FSNewLoginCellStyleSpace,
    FSNewLoginCellStyleBottomSpace,
    FSNewLoginCellStyleRegistButton,
    FSNewLoginCellStyleInputPhoneNum,
    FSNewLoginCellStyleNextButton,
};

@interface FSOriginalLoginViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) TPKeyboardAvoidingTableView  *tableView;
@property (nonatomic, strong) NSArray*   dataSource;
@property (nonatomic, strong) FSLoginViewModel*  viewModel;

@property (nonatomic, assign) BOOL               mIsShowOtherLoginType;
@property (nonatomic, assign) BOOL barNeedLoginBtn;

@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) FSLoginButtonCell *nextCell;

@property (nonatomic, strong) FSEnterMobileNumberViewModel *phoneNumViewModel;
@property (nonatomic, strong) FSSignupConfig *signupConfig;
@property (nonatomic, strong) FSLoginLoadingHandler *loadingHandler;

@end

@implementation FSOriginalLoginViewController

@synthesize mIsShowOtherLoginType;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        mIsShowOtherLoginType = NO;
        _viewModel = [FSLoginViewModel new];
        _viewModel.fromRegistration = YES;
        _phoneNumViewModel = [[FSEnterMobileNumberViewModel alloc] init];
        _loadingHandler = [[FSLoginLoadingHandler alloc] init];
    }
    return self;
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
    
    [UserAction skylineEvent:@"finance_wcb_register_enter_page" attributes:dic];
    
    
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
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    self.signupConfig = [HIVE_CONFIG localCacheOfKey:[FSSignupConfig configKey] class:[FSSignupConfig class]];
    
    [self registTableViewCell];
    [self reloadDataSource];
    [self bindViewModel];
    
    __weak __typeof(self)weakSelf = self;
    [HIVE_CONFIG fetchKey:[FSSignupConfig configKey] class:[FSSignupConfig class] completion:^(BOOL isSuccess, id  _Nullable object) {
        if (isSuccess) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.signupConfig = object;
            [strongSelf reloadDataSource];
        }
    }];
}


#pragma mark - NavigationBar
- (void)customNavigationBar
{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.0];
    if(!font){
        font = [UIFont systemFontOfSize:14];
    }
    
    [self.rightButton.titleLabel setFont:font];
    [self.rightButton setTitleColor:[UIColor colorWithHex:0x0097FF] forState:UIControlStateNormal];
    [self setupRightButtonTitle:@"登录"];
    
    self.backButton.hidden = NO;
    NSString *imageName = @"login_close";
    [self.backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    
    self.baseLineView.hidden = YES;
}

#pragma mark - override
- (void)onBackAction:(id)sender{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:FSLoginCancelNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)onRightAction:(id)sender{
    //先关闭键盘, 防止切换抖动
    
    [UserAction skylineEvent:@"finance_wcb_register_login_click"];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    FSWacaiLoginViewController* vc = [[FSWacaiLoginViewController alloc] initWithLoginPhone:nil closeType:FSLoginViewCloseTypeDismiss needEdit:YES];
    vc.comeFrom = self.comeFrom;
    
    self.navigationController.viewControllers = @[vc];
}

- (FSNavgationViewStyle)navgationStyle
{
    return FSNavgationViewStyleWhite;
}

#pragma mark - RAC
- (void)bindViewModel
{
    @weakify(self);
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //先隐藏，防止首次弹出时就出现菊花
    [HUD setHidden:YES];
    RACSignal *viewDidDissappear = [self rac_signalForSelector:@selector(viewDidDisappear:)];
    [viewDidDissappear subscribeNext:^(id x) {
        [HUD  hideAnimated:YES];
    }];
    
    //thirdLogin
    [self.viewModel.thirdLogin.errors subscribeNext:^(NSError *error) {

        [USER_INFO logout];
        [HUD  hideAnimated:YES];
        if ([error.localizedDescription length] > 0) {
            // 如果不延时，会马上在 executing 中被隐藏
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [CMUIDisappearView showMessage:error.localizedDescription];
            });
        }
    }];
    
    [self.viewModel.thirdLogin.executing subscribeNext:^(NSNumber *executing) {
        
        if ([executing boolValue]) {
            [HUD setHidden:NO];
            [HUD showAnimated:YES];
        } else {
            [HUD hideAnimated:YES];
        }
    }];
    
    [self.viewModel.thirdLogin.executionSignals.switchToLatest subscribeNext:^(NSNumber *hasBindMobile) {
        @strongify(self);
        [USER_INFO updateIsNewerIfNeededWithOnDoneBlock:nil];
        
        if ([hasBindMobile boolValue]) {
            [self onLoginFinished];
            
        } else {
            [self bindTelNumber];
        };
    }];
    
    //EnterPhoneNum
    [[self.phoneNumViewModel.mobileHasRegisteCmd.executionSignals switchToLatest] subscribeNext:^(NSNumber *mobileHasRegiste) {
        @strongify(self);
        
        [UserAction skylineEvent:@"finance_wcb_register_next_click" attributes:@{@"lc_check_result":@"1"}];
        
        NSString *reg = [mobileHasRegiste boolValue] ? @"1":@"0";
        NSDictionary *attribute = @{@"lc_is_registered":reg
                                    };
        
        [UserAction skylineEvent:@"finance_wcb_register_next_jump" attributes:attribute];
        
        //关闭键盘
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        if([mobileHasRegiste boolValue])
        {
            //已注册, 登录页面
            [self wacaiLoginAction:self.phoneNum];
        }
        else
        {
            //未注册, 设置密码页面
            FSSetPasswordViewController* vc = [[FSSetPasswordViewController alloc] init];
            vc.mTelephone = self.phoneNum;
            [self.navigationController pushViewController:vc animated:YES];
        }

    }];
    
    [[self.phoneNumViewModel.mobileHasRegisteCmd.executing skip:1] subscribeNext:^(id x) {
       @strongify(self);
        if([x boolValue] == YES)
        {
            [self.loadingHandler addLoadingWithParentView:self.view activityView:self.nextCell.button];
        }
        else
        {
            [self.loadingHandler removeLoadingWithCompletion:^{
                
                [self.nextCell.button setTitle:NextCellText forState:UIControlStateNormal];
            }];
        }
        
    }];
    
    
    [self.phoneNumViewModel.mobileHasRegisteCmd.errors subscribeNext:^(NSError *error) {
        
        [UserAction skylineEvent:@"finance_wcb_register_next_click" attributes:@{@"lc_check_result":@"0"}];

        NSString *errorMessage = [error localizedDescription];
        if ([errorMessage length] <= 100) {
            [CMUIDisappearView showMessage:[error localizedDescription]];
        }
        
    }];
}

#pragma mark - tableView
- (void)reloadDataSource
{
    NSArray *dataSource ;
    if(self.signupConfig.needThirdLogin)
    {
        dataSource = @[@(FSNewLoginCellStyleTitleDesc),
                       @(FSNewLoginCellStyleInputPhoneNum),
                       @(FSNewLoginCellStyleSpace),
                       @(FSNewLoginCellStyleNextButton),
                       @(FSNewLoginCellStyleBottomSpace),
                       @(FSNewLoginCellStyleThirdButton)];
    }
    else
    {
        dataSource = @[@(FSNewLoginCellStyleTitleDesc),
                       @(FSNewLoginCellStyleInputPhoneNum),
                       @(FSNewLoginCellStyleSpace),
                       @(FSNewLoginCellStyleNextButton),
                       @(FSNewLoginCellStyleBottomSpace)];
    }
    
    self.dataSource = dataSource;
    [self.tableView reloadData];
}

- (void)registTableViewCell{
    [self.tableView registerClass:[FSTitleDescCell class] forCellReuseIdentifier:@"FSTitleDescCell"];
    [self.tableView registerClass:[FSSpaceCell class] forCellReuseIdentifier:@"FSSpaceCell"];
    [self.tableView registerClass:[FSNewUserRegisterCell class] forCellReuseIdentifier:@"FSNewUserRegisterCell"];
    [self.tableView registerClass:[FSThirdButtonCell class] forCellReuseIdentifier:@"FSThirdButtonCell"];
    [self.tableView registerClass:[FSLoginInputCell class] forCellReuseIdentifier:@"FSLoginInputCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FSLoginButtonCell" bundle:nil] forCellReuseIdentifier:@"FSLoginButtonCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *style = self.dataSource[indexPath.row];
    
    if ([style isEqualToNumber:@(FSNewLoginCellStyleTitleDesc)]) {
        FSTitleDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSTitleDescCell"];
        [cell fillContent:self.signupConfig.headSubtitle];
        return cell;
    }
    else if ([style isEqualToNumber:@(FSNewLoginCellStyleSpace)] || [style isEqualToNumber:@(FSNewLoginCellStyleBottomSpace)]) {
        FSSpaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSSpaceCell"];
        [cell setViewBackgroundColor:[UIColor whiteColor]];
        return cell;
    }
    else if ([style isEqualToNumber:@(FSNewLoginCellStyleThirdButton)]) {
        @weakify(self);
        FSThirdButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSThirdButtonCell"];
        cell.buttonBlock = ^(FSThirdButtonType type){
            @strongify(self);
            if (type == FSThirdButtonTypeQQ) {
                 [UserAction skylineEvent:@"finance_wcb_register_qq_click"];
                
                [self.viewModel.thirdLogin execute:@(LRThirdLoginWayQQ)];
            }
            else if(type == FSThirdButtonTypeSina){
                 [UserAction skylineEvent:@"finance_wcb_register_weibo_click"];
                
                [self.viewModel.thirdLogin execute:@(LRThirdLoginWaySinaWeibo)];
            }
            else if(type == FSThirdButtonTypeTencent){
                 [self.viewModel.thirdLogin execute:@(LRThirdLoginWayQQWeibo)];
            }
            else if(type == FSThirdButtonTypeWeChat){
                 [UserAction skylineEvent:@"finance_wcb_register_weixin_click"];
                
                [self.viewModel.thirdLogin execute:@(LRThirdLoginWayWeChat)];
                
            }
        };
        return cell;
    }
    else if ([style isEqualToNumber:@(FSNewLoginCellStyleNextButton)] ) {
        
        FSLoginButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSLoginButtonCell"];
        [cell fillContent:NextCellText];
        self.nextCell = cell;
        
        [self checkPhoneNum:self.phoneNum];
        
        return cell;
    }
    else if([style isEqualToNumber:@(FSNewLoginCellStyleInputPhoneNum)]){
        FSLoginInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSLoginInputCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.inputTextField.placeholder = @"请输入手机号";
        cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        
         __weak FSLoginInputCell *weakCell = cell;
         __weak __typeof(self)weakSelf = self;
        
        cell.inputTextField.text = self.phoneNum;
        cell.textFieldBlock = ^{
            
            if ([weakCell.inputTextField.text length] > MaxPhoneLength) {
                weakCell.inputTextField.text = [weakCell.inputTextField.text substringWithRange:NSMakeRange(0, 11)];
            }
            NSString* phoneNum = weakCell.inputTextField.text;
            [weakSelf checkPhoneNum:phoneNum];
        };
        
        [cell setHideRighButton];
        
        return cell;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSNumber *style = self.dataSource[indexPath.row];

    if ([style isEqualToNumber:@(FSNewLoginCellStyleTitleDesc)]) {
        return 170;
    }
    else if ([style isEqualToNumber:@(FSNewLoginCellStyleNextButton)]) {
        return 58;
    }
    else if ([style isEqualToNumber:@(FSNewLoginCellStyleThirdButton)]) {
        return [FSThirdButtonCell cellHeight];
    }
    else if ([style isEqualToNumber:@(FSNewLoginCellStyleBottomSpace)]) {
        CGFloat height = [self spaceHeight];
        return  height;
    }
    else if([style isEqualToNumber:@(FSNewLoginCellStyleInputPhoneNum)]){
        return 50;
    }
    else if([style isEqualToNumber:@(FSNewLoginCellStyleSpace)])
    {
        return 20;
    }
    return 0;
}

- (CGFloat)spaceHeight
{
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - 170 - 58 - [FSThirdButtonCell cellHeight] - 50 - 20 -  FS_NavigationBarHeight;
    if (height <=0.) {
        return 0.;
    }
    return height;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSNumber *style = self.dataSource[indexPath.row];
    
    if ([style isEqualToNumber:@(FSNewLoginCellStyleThirdButton)]) {
        
        
    }
    else if ([style isEqualToNumber:@(FSNewLoginCellStyleRegistButton)]) {
        [UserAction skylineEvent:@"finance_wcb_login_register_click"];
        
        [self mobileLoginAction];
    }
    else if([style isEqualToNumber:@(FSNewLoginCellStyleNextButton)])
    {
        if([self.nextCell enable])
        {
            self.phoneNumViewModel.mobileString = self.phoneNum;
            [self.phoneNumViewModel.mobileHasRegisteCmd execute:nil];
        }
    }
}



#pragma mark -- Actions
- (void)mobileLoginAction {
    FSEnterMobileNumberViewController* vc = [[FSEnterMobileNumberViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)wacaiLoginAction:(NSString *)phoneNumber
{
    FSWacaiLoginViewController* vc = [[FSWacaiLoginViewController alloc] initWithLoginPhone:phoneNumber
                                                                                  closeType:FSLoginViewCloseTypeDismiss
                                                                                   needEdit:YES];
    self.navigationController.viewControllers = @[vc];
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

- (void)checkPhoneNum:(NSString *)phoneNum
{
    _phoneNum = phoneNum;
    if(_phoneNum.length >= MaxPhoneLength)
    {
        [self.nextCell setEnable:YES];
    }
    else
    {
        [self.nextCell setEnable:NO];
    }
}

//property
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundView = nil;
    }
    return _tableView;
}

@end
