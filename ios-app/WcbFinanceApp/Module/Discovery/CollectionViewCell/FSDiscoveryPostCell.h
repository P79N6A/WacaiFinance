//
//  FSDiscoveryPostCell.h
//  Financeapp
//
//  Created by 叶帆 on 17/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSBaseAnimatedCell.h"
#import "FSDiscoveryPost.h"
#import "CMAttributedLabel.h"

@interface FSDiscoveryPostCell : FSBaseAnimatedCell

@property (nonatomic, strong) CMAttributedLabel *titleLabel;
@property (nonatomic, assign) FSDiscoveryPostType type;
@property (nonatomic, strong) UILabel *moduleNameLabel;
@property (nonatomic, strong) UILabel *authorNameLabel;
@property (nonatomic, strong) UILabel *readCountLabel;
@property (nonatomic, strong) UIImageView *illustrationImageView;


@end
