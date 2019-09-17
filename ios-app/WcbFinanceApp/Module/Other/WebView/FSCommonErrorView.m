//
//  FSErrorView.m
//  WcbFinanceApp
//
//  Created by 金镖 on 2018/10/11.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSCommonErrorView.h"

@interface FSCommonErrorView ()
@property (nonatomic, strong) UIButton *reloadTipImageButton;
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) UIButton *reloadTipContentButton;
@end

@implementation FSCommonErrorView


-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.reloadTipImageView];
    [self addSubview:self.reloadButton];
    [self addSubview:self.reloadTipContentButton];

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width  = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat imageViewWidth = 120.f;
    CGFloat imageViewHeight = 120.f;
    
    CGFloat padding = 5.f;
    
    self.reloadTipImageButton.frame = CGRectMake((width-imageViewWidth)/2,height*0.2f,imageViewWidth,imageViewHeight);
    self.reloadButton.frame = CGRectMake((width - 200.f) / 2,height*0.2f + imageViewHeight + padding,200.f,30.f);
    CGRect rect = CGRectMake((width - 92.f) / 2, height*0.2f + imageViewHeight + padding + 50., 92.f, 34.f);
    self.reloadTipContentButton.frame = rect;
}

#pragma mark - responseChain
-(void)onReloadButtonClicked:(UIButton *)btn
{
    if (self.reloadAction) {
        self.reloadAction();
    }
}

#pragma mark - getter
-(UIButton *)reloadTipImageView
{
    if (!_reloadTipImageButton) {
        _reloadTipImageButton = [[UIButton alloc] init];
        [_reloadTipImageButton setBackgroundImage:[UIImage imageNamed:@"exception_placeholder"] forState:UIControlStateNormal];
        [_reloadTipImageButton setBackgroundImage:[UIImage imageNamed:@"exception_placeholder"] forState:UIControlStateHighlighted];
        [_reloadTipImageButton addTarget:self action:@selector(onReloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadTipImageButton;
}

-(UIButton *)reloadButton
{
    if (!_reloadButton) {
        _reloadButton = [[UIButton alloc] init];
        [_reloadButton addTarget:self action:@selector(onReloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_reloadButton setTitle:@"加载异常，请重试" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor colorWithHexString:@"#A2ABB8"] forState:UIControlStateNormal];
        [_reloadButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    }
    return _reloadButton;
}


-(UIButton *)reloadTipContentButton
{
    if (!_reloadTipContentButton) {
        _reloadTipContentButton = [[UIButton alloc] init];
        [_reloadTipContentButton addTarget:self action:@selector(onReloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_reloadTipContentButton setImage:[UIImage imageNamed:@"retry_btn"]
                                 forState:UIControlStateNormal];
        [_reloadTipContentButton setImage:[UIImage imageNamed:@"retry_btn_lighted"]
                                 forState:UIControlStateHighlighted];
    }
    return _reloadTipContentButton;
}



@end
