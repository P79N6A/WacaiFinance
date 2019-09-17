//
//  FSDiscoveryWechatPopView.m
//  WcbFinanceApp
//
//  Created by tesila on 2018/11/20.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryWeChatPopView.h"
#import <Masonry/Masonry.h>

@interface FSDiscoveryWeChatPopView ()

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIButton *closeButton;

@end

@implementation FSDiscoveryWeChatPopView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.backgroundImageView addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.backgroundImageView);
        make.top.equalTo(self.backgroundImageView).mas_offset(6);
        make.width.mas_equalTo(70);
    }];
    
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        UIImage *image = [UIImage imageNamed:@"discovery_wechat_pop"];
        _backgroundImageView = [[UIImageView alloc] initWithImage:image];
        _backgroundImageView.userInteractionEnabled = YES;
    }
    return _backgroundImageView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton addTarget:self action:@selector(onCloseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)onCloseButtonClicked {
    if ([self.delegate respondsToSelector:@selector(onWeChatPopCloseAreaClicked)]) {
        [self.delegate onWeChatPopCloseAreaClicked];
    }
}

@end
