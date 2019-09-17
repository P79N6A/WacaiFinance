//
//  FSDcvrSpaceCell.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/5/29.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDcvrSpaceCell.h"

@implementation FSDcvrSpaceCell

- (void)setupSubviews{
    self.contentView.backgroundColor = [UIColor colorWithHex:0xF6F6F6];
    
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    [self.contentView addSubview:topLineView];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    [self.contentView addSubview:bottomLineView];
    
    
    CGRect bounds = self.contentView.bounds;
    
    CGFloat height = 0.5;
    topLineView.frame    = CGRectMake(0, 0, bounds.size.width, height);
    bottomLineView.frame = CGRectMake(0, bounds.size.height - 0.3, bounds.size.width, 0.3);
    
    //    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.top.mas_equalTo(0);
    //
    //    }];
    //
    
    //    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.bottom.mas_equalTo(0);
    //    }];
}

@end
