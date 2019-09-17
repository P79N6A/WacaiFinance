//
//  FSHomeGuideView.m
//  FinanceApp
//
//  Created by xingyong on 22/12/2016.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSHomeGuideView.h"
#import "AppDelegate.h"
#import "FSTabbarController.h"


@implementation FSHomeGuideView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    CGRect screen        = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    UIBezierPath *path   = [UIBezierPath bezierPathWithRect:screen];
    // 画圆
    CGFloat itemWith     = screen.size.width/4;
  
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(screen.size.width - itemWith * 2 + itemWith/2, screen.size.height - 16.)
                                                    radius:33.
                                                startAngle:0
                                                  endAngle:2*M_PI
                                                 clockwise:NO]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [self.layer setMask:shapeLayer];
    
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.frame = CGRectMake(screen.size.width/2, screen.size.height - 80, itemWith,80);
    bottomButton.backgroundColor = [UIColor clearColor];
    [bottomButton addTarget:self action:@selector(onButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bottomButton];
    
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_guide_line"]];
    [self addSubview:lineImageView];
    
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-40);
        make.centerX.equalTo(self).offset(-20);
    }];
    
    UIImageView *redPacket = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_guide_thumb"]];
    [self addSubview:redPacket];
    [redPacket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineImageView.mas_top);
        make.centerX.equalTo(lineImageView.mas_left).offset(10);
    }];
}
- (void)onButtonAction:(UIButton *)button{
 
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *controllers = appdelegate.fs_navgationController.viewControllers;
    FSTabbarController *tabBarController = (FSTabbarController *)[controllers firstObject];
    
    FSTabBarItem *tabbarItem = [tabBarController.lcTabBar.tabBarItems fs_objectAtIndex:2];
    [tabBarController.lcTabBar buttonClick:tabbarItem];
}




@end
