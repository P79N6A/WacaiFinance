//
//  FSBaseViewController.m
//  XYSegmentViewController
//
//  Created by xingyong on 9/16/15.
//  Copyright (c) 2015 xingyong. All rights reserved.
//

#import "FSBaseViewController.h"
#import "UIViewController+FSUtil.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


@interface FSBaseViewController ()

@end

@implementation FSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupBaseView];
    [self setupNavgationViewStyle:[self navgationStyle]];

}
- (void)setupBaseView{
    [self.view addSubview:self.navgationView];
    [self.navgationView addSubview:self.titleLabel];
    [self.navgationView addSubview:self.baseLineView];
    [self.navgationView addSubview:self.backButton];
    [self.navgationView addSubview:self.rightButton];
    
    [self.navgationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(FS_NavigationBarHeight);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_StatusBarHeight);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.bottom.mas_equalTo(0);
    }];
    [self.baseLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_StatusBarHeight);
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(50);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_StatusBarHeight);
        make.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(70);
        
    }];
    
    if ([self.navigationController.viewControllers count] > 1) {
        self.backButton.hidden = NO;
    } else{
        self.backButton.hidden = YES;
    }
    
    if ([self fs_isModal]) {
        self.backButton.hidden = NO;
    }
    


}
- (FSNavgationViewStyle)navgationStyle{
    
    if([self.navigationController.viewControllers count] > 1){
        
        return FSNavgationViewStyleWhite;
    }
    else{
        return FSNavgationViewStyleDarkRed;
    }
}

- (void)setupRightButtonImage:(NSString *)imageName{
    self.rightButton.hidden = NO;
    
    [self.rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:imageName]forState:UIControlStateHighlighted];
}
- (void)setupRightButtonTitle:(NSString *)title{
    
    self.rightButton.hidden = NO;
    [self.rightButton setTitle:title forState:UIControlStateNormal];
    [self.rightButton setTitle:title forState:UIControlStateHighlighted];
}
- (void)setupNavgationViewStyle:(FSNavgationViewStyle)style{
    
    NSString *imageName = nil;
    if(style == FSNavgationViewStyleDarkRed){
        
        _navgationView.backgroundColor = [UIColor colorWithHex:0xd84a3f];
        imageName = @"back_arrow_white";
        _titleLabel.textColor = [UIColor whiteColor];
        _baseLineView.hidden = YES;
    }
    else
    {
        _navgationView.backgroundColor = [UIColor whiteColor];
        imageName = @"back_arrow";
        _titleLabel.textColor = [UIColor blackColor];
        _baseLineView.hidden = NO;
    }
    
    [_backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.navgationStyle == FSNavgationViewStyleDarkRed) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}
/**
 *   头部标题
 *
 *  @return 头部标题
 */
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = self.title;
    }
    
    return _titleLabel;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.titleLabel.text = title;
}
/**
 *  头部视图
 *
 *  @return 头部视图
 */
- (UIView *)navgationView{
    if (_navgationView == nil) {
        _navgationView = [[UIView alloc] init];
    }
    
    return _navgationView;
}
- (UIView *)baseLineView{
    if (_baseLineView == nil) {
        
        _baseLineView = [[UIView alloc] init];
        _baseLineView.backgroundColor = [UIColor colorWithHex:0xe7e7e7];
        
    }
    return _baseLineView;
}

/**
 *  头部返回按钮
 *
 *  @return 返回按钮
 */
- (UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(onBackAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)rightButton{
    if (_rightButton == nil) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.hidden = YES;
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_rightButton addTarget:self action:@selector(onRightAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}


- (void)onBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)onRightAction:(id)sender{
    
}



@end


