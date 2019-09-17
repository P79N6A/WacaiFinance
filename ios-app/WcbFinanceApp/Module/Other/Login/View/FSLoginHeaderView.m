//
//  FSLoginHeaderView.m
//  FinanceApp
//
//  Created by xingyong on 12/2/15.
//  Copyright © 2015 com.wacai.licai. All rights reserved.
//

#import "FSLoginHeaderView.h"

@implementation FSLoginHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
 
//    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_wacai"]];
//
//    [self addSubview:logoImageView];
//    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(@0);
//    }];
    

    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:26.0];
    if(!font)
    {
        font = [UIFont systemFontOfSize:26.0];
    }
    
    UILabel *welcomeLabel = [[UILabel alloc] init];
    welcomeLabel.font = font;
    welcomeLabel.textColor = [UIColor colorWithHex:0x333333];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.text = @"欢迎回来";
    [self addSubview:welcomeLabel];
    [welcomeLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(36);
        make.left.mas_equalTo(23);
        make.height.mas_equalTo(37);
        
    }];
//
//    UILabel *descLabel = [[UILabel alloc] init];
//    descLabel.font = [UIFont systemFontOfSize:13];
//    descLabel.textColor = [UIColor lightGrayColor];
//    descLabel.textAlignment = NSTextAlignmentCenter;
//    descLabel.text = @"我们一直在等您";
//    [self addSubview:descLabel];
//    [descLabel makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(welcomeLabel.mas_bottom).offset(0);
//        make.left.and.right.mas_equalTo(0);
//        make.height.mas_equalTo(21);
//        
//    }];
    
}


@end
