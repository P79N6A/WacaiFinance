//
//  FSDcvrFinServerBannerSectionController.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/13.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDcvrFinServerBannerSectionController.h"
#import "FSDcvrBannerViewModel.h"
#import "FSDiscoveryBannerCell.h"
#import "FSDiscoveryBanner.h"
#import "FSDcvrBannerImageCell.h"
#import <UIImageView+WebCache.h>
#import "FSDcvrBannerCell.h"
#import <i-Finance-Library/FSSDKGotoUtility.h>


@interface FSDcvrFinServerBannerSectionController()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) FSDcvrBannerViewModel *viewModel;

@end

@implementation FSDcvrFinServerBannerSectionController

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    return CGSizeMake(screenWidth, [FSDcvrBannerViewModel bannerHeight]);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    Class cellClass = [FSDcvrBannerCell class];
    id cell = [self.collectionContext dequeueReusableCellOfClass:cellClass
                                            forSectionController:self
                                                         atIndex:index];
    FSDcvrBannerCell *bannerCell = (FSDcvrBannerCell *)cell;
    
    [bannerCell.collectionView registerClass:[FSDcvrBannerImageCell class] forCellWithReuseIdentifier:[FSDcvrBannerImageCell cellIdentifer]];
    
    UICollectionViewFlowLayout *flowLayout = bannerCell.flowLayout;
    flowLayout.minimumInteritemSpacing = [FSDcvrBannerViewModel itemSpacing];
    flowLayout.sectionInset = [FSDcvrBannerViewModel sectionInset];
    
    bannerCell.collectionView.delegate = self;
    bannerCell.collectionView.dataSource = self;
    
    [UIView animateWithDuration:0 animations:^{
        
        if(self.viewModel.banners.count > 0)
        {
            //fix tab 切换、下拉刷新后数据左右抖动，强制滚动到第一个
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [bannerCell.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }];
    
    return bannerCell;
}

- (void)didUpdateToObject:(id)object {
    _viewModel = object;
    
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *banners = self.viewModel.banners;
    return banners.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSDcvrBannerImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FSDcvrBannerImageCell cellIdentifer] forIndexPath:indexPath];
    
    NSArray *banners = self.viewModel.banners;
    FSDiscoveryBanner *banner = [banners fs_objectAtIndex:indexPath.row];
    
    NSString *imgURL = banner.imgURL;
    if ([imgURL CM_isValidString]) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imgURL]];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [FSDcvrBannerViewModel imageCellSize];
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSDiscoveryBanner *banner = [self.viewModel.banners fs_objectAtIndex:indexPath.row];
    
    NSString *linkURL = banner.linkURL;
    NSString *bannerID = banner.bannerID ?: @"";
    NSString *bannerURL = banner.imgURL ?: @"";
    NSString *position = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    
    if ([linkURL CM_isValidString]) {
        [FSSDKGotoUtility openURL:linkURL from:self.viewController];
        
        NSDictionary *s_attributes = @{@"lc_banner_id":bannerID,
                                       @"lc_banner_url":bannerURL, @"lc_jump_url":linkURL,
                                       @"lc_position":position};
        [UserAction skylineEvent:@"finance_wcb_find_banner_click" attributes:s_attributes];
        
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(dcvrFinServerBannerSectionDidClicked)])
        {
            [self.delegate dcvrFinServerBannerSectionDidClicked];
        }
    }
}


@end
