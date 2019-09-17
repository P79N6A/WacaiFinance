//
//  FSDiscoveryVerticalLineCell.m
//  Financeapp
//
//  Created by kuyeluofan on 19/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryVerticalLineCell.h"

@implementation FSDiscoveryVerticalLineCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *vipButtonSepretLine = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        view;
    });
    [self.contentView addSubview:vipButtonSepretLine];
    [vipButtonSepretLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.equalTo(@0.5);
        make.height.equalTo(@22);
    }];
}

@end
