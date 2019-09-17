//
//  FSDiscoveryBannerSectionController.m
//  Financeapp
//
//  Created by 叶帆 on 17/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryBannerSectionController.h"
#import "FSDiscoveryBannerCell.h"
#import "FSDiscoveryEntity.h"
#import "FSBannerEmbeddedSectionController.h"
#import "FSDcvrBannerViewModel.h"

@interface FSDiscoveryBannerSectionController ()<IGListAdapterDataSource, FSBannerEmbeddedSetcionDelegate>

@property (nonatomic, strong) FSDcvrBannerViewModel *viewModel;
@property (nonatomic, strong) IGListAdapter *adapter;

@end

@implementation FSDiscoveryBannerSectionController

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenWidth, 132);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    Class cellClass = [FSDiscoveryBannerCell class];
    id cell = [self.collectionContext dequeueReusableCellOfClass:cellClass
                                            forSectionController:self
                                                         atIndex:index];
    FSDiscoveryBannerCell *bannerCell = (FSDiscoveryBannerCell *)cell;
    self.adapter.collectionView = bannerCell.collectionView;
    return bannerCell;
}

- (void)didUpdateToObject:(id)object {
    _viewModel = object;
}

- (IGListAdapter *)adapter {
    if (!_adapter) {
        _adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self.viewController];
        _adapter.dataSource = self;
    }
    return _adapter;
}

#pragma mark - IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return @[self.viewModel];
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    FSBannerEmbeddedSectionController *embeddedSectionController = [[FSBannerEmbeddedSectionController alloc] init];
    embeddedSectionController.delegate = self;
    return embeddedSectionController;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - FSBannerEmbeddedSection Delegate
- (void)bannerEmbeddedSectionDidClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(discoveryBannerSectionDidClicked)]) {
        [self.delegate discoveryBannerSectionDidClicked];
    }
}

@end
