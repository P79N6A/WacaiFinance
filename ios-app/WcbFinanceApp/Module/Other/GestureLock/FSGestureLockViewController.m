//
//  FSGestureLockViewController.m
//  FinanceApp
//
//  Created by xingyong on 8/3/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSGestureLockViewController.h"
#import "AppDelegate.h"
#import "KKGestureLockView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UIColor+FSUtils.h"
#import "FSPasswordManageViewController.h"
#import "FSTabbarController.h"
#import "FSStringUtils.h"
#import "UIView+FSUtils.h"
#import "FSTouchIDHelper.h"
#import "FSRootViewController.h"
#import <MBProgressHUD+CMExtension.h>
#import <FSNetworkCache.h>


static NSString *const kClickForgetButton = @"kClickForgetButton";

@interface FSGestureLockViewController ()<KKGestureLockViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) KKGestureLockView *lockView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *forgetButton;
@property (nonatomic, strong) UIButton *touchIDButton;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *welcomeLabel;
@property (nonatomic, strong) UILabel *partitionLabel;
@property (nonatomic, copy) NSString *passwordString;

@property (nonatomic) NSUInteger unmatchCounter;
@property (nonatomic) BOOL isUpdate;

@end

@implementation FSGestureLockViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *limitDateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentDateLimit"];
    BOOL isExist = [limitDateStr isEqualToString:[FSStringUtils currentDateString]];
    if (isExist) {
        self.unmatchCounter = 0;
        [self warnTips:@"手势出错,您还可以输入0次"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"您已连续输错5次\n手势密码已关闭，请重新登录"
                                                       delegate:self
                                              cancelButtonTitle:@"重新登录"
                                              otherButtonTitles:nil];
        alert.tag = 1;
        [alert show];
        
    }
    else{
        self.unmatchCounter = 5;
    }
    
    
    [self setupBaseView];
    
    switch (self.type) {
        case FSGestureLockTypeNone: {
            self.welcomeLabel.text = @"亲爱的财主，欢迎回来";
            self.closeButton.hidden = YES;
            self.forgetButton.hidden = NO;
            break;
        }
        case FSGestureLockTypeSet: {
            self.tipLabel.text = @"为了您的账户安全,请设置手势密码";
            self.closeButton.hidden = NO;
            self.forgetButton.hidden = YES;
            break;
        }
        case FSGestureLockTypeUpdate: {
            self.tipLabel.text = @"请输入当前手势密码";
            self.closeButton.hidden = NO;
            self.forgetButton.hidden = NO;
            break;
        }
        case FSGestureLockTypeClose: {
            self.tipLabel.text = @"请输入当前手势密码";
            self.closeButton.hidden = NO;
            self.forgetButton.hidden = NO;
            break;
        }
            
    }
 
 
    
}


- (void)setupBaseView{
    self.fd_interactivePopDisabled = YES;
    self.navgationView.hidden = YES;
    
    [self.view addSubview:self.lockView];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.forgetButton];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.welcomeLabel];
    [self.view addSubview:self.partitionLabel];
    [self.view addSubview:self.touchIDButton];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_StatusBarHeight);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    
    
    [self.lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(260,260));
        make.centerY.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(25);
        make.bottom.equalTo(_lockView.mas_top).offset(-50);
    }];
    
    [self.welcomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(25);
        make.bottom.equalTo(_tipLabel.mas_top).offset(-5);
    }];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 80.;
    if (width == 320.) {
        height = 40.;
    }
    
    
    FSTouchIDStatus status = [FSTouchIDHelper checkTouchIDStatusOfSystem];
    if ((self.type == FSGestureLockTypeNone) && ((status == FSTouchIDStatusSystemAvailable) || (status == FSTouchIDStatusSystemLockout)) && [FSTouchIDHelper isTouchIDOfAppOn]) {
        //展示“指纹解锁“时，与“忘记手势密码？”分散对齐到两边
        [self.touchIDButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.partitionLabel.mas_left).offset(-10);
            make.height.mas_equalTo(40);
            make.top.equalTo(_lockView.mas_bottom).offset(height);
        }];
        
        [self.partitionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.centerX.equalTo(_lockView.mas_centerX);
            make.top.equalTo(_lockView.mas_bottom).offset(height);
        }];
        
        [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.partitionLabel.mas_right).offset(10);
            make.height.mas_equalTo(40);
            make.top.equalTo(_lockView.mas_bottom).offset(height);
        }];
        
    } else {
        //不展示”指纹解锁“时，“忘记手势密码？”居中展示
        [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.top.equalTo(_lockView.mas_bottom).offset(height);
        }];
    }
    
    
    
}

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didBeginWithPasscode:(NSString *)passcode{
    NSLog(@"didBeginWithPasscode----:%@",passcode);
}

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode{
    if([passcode length] <=5){
        [self warnTips:@"请至少选择4个连接点"];
        return;
    }
    
    if (self.type == FSGestureLockTypeNone) {
        [self swipeUnlock:passcode];
        
    }else if (self.type == FSGestureLockTypeSet) {
        [self setGesturePassword:passcode];
    }else if (self.type == FSGestureLockTypeUpdate) {
        if(_isUpdate){
            
            [self setGesturePassword:passcode];
        }
        else{
            
            [self updateGesturePassword:passcode];
        }
        
    }else if(self.type == FSGestureLockTypeClose){
        [self closeGesturePassword:passcode];
    }
    
}

// 关闭手势密码
- (void)closeGesturePassword:(NSString *)passcode{
    NSString *savedPassword = [[NSUserDefaults standardUserDefaults] objectForKey:[FSStringUtils getPasswordKey]];
    if([savedPassword isEqualToString:passcode]){
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"" forKey:[FSStringUtils getPasswordKey]];
        [userDefault synchronize];
        
//        [self showTextHUD:@"手势已取消"];
        [MBProgressHUD showHUDAddedTo:self.view lableText:@"手势已取消" animated:YES];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
        
        //关闭手势密码后，默认关闭Touch ID
        [FSTouchIDHelper switchTouchIDOfAppOff];
        
    }
    else{
        [self warnTips:@"手势验证错误，请重试"];
    }
}

// 更新手势密码
- (void)updateGesturePassword:(NSString *)passcode{
    NSString *savedPassword = [[NSUserDefaults standardUserDefaults] objectForKey:[FSStringUtils getPasswordKey]];
    if([savedPassword isEqualToString:passcode]){
        [self reset];
        _isUpdate = YES;
        self.forgetButton.hidden = YES;
    }
    else{
        [self warnTips:@"手势验证错误，请重试"];
    }
}


// 滑动解锁
- (void)swipeUnlock:(NSString *)passcode{
    
    NSString *savedPassword = [[NSUserDefaults standardUserDefaults] objectForKey:[FSStringUtils getPasswordKey]];
    if ([savedPassword isEqualToString:passcode]) {
        if (self.unmatchCounter) {
            [self dismiss];
        }
        
    }else{
        if(self.unmatchCounter){
            self.unmatchCounter--;
        }
        
        if (self.unmatchCounter == 0) {
            
            [[NSUserDefaults standardUserDefaults] setValue:[self currentDateString] forKey:@"currentDateLimit"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            self.tipLabel.text = @"手势出错,您还可以输入0次";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"手势密码输错5次\n请重新登录"
                                                           delegate:self
                                                  cancelButtonTitle:@"重新登录"
                                                  otherButtonTitles:nil];
            alert.tag = 2;
            [alert show];
            
            
        }else {
            NSString *tip = [NSString stringWithFormat:@"手势出错,您还可以输入%lu次", (unsigned long)self.unmatchCounter];
            [self warnTips:tip];
            
        }
    }
    
    
}

// 设置手势密码
- (void)setGesturePassword:(NSString *)passcode{
    if (self.passwordString == nil) {
        self.passwordString = passcode;
        self.tipLabel.text = @"请再次绘制图案,进行确认";
        self.tipLabel.textColor = [UIColor blackColor];
        
    }else if ([self.passwordString isEqualToString:passcode]){
        
        self.passwordString = nil;
        self.tipLabel.textColor = [UIColor blackColor];
//        [self showTextHUD:@"手势已设置"];
      
        
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:passcode forKey:[FSStringUtils getPasswordKey]];
        [userDefault synchronize];
        
        //设置手势密码后，默认启用Touch ID
        if ([FSTouchIDHelper checkTouchIDStatusOfSystem] == FSTouchIDStatusSystemAvailable) {
            [FSTouchIDHelper switchTouchIDOfAppOn];
        }
        
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
        
    }else{
        [self warnTips:@"图案不匹配，请再试一次"];
        
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag ==3){
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:NO forKey:kClickForgetButton];
        [userDefault synchronize];
        
        if (buttonIndex == 1) {

            [self gotoLoginViewController];
        }else if(buttonIndex == 0){

        }
        
        
    }else{
        [self gotoLoginViewController];
    }
    
    
}

- (void)resetData{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"" forKey:@"currentDateLimit"];
    [userDefault setObject:@"" forKey:[FSStringUtils getPasswordKey]];
    [FSTouchIDHelper switchTouchIDOfAppOff];
    [userDefault synchronize];
    
    [USER_INFO logout];
    [self dismiss];
    
    
}
// 抖动效果
- (void)shake{
    
    CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animation];
    shakeAnim.keyPath = @"transform.translation.x";
    shakeAnim.duration = 0.15;
    CGFloat delta = 10;
    shakeAnim.values = @[@0 , @(-delta), @(delta), @0];
    shakeAnim.repeatCount = 2;
    [self.tipLabel.layer addAnimation:shakeAnim forKey:@"tipLabel"];
    
}
// 抖动提示
- (void)warnTips:(NSString *)tip{
    self.tipLabel.textColor = [UIColor colorWithHex:0xd84a3f];
    self.tipLabel.text = tip;
    [self shake];
}
// 重置数据
- (void)reset
{
    self.passwordString = nil;
    self.tipLabel.text = @"为了您的账户安全,请设置手势密码";
    self.tipLabel.textColor = [UIColor blackColor];
}
//隐藏手势密码界面
- (void)dismiss{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (self.type == FSGestureLockTypeNone) {
        [appDelegate dismissGestureLock];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
        
}

- (void)onCloseAction:(id)sender{
    [self dismiss];

}
// 忘记密码
- (void)onForgetAction:(id)sender{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:YES  forKey:kClickForgetButton];
    [userDefault synchronize];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"为了您账户安全, 请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
    alert.tag = 3;
    [alert show];
    
    
}


//唤起Touch ID验证
- (void)onTouchIDAction:(id)sender {
    [FSTouchIDHelper verifyTouchIDIfAppAvailableWithSuccessAction:^{
        [self dismiss];
    }];
}
- (void)gotoLoginViewController{
    
    [FSGotoUtility gotoLoginViewController:self success:^{
        
        __block UIViewController *toViewController = nil;
        __block BOOL isExist = NO;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *viewController = (UIViewController *)obj;
            if ([viewController isKindOfClass:[FSPasswordManageViewController class]]) {
                toViewController = viewController;
                isExist = YES;
                *stop = YES;
            }
        }];
        if (isExist) {
            [self.navigationController popToViewController:toViewController animated:YES];
        }else{
            if (self.type == FSGestureLockTypeClose) {
                [self.navigationController popToViewController:toViewController animated:YES];
            }
            else{
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                [FSGotoUtility gotoGestureLockViewController:appDelegate.fs_navgationController
                                                        type:FSGestureLockTypeSet
                                                    animated:YES];
            }
            
        }
        
    } cancel:^{
        [self popToHomeViewController];
    }];
    
    
    [self resetData];
    
}
- (void)popToHomeViewController{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.fs_navgationController popToRootViewControllerAnimated:YES];
    self.fs_tabbarController.selectedIndex = 0;
}

- (NSString *)currentDateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //    NSLog(@"currentDateStr------ %@",currentDateStr);
    return currentDateStr;
}
- (KKGestureLockView *)lockView{
    
    if (_lockView == nil) {
        
        _lockView = [[KKGestureLockView alloc] initWithFrame:self.view.bounds];
        _lockView.normalGestureNodeImage = [UIImage imageNamed:@"password_dot.png"];
        _lockView.selectedGestureNodeImage = [UIImage imageNamed:@"password_dot_hl.png"];
        _lockView.lineColor = [UIColor colorWithHex:0xd84a3f];
        _lockView.lineWidth = 2;
        _lockView.delegate = self;
        
    }
    return _lockView;
}
- (UIButton *)closeButton{
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor colorWithHex:0x0d9cff] forState:UIControlStateNormal];
        [_closeButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_closeButton addTarget:self action:@selector(onCloseAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _closeButton;
}

- (UIButton *)forgetButton{
    if (_forgetButton == nil) {
        _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetButton setTitle:@"忘记手势密码?" forState:UIControlStateNormal];
        [_forgetButton setTitleColor:[UIColor colorWithHex:0x0197ff] forState:UIControlStateNormal];
        [_forgetButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_forgetButton addTarget:self action:@selector(onForgetAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _forgetButton;
}

- (UIButton *)touchIDButton {
    if (!_touchIDButton) {
        _touchIDButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_touchIDButton setTitle:FS_iPhoneX ? @"面容验证解锁":@"指纹验证解锁" forState:UIControlStateNormal];
        [_touchIDButton setTitleColor:[UIColor colorWithHex:0x0197ff] forState:UIControlStateNormal];
        [_touchIDButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_touchIDButton addTarget:self action:@selector(onTouchIDAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touchIDButton;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel                 = [[UILabel alloc] init];
        _tipLabel.font            = [UIFont systemFontOfSize:15];
        _tipLabel.textColor       = [UIColor blackColor];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.textAlignment   = NSTextAlignmentCenter;
    }
    return _tipLabel;
}
- (UILabel *)welcomeLabel{
    if (!_welcomeLabel) {
        _welcomeLabel                 = [[UILabel alloc] init];
        _welcomeLabel.font            = [UIFont systemFontOfSize:20];
        _welcomeLabel.textColor       = [UIColor blackColor];
        _welcomeLabel.backgroundColor = [UIColor clearColor];
        _welcomeLabel.textAlignment   = NSTextAlignmentCenter;
    }
    return _welcomeLabel;
}

- (UILabel *)partitionLabel {
    if (!_partitionLabel) {
        _partitionLabel = [UILabel new];
        _partitionLabel.textColor = [UIColor colorWithHex:0xdddddd];
        _partitionLabel.font = [UIFont systemFontOfSize:15];
        _partitionLabel.text = @"|";
    }
    return _partitionLabel;
}
 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
