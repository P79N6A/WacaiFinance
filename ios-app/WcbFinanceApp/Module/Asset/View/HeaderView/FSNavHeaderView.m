//
//  FSNavHeaderView.m
//  FinanceApp
//
//  Created by xingyong on 5/31/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSNavHeaderView.h"
#import "UIView+FSUtils.h"
#import "FSProductData.h"
#import "UIColor+FSUtils.h"
#import <i-Finance-Library/FSSDKGotoUtility.h>
#import "UICountingLabel.h"
#import "NSArray+FSUtils.h"
#import "FSTradeListViewController.h"
#import "FSAssetUserInfoView.h"

#import "FSUserLevelInfo.h"
#import "FSAssetUserMemberView.h"
#import <NeutronBridge/NeutronBridge.h>

@interface FSNavHeaderView()<FSAssetUserMemberViewDelegate>

@property (nonatomic, strong) UICountingLabel     *totalAssetLabel;//总资产
@property (nonatomic, strong) UILabel     *assetTitleLabel;//总资产
@property (nonatomic, strong) UIButton    *moneyButton;//理财金
@property (nonatomic, strong) UIButton    *incomeLeftButton;//持仓收益
@property (nonatomic, strong) UIButton    *incomeRightButton;//持仓收益
@property (nonatomic, strong) UILabel     *incomeLabel;//持仓收益
@property (nonatomic, strong) UIButton    *tradeButton;//交易记录
@property (nonatomic, strong) UIButton    *eyeButton;//隐藏显示资产金额
@property (nonatomic, strong) UIButton    *helpButton;//信息提示按钮
@property (nonatomic) BOOL isFlag;//隐藏显示资产金额

@property (nonatomic, assign) double lastValue;

@property (nonatomic, strong) FSAssetUserInfoView *userView; //用户信息页
@property (nonatomic, assign) CGFloat userViewTop;

@property (nonatomic, strong) FSAssetUserMemberView *memberView; //会员入口
@property (nonatomic, strong) UIControl *memberTapControl; //会员入口扩大相应范围

@end

@implementation FSNavHeaderView


- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupBaseView];
        [self addViewConstraint];
        _lastValue = -1;
    }
    return self;
}
- (void)setupBaseView{
    
    [self addSubview:self.assetTitleLabel];
    [self addSubview:self.totalAssetLabel];
    [self addSubview:self.moneyButton];
    [self addSubview:self.incomeLabel];
    [self addSubview:self.incomeLeftButton];
    [self addSubview:self.incomeRightButton];
    [self addSubview:self.tradeButton];
    [self addSubview:self.eyeButton];
    [self addSubview:self.helpButton];
    [self addSubview:self.memberView];
    
    [self addSubview:self.memberTapControl];
}
- (void)addViewConstraint{
    
    [self.assetTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_iPhoneX ? 70. + 24. : 70.);
        make.centerX.equalTo(self).offset(-12);
    }];
    
    CGFloat viewHeight = [self.memberView viewHeight];
    self.userViewTop = FS_StatusBarHeight + 10;
    
    [self.memberView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(viewHeight);
        make.top.mas_equalTo(self.userViewTop);
        make.left.mas_equalTo(16);
        make.width.mas_equalTo(83);
        
    }];
    
    [self.memberTapControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(36);
        make.center.equalTo(self.memberView);
        make.width.equalTo(self.memberView.mas_width);
        
    }];
    
    
    [self.eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_assetTitleLabel.mas_right);
        make.centerY.equalTo(_assetTitleLabel);
        make.width.mas_equalTo(36);
    }];
    
    [self.helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.equalTo(_eyeButton);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        
    }];
    
    [self.totalAssetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(FS_iPhoneX ? 95. + 24. : 95.);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [self.moneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_totalAssetLabel.mas_bottom).offset(2);
        make.height.mas_equalTo(19);
        make.centerX.equalTo(self);
    }];
    
    
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
    }];
    [self.incomeLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(0);
        make.height.equalTo(_incomeLabel.mas_height);
        make.width.equalTo(self).dividedBy(2);
        
    }];
    [self.incomeRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.right.mas_equalTo(0);
        make.height.equalTo(_incomeLabel.mas_height);
        make.width.equalTo(self).dividedBy(2);
    }];
    
    [self.tradeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_StatusBarHeight);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(70, 44));
    }];
    
    self.assetTitleLabel.text = @"总资产 (元)";
    
}
- (void)setProductData:(FSProductData *)productData{
    _productData = productData;
    
    _isFlag = [[NSUserDefaults standardUserDefaults] boolForKey:@"kMoneyFalg"];
    
    if (_isFlag) {
        [self configDefaultData];
    }
    else{
        
        [self configData:_productData];
        
    }
}

- (void)configData:(FSProductData *)productData{
    NSLog(@"-----------productData.mtext1---1111- %@",productData.mtext1);
    
    
    
    NSString *incomeStr = nil;
    if([productData.mtag2 length] ==0 && [productData.mtext2 length] ==0){
        incomeStr = @"昨日收益 --   |   累计收益 --";
    }else if([productData.mtag2 length] ==0 || [productData.mtext2 length] ==0){
        incomeStr = [productData.mtag2 stringByAppendingString:productData.mtext2];
    }else{
        incomeStr = [NSString stringWithFormat:@"%@   |   %@", productData.mtag2,productData.mtext2];
    }
    
    self.incomeLabel.attributedText = [self formatterStr:incomeStr];
    
    
    if([productData.mtext3 length]){
        self.moneyButton.hidden = NO;
        NSString *money = [NSString stringWithFormat:@"  %@ ",StringValue(productData.mtext3)];
        [self.moneyButton setTitle:money forState:UIControlStateNormal];
    }else{
        self.moneyButton.hidden = YES;
    }
    
    [self.eyeButton setImage:[UIImage imageNamed:@"eye_normal"] forState:UIControlStateNormal];
    
    if ([AFNetworkReachabilityManager manager].isReachable) {
        _totalAssetLabel.text = @"--";
    }
    if (!productData.misCache) {
        
        if ([productData.mtext1 isEqualToString:@"--"]) {
            
            _totalAssetLabel.text = @"--";
        }
        else
        {
            
            double text1Value = [self.productData.mtext1 doubleValue];
            
            if (_lastValue != text1Value) {
                
                if (text1Value >= 0.0) {
                    [_totalAssetLabel countFrom:0.0 to:text1Value withDuration:1.5];
                    
                    __weak typeof(self) weakSelf = self;
                    _totalAssetLabel.completionBlock = ^(void){
                        weakSelf.totalAssetLabel.text = [NSString stringWithFormat:@"%.2f",text1Value];
                    };
                    
                }else{
                    
                    _totalAssetLabel.text = @"--";
                }
                
                
            }else{
                _totalAssetLabel.text = [NSString stringWithFormat:@"%.2f",text1Value];
                
            }
            
            _lastValue = text1Value;
        }
        
    }
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {

        _totalAssetLabel.text = @"--";
        return;
    }
    if (productData.misCache) {
        return;
    }
    
    
    if ([productData.mtext1 isEqualToString:@"--"]) {
        _totalAssetLabel.text = @"--";
        
    }else{
        
        double text1Value = [self.productData.mtext1 doubleValue];
        
        if (_lastValue != text1Value) {
            
            if (text1Value >= 0.0) {
                [_totalAssetLabel countFrom:0.0 to:text1Value withDuration:1.5];
                __weak typeof(self) weakSelf = self;
                _totalAssetLabel.completionBlock = ^(void){
                    weakSelf.totalAssetLabel.text = [NSString stringWithFormat:@"%.2f",text1Value];
                };
                
            }else{
                
                _totalAssetLabel.text = @"--";
            }
            
        }else{
            _totalAssetLabel.text = [NSString stringWithFormat:@"%.2f",text1Value];
            
        }
        
        _lastValue = text1Value;
    }
    
    
    
    
}

- (void)configDefaultData{
    self.moneyButton.hidden = YES;
    
    [self.eyeButton setImage:[UIImage imageNamed:@"eye_select"] forState:UIControlStateNormal];
    self.totalAssetLabel.text = @"* * * * *";
    
    NSArray *leftArray = [self.productData.mtag2 componentsSeparatedByString:@" "];
    NSString *leftString = @"";
    
    NSArray *rightArray = [self.productData.mtext2 componentsSeparatedByString:@" "];
    NSString *rightString = @"";
    
    if([leftArray count]){
        leftString = [leftArray fs_objectAtIndex:0];
    }
    
    if([rightArray count]){
        rightString = [rightArray fs_objectAtIndex:0];
    }
    
    if([self.productData.mtag2 length] && [self.productData.mtext2 length] ){
        NSString *content = [NSString stringWithFormat:@"%@ * * * *    |    %@ * * * *",leftString,rightString];
        self.incomeLabel.attributedText  = [self formatterStr:content];
    }else if([self.productData.mtext2 length]){
        self.incomeLabel.text  = [NSString stringWithFormat:@"%@ * * * *",rightString];
    }else if([self.productData.mtag2 length]){
        self.incomeLabel.text  = [NSString stringWithFormat:@"%@ * * * *",leftString];
    }
    
}
- (NSMutableAttributedString *)formatterStr:(NSString *)incomeStr{
    
    if ([incomeStr length]) {
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:incomeStr];
        if ([incomeStr CM_isContain:@"|"]) {
            NSRange range = [incomeStr rangeOfString:@"|"];
            
            [attributed addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:0.2]}
                                range:range];
            
        }
        return attributed;
    }
    return nil;
}

- (void)updateUserLevelView:(FSUserLevelInfo *)levelInfo {
    [self.memberView updateUserLevelView:levelInfo];
    
    CGFloat memberViewWidth = [self.memberView widthForLevelInfo:levelInfo];
    
    self.memberView.width = memberViewWidth;
    [self.memberView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(memberViewWidth);
    }];
}


- (CGFloat)userInfoViewBottom
{
    return self.userViewTop + [self.memberView viewHeight];
}

- (CGRect)userInfoViewFrame
{
    return self.memberView.frame;
}

#pragma mark - 隐藏or显示资产金额 -
- (void)onHiddenAction:(id)sender{
    _isFlag = !self.isFlag;
    
    
    if (_isFlag) {
        [self configDefaultData];
        [_totalAssetLabel stopWhenHidden];
        
    }else{
        [self configData:self.productData];
        
    }
    [[NSUserDefaults standardUserDefaults] setBool:_isFlag forKey:@"kMoneyFalg"];
    
    if (self.buttonActionBlock) {
        self.buttonActionBlock(FSHeaderButtonTypeHideMoney);
    }
}
#pragma mark - 跳转到交易记录 -
- (void)onTradeAction:(id)sender{
    
    [UserAction skylineEvent:@"finance_wcb_myassets_transrecord_click"];
    
    NSString *source = [NSString stringWithFormat:@"%@", @"nt://sdk-finance-asset/new-trade-record"];
    NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:self.fs_parentViewController];
    [ns ntWithSource:source
  fromViewController:self.fs_parentViewController
          transiaion:NTBViewControllerTransitionPush
              onDone:^(NSString * _Nullable result) {
                  
              } onError:^(NSError * _Nullable error) {
                  
              }];
}

- (void)onIncomeLeftAction:(id)sender{ // 昨日收益
    [UserAction skylineEvent:@"finance_wcb_myassets_yesterdayearning_click"];
    
    UIViewController *parentViewController = self.fs_parentViewController;
    [FSSDKGotoUtility openURL:self.productData.murl from:parentViewController];
    
}
- (void)onIncomeRightAction:(id)sender{// 累计收益
    
    [UserAction skylineEvent:@"finance_wcb_myassets_income_click"];
    
    UIViewController *parentViewController = self.fs_parentViewController;
    [FSSDKGotoUtility openURL:self.productData.murl from:parentViewController];
}



- (UILabel *)assetTitleLabel{
    if (!_assetTitleLabel) {
        _assetTitleLabel                 = [[UILabel alloc] init];
        _assetTitleLabel.textColor       = [UIColor whiteColor];
        _assetTitleLabel.font            = [UIFont systemFontOfSize:15];
        _assetTitleLabel.backgroundColor = [UIColor clearColor];
        _assetTitleLabel.textAlignment   = NSTextAlignmentCenter;
    }
    return _assetTitleLabel;
}

- (UICountingLabel *)totalAssetLabel{
    if (!_totalAssetLabel) {
        
        _totalAssetLabel                 = [[UICountingLabel alloc] init];
        _totalAssetLabel.textColor       = [UIColor whiteColor];
        _totalAssetLabel.font            = [UIFont boldSystemFontOfSize:32];
        _totalAssetLabel.backgroundColor = [UIColor clearColor];
        _totalAssetLabel.textAlignment   = NSTextAlignmentCenter;
        _totalAssetLabel.method = UILabelCountingMethodLinear;
        _totalAssetLabel.format = @"%.2f";
        _totalAssetLabel.text   = @"--";
        
    }
    return _totalAssetLabel;
}


- (UILabel *)incomeLabel{
    if (!_incomeLabel) {
        _incomeLabel               = [[UILabel alloc] init];
        _incomeLabel.textColor     = [UIColor whiteColor];
        _incomeLabel.font          = [UIFont systemFontOfSize:14];
        _incomeLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _incomeLabel;
}
- (UIButton *)incomeLeftButton{
    if (!_incomeLeftButton) {
        _incomeLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_incomeLeftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_incomeLeftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_incomeLeftButton addTarget:self action:@selector(onIncomeLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _incomeLeftButton;
}

- (UIButton *)incomeRightButton{
    if (!_incomeRightButton) {
        _incomeRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_incomeRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_incomeRightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_incomeRightButton addTarget:self action:@selector(onIncomeRightAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _incomeRightButton;
}

- (UIButton *)moneyButton{
    if (!_moneyButton) {
        
        _moneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moneyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_moneyButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
        _moneyButton.layer.borderWidth  = 0.6f;
        _moneyButton.layer.borderColor  = [UIColor colorWithHexString:@"#e9a19b"].CGColor;
        _moneyButton.layer.cornerRadius = 2.0f;
        
    }
    return _moneyButton;
}

- (UIButton *)tradeButton{
    if (!_tradeButton) {
        _tradeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tradeButton setTitle:@"交易记录" forState:UIControlStateNormal];
        [_tradeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tradeButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_tradeButton addTarget:self action:@selector(onTradeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tradeButton;
}

- (UIButton *)eyeButton{
    if (!_eyeButton) {
        _eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_eyeButton setImage:[UIImage imageNamed:@"eye_normal"] forState:UIControlStateNormal];
        [_eyeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_eyeButton addTarget:self action:@selector(onHiddenAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eyeButton;
}
- (UIButton *)helpButton{
    if (!_helpButton) {
        _helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_helpButton setImage:[UIImage imageNamed:@"asset_help"] forState:UIControlStateNormal];
        [_helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_helpButton addTarget:self action:@selector(onHelpAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpButton;
}

- (FSAssetUserInfoView *)userView
{
    if(!_userView)
    {
        _userView = [[FSAssetUserInfoView alloc] initWithFrame:CGRectZero];
    }
    return _userView;
}

- (FSAssetUserMemberView *)memberView
{
    if(!_memberView)
    {
        _memberView = [[FSAssetUserMemberView alloc] initWithFrame:CGRectZero];
        _memberView.delegate = self;
    }
    return _memberView;
}

- (UIControl *)memberTapControl
{
    if(!_memberTapControl)
    {
        _memberTapControl = [[UIControl alloc] initWithFrame:CGRectZero];
        [_memberTapControl addTarget:self action:@selector(memberViewTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _memberTapControl;
}

- (void)memberViewTap:(id)sender
{
    [UserAction skylineEvent:@"finance_wcb_myassets_member_click"];
    
    if (self.buttonActionBlock) {
        self.buttonActionBlock(FSHeaderButtonTypeUserInfo);
    }
}

#pragma mark - FSAssetUserMemberViewDelegate
- (void)userMemberViewTap
{
    [UserAction skylineEvent:@"finance_wcb_myassets_member_click"];
    
    if (self.buttonActionBlock) {
        self.buttonActionBlock(FSHeaderButtonTypeUserInfo);
    }
}

- (void)onHelpAction:(id)sender{
    if (self.buttonActionBlock) {
        self.buttonActionBlock(FSHeaderButtonTypeHelp);
    }
}

inline static NSString *StringValue(id obj)
{
    if([obj isKindOfClass:[NSString class]]){
        return (NSString *)obj;
    }else if ([obj isKindOfClass:[NSNull class]]|| obj == nil) {
        return  @"";
    }else if ([obj isKindOfClass:[NSNumber class]]) {
        return  [NSString stringWithFormat:@"%@",[obj description]];
    } else{
        return @"";
    }
    return @"";
}
@end


