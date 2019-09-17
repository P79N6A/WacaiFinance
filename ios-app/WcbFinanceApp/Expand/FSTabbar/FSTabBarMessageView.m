//
//  FSTabBarMessageView.m
//  WcbFinanceApp
//
//  Created by 叶帆 on 2018/8/30.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSTabBarMessageView.h"

@interface FSTabBarMessageView()

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *closeButton;

@end

@implementation FSTabBarMessageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
        [tapRecognizer addTarget:self action:@selector(onViewTapped)];
        [self addGestureRecognizer:tapRecognizer];
        
        [self addSubview:self.backgroundImageView];
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.closeButton];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.height.width.equalTo(@24);
            make.right.equalTo(self).mas_offset(-16);
        }];
        
        [self addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.height.equalTo(@22);
            make.left.equalTo(self).mas_offset(60);
            make.right.equalTo(self.closeButton.mas_left).mas_offset(-12);
        }];
    }
    return self;
}

#pragma mark - Public Methods

- (void)hide {
    self.hidden = YES;
}

- (void)showMessage:(NSString *)content {
    if ([content CM_isValidString]) {
        self.hidden = NO;
        self.contentLabel.text = content;
    }
}


#pragma mark - Interaction Methos
- (void)onCloseButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCloseClicked)]) {
        [self.delegate onCloseClicked];
    } else {
        [self hide];
    }
}

- (void)onViewTapped {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onMessageClicked)]) {
        [self.delegate onMessageClicked];
    }
}

#pragma mark - getter & setter
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        UIImage *backgroundImage = [UIImage imageNamed:@"tab_message_coupon"];
        _backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImageView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        UIImage *closeImage = [UIImage imageNamed:@"tab_message_close"];
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:closeImage forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(onCloseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return _contentLabel;
}

@end
