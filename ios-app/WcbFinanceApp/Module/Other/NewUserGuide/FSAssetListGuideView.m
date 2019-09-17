//
//  FSAssetListGuideView.m
//  FinanceApp
//
//  Created by xingyong on 22/12/2016.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSAssetListGuideView.h"

@implementation FSAssetListGuideView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_guide_asset"]];
    [self addSubview:bgImageView];
    
    
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-50);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
}

@end
