//
//  FSDcvrBannerImageCell.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/13.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDcvrBannerImageCell.h"

@implementation FSDcvrBannerImageCell

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
    self.imageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.cornerRadius = 2;
        imageView.clipsToBounds = YES;
        imageView;
    });
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.contentView);
    }];
}

+ (NSString *)cellIdentifer
{
    return NSStringFromClass([self class]);
}

@end
