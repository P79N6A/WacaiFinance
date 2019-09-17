
//
//  FinancialLoginViewController.m
//  financial
//
//  Created by wac on 14-6-16.
//  Copyright (c) 2014年 com.wacai.licai. All rights reserved.
//

#import "FSEnterMobileNumberViewController.h"
#import "FSSetPasswordViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "InputTableViewCell.h"
#import "FSEnterMobileNumberViewModel.h"
#import "FSWacaiLoginViewController.h"
#import "CMUIDisappearView.h"


static NSString *const kInputCellIdentifier = @"InputCellIdentifier";

@interface FSEnterMobileNumberViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, copy  ) NSString     *telString;
@property (nonatomic, strong) UIButton    *nextButton;

@property (nonatomic, strong) TPKeyboardAvoidingTableView  *tableView;
@property (nonatomic, strong) FSEnterMobileNumberViewModel *viewModel;

@end

@implementation FSEnterMobileNumberViewController


#pragma mark -- Life Cycle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewModel = [FSEnterMobileNumberViewModel new];
    }
    
    return self;
}

#pragma mark - UI
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self bindViewModel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UserAction skylineEvent:@"finance_wcb_register_enter_page"];
}

 
- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"nav_title_phone_login", nil);
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_NavigationBarHeight);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}


#pragma mark - Bind Data
- (void)bindViewModel
{
    @weakify(self);
    
    RAC(self.viewModel, mobileString) = RACObserve(self, telString);
    
    self.nextButton.rac_command = self.viewModel.mobileHasRegisteCmd;
    [[self.viewModel.mobileHasRegisteCmd.executionSignals switchToLatest] subscribeNext:^(NSNumber *mobileHasRegiste) {
        @strongify(self);
        [UserAction skylineEvent:@"finance_wcb_register_next_click"];
        
        //在弹出AlertView和进入下个页面前都要关闭键盘，防止下个页面打开时存在键盘弹出再关闭及其诡异的动画
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        if ([mobileHasRegiste boolValue]) {
            //携带手机号信息跳转到统一登录界面
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"帐号已存在，请直接登录"
                                                               delegate:nil
                                                      cancelButtonTitle:@"取消"
                                                    otherButtonTitles:@"登录", nil];
            
            [alertView show];
            
            @weakify(self);
            [alertView.rac_willDismissSignal subscribeNext:^(NSNumber *index) {
                @strongify(self);
                if ([index integerValue] == 1) {
                    //在弹出AlertView和进入下个页面前都要关闭键盘，防止下个页面打开时存在键盘弹出再关闭及其诡异的动画
                    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                    FSWacaiLoginViewController *wacaiLoginVC = [[FSWacaiLoginViewController alloc] initWithLoginPhone:self.telString];
                    [self.navigationController pushViewController:wacaiLoginVC animated:YES];
                }
            }];
        } else {
            //设置密码
            FSSetPasswordViewController* vc = [[FSSetPasswordViewController alloc] init];
            vc.mTelephone = self.telString;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    [self.viewModel.mobileHasRegisteCmd.errors subscribeNext:^(NSError *error) {
        NSString *errorMessage = [error localizedDescription];
        if ([errorMessage length] <= 100) {
            [CMUIDisappearView showMessage:[error localizedDescription]];
        }
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kInputCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak InputTableViewCell *weakCell = cell;
    __weak FSEnterMobileNumberViewController *weakSelf = self;
    
    if (indexPath.row == 0) {
        cell.iconImageView.image = [UIImage imageNamed:@"icon_phone"];
        cell.rightButton.hidden = YES;
        cell.inputTextField.secureTextEntry = NO;
        cell.inputTextField.keyboardType = UIKeyboardTypePhonePad;
        cell.inputTextField.placeholder = NSLocalizedString(@"msg_tips_phone_login", nil);
        cell.textFieldBlock = ^{
            if ([weakCell.inputTextField.text length] > 11) {
                weakCell.inputTextField.text = [weakCell.inputTextField.text substringWithRange:NSMakeRange(0, 11)];
            }
            
            weakSelf.telString = weakCell.inputTextField.text;
        };
        [cell.inputTextField becomeFirstResponder];

        
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - Navigation Back
- (void)onBackAction:(id)sender {    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注册是投资理财第一步，注册即获好礼，您是否选择放弃～" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [UserAction skylineEvent:@"finance_wcb_registerpopup_abandon_click" attributes:@{@"lc_source_id":@"Register"}];
        
        
        [super onBackAction:sender];
    }];
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"继续注册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [UserAction skylineEvent:@"finance_wcb_registerpopup_continue_click" attributes:@{@"lc_source_id":@"Register"}];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:registerAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - Getter and Setter
- (TPKeyboardAvoidingTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = 50;
        [_tableView registerClass:[InputTableViewCell class] forCellReuseIdentifier:kInputCellIdentifier];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundView = nil;
        _tableView.separatorColor = HEXCOLOR(0xe7e7e7);
        _tableView.backgroundColor = COLOR_DEFAULT_BACKGROUND;

        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 130)];
        footerView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = footerView;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        headerView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = headerView;
        [footerView addSubview:self.nextButton];
        [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView).offset(16);
            make.top.equalTo(footerView).offset(16);
            make.right.equalTo(footerView).offset(-16);
            make.height.equalTo(@(96/2.0));
        }];
        
        UIButton *descButton = [[UIButton alloc] init];
        descButton.enabled = NO;
        [descButton setTitle:@"账户信息很私密 绑定手机更安全" forState:UIControlStateNormal];
        [descButton setImage:[UIImage imageNamed:@"icon_login_safe"] forState:UIControlStateNormal];
        [descButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [descButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        descButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [footerView addSubview:descButton];
        [descButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.top.equalTo(_nextButton.mas_bottom).offset(10);
            make.left.and.right.mas_equalTo(0);
        }];
        
    }
    
    return _tableView;
}


- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _nextButton.layer.cornerRadius = 3;
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton setTitle:NSLocalizedString(@"btn_next", nil) forState:UIControlStateNormal];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_nextButton setBackgroundImage:[UIImage fs_imageWithColor:HEXCOLOR(0xD95149) ] forState:UIControlStateNormal];
        [_nextButton setBackgroundImage:[UIImage fs_imageWithColor:HEXCOLOR(0xB8453F) ] forState:UIControlStateHighlighted];
        [_nextButton setBackgroundImage:[UIImage fs_imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    }
    
    return _nextButton;
}



@end
