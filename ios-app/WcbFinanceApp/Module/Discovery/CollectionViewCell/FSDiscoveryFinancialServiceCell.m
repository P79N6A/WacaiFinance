//
//  FSDiscoveryFinancialServiceCell.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/10.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryFinancialServiceCell.h"
#import "FSDiscoverFServiceMenuCell.h"

@interface FSDiscoveryFinancialServiceCell()

@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIImageView *errorImageView;

@end;


@implementation FSDiscoveryFinancialServiceCell

- (instancetype)initWithFrame:(CGRect)frame
{
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

- (void)dealloc
{
    NSLog(@"Dealloc %@", self);
}

- (void)setupSubviews
{
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
    
    
    UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    [view registerClass:[FSDiscoverFServiceMenuCell class] forCellWithReuseIdentifier:[FSDiscoverFServiceMenuCell cellIdentifer]];
    
    view.backgroundColor = [UIColor whiteColor];
    view.alwaysBounceVertical = NO;
    view.alwaysBounceHorizontal = YES;
    view.showsVerticalScrollIndicator = NO;
    view.showsHorizontalScrollIndicator = NO;
    view.scrollEnabled = NO;
    
    self.collectionView = view;
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.verticalLine.backgroundColor = [UIColor colorWithHexString:@"ECECEC"];
    [self.collectionView addSubview:self.verticalLine];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.contentView);
        
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.verticalLine.frame = CGRectMake(self.collectionView.bounds.size.width/2.0, 15, 1, self.collectionView.bounds.size.height - 30);
}




@end
