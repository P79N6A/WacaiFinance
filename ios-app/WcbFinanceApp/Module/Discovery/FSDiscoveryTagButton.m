//
//  FSDiscoveryTagButton.m
//  Financeapp
//
//  Created by 叶帆 on 16/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryTagButton.h"

@implementation FSDiscoveryTagButton

+ (instancetype)buttonWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title];
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 12;
        self.clipsToBounds = YES;
        self.layer.borderColor = [UIColor colorWithHexString:@"#FFE4E4E4"].CGColor;
        self.layer.borderWidth = 0.5;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"#FF666666"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage fs_imageWithColor:[UIColor colorWithHexString:@"#FFFAFAFA"]] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage fs_imageWithColor:[UIColor colorWithHexString:@"#FFD84A3F"]] forState:UIControlStateSelected];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    CGSize originSize = [super intrinsicContentSize];
    CGSize expandSize = CGSizeMake(originSize.width + 24, originSize.height + 8);
    return expandSize;
}

- (void)setHighlighted:(BOOL)highlighted {
    //覆写以屏蔽系统级实现
}


@end
