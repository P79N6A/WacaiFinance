//
//  FSAssetGuideMaskView.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/16.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//
//
//  对于传入的裁剪矩形，绘制一个带圆角的矩形区域
//  基本实现方式：拆分成中间一个矩形 + 左右两边半圆的方式实现
//

#import "FSAssetGuideMaskView.h"

static NSString *kAssetGuideMaskViewShow = @"FSAssetGuideMaskViewShow";

@interface FSAssetGuideMaskView()

@property (nonatomic, assign) CGRect clipFrame;
@property (nonatomic, assign) CGFloat arrowTop;

@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UIButton *knowImageBtn;


@end

@implementation FSAssetGuideMaskView

- (instancetype)initWithFrame:(CGRect)frame arrowTop:(CGFloat)arrowTop
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _arrowTop = arrowTop;
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
        
        _clipFrame = CGRectMake(8, 22, 99, 36);
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *aColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    
    //奇数
    CGContextAddRect(context, self.bounds);
    
    CGFloat radius = self.clipFrame.size.height / 2.0;
    
    CGRect insetRect = CGRectInset(self.clipFrame, radius, 0);
    
    CGContextAddRect(context, insetRect);
    
    //右半圆
    CGFloat x = self.clipFrame.origin.x + self.clipFrame.size.width - radius;
    CGFloat y = self.clipFrame.origin.y + self.clipFrame.size.height /2.0;
    
    //添加竖线，使得半圆区域闭合
    CGContextMoveToPoint(context, x, self.clipFrame.origin.y);//开始坐标p1
    CGContextAddLineToPoint(context, x, self.clipFrame.origin.y + self.clipFrame.size.height);
    //CGContextStrokePath(context);
    
    CGContextAddArc(context, x, y, radius, - M_PI/2,  M_PI/2, 0);
    
    //左半圆
    //添加竖线 使得半圆区域闭合
    x = self.clipFrame.origin.x + radius;
    y = self.clipFrame.origin.y + self.clipFrame.size.height /2.0;
    
    CGContextMoveToPoint(context, x, self.clipFrame.origin.y);//开始坐标p1
    CGContextAddLineToPoint(context,  x, self.clipFrame.origin.y + self.clipFrame.size.height);
    
    CGContextAddArc(context, x, y, radius, -M_PI/2,  M_PI/2, 1);
    
    //CGContextAddArc(context, 250, 40, 40, 0, 2 * M_PI, 0); //添加一个圆
    //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
    //使用奇偶填充规则
    CGContextDrawPath(context, kCGPathEOFill);
}

- (void)updateClipFrame:(CGRect)clipFrame
{
    self.clipFrame = clipFrame;
    [self setNeedsDisplay];
}

- (void)setupSubViews
{
    self.arrowImageView = [[UIImageView alloc] init];
    self.arrowImageView.image = [UIImage imageNamed:@"asset_mask_arrow"];
    self.arrowImageView.frame = CGRectMake(0, 0, 28, 46);
    [self addSubview:self.arrowImageView];
    
    //NSInteger top = _clipFrame.origin.y + _clipFrame.size.height;
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.arrowTop);
        make.width.equalTo(@(28));
        make.height.equalTo(@(46));
        make.left.equalTo(@(58));
        
    }];

    self.lineImageView = [[UIImageView alloc] init];
    self.lineImageView.image = [UIImage imageNamed:@"asset_mask_line"];
    [self addSubview:self.lineImageView];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.arrowImageView.mas_left).offset(2);
        make.top.equalTo(self.arrowImageView.mas_bottom).offset(9);
        make.width.equalTo(@(196));
        make.height.equalTo(@(78));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:16.0];
    label.text = @"会员中心和金币商城搬家到这里啦~";
    label.numberOfLines = 2;
    label.textColor = [UIColor whiteColor];
    [self.lineImageView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(143));
        make.centerX.equalTo(self.lineImageView.mas_centerX);
        make.centerY.equalTo(self.lineImageView.mas_centerY);
    }];
    
    
    self.knowImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.knowImageBtn setBackgroundImage:[UIImage imageNamed:@"asset_mask_know"] forState:UIControlStateNormal];
    [self.knowImageBtn setBackgroundImage:[UIImage imageNamed:@"asset_mask_know"] forState:UIControlStateHighlighted];
    
    [self addSubview:self.knowImageBtn];
    
    [self.knowImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(48);
        make.bottom.mas_equalTo(-75);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.knowImageBtn addTarget:self action:@selector(onTapTap:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

+ (BOOL)maskViewShouldShow
{
   BOOL hasShow = [[NSUserDefaults standardUserDefaults] boolForKey:kAssetGuideMaskViewShow];
    
    if(!hasShow)
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:YES forKey:kAssetGuideMaskViewShow];
        [userDefault synchronize];
        
         return YES;
    }
    else
    {
        return NO;
    }
}

- (void)onTapTap:(id)sender
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
