//
//  FSBasePopupView.m
//  FinanceApp
//
//  Created by xingyong on 09/11/2016.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSBasePopupView.h"
#import <CMDevice/CMDevice.h>
@interface FSBasePopupView ()

@property(nonatomic,strong) UIButton *closeButton;
@property(nonatomic,strong) UIButton *backgroundButton;
@property(nonatomic,copy) void (^actionBlock)(UIButton *button);

@end

@implementation FSBasePopupView

- (instancetype)initWithFrame:(CGRect)frame action:(void (^)(UIButton *button)) block{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.actionBlock = block;
        [self setupBaseView];
    }
    return self;
}
- (void)setupBaseView{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backgroundButton];
    [self addSubview:self.closeButton];
 
    [self.backgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
 
        make.center.equalTo(self);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*5/6);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.width);
    }];
     
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
 
    
}
- (void)setPopupImage:(UIImage *)popupImage{
    _popupImage = popupImage;

    [self.backgroundButton setImage:popupImage forState:UIControlStateNormal];
    
}


- (UIButton *)backgroundButton{
    if (!_backgroundButton) {
        _backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundButton.tag = 1;
        _backgroundButton.showsTouchWhenHighlighted = NO;
        [_backgroundButton addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundButton;
}
- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"popup_win_close"] forState:UIControlStateNormal];
        _closeButton.tag = 2;
        [_closeButton addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (void)dismissAction:(UIButton *)button{
    if (self.actionBlock) {
        self.actionBlock(button);
    }
}
@end
