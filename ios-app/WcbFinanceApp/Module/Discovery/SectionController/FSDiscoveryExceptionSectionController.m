//
//  FSDiscoveryExceptionSectionController.m
//  Financeapp
//
//  Created by 叶帆 on 29/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryExceptionSectionController.h"
#import "FSDiscoveryExceptionCell.h"
#import "FSDcvrDataExceptionViewModel.h"

@interface FSDiscoveryExceptionSectionController()

@property (nonatomic, strong) FSDcvrDataExceptionViewModel *viewModel;

@end

@implementation FSDiscoveryExceptionSectionController

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenWidth, _viewModel.exceptionCellHeight);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    Class cellClass = [FSDiscoveryExceptionCell class];
    id cell = [self.collectionContext dequeueReusableCellOfClass:cellClass
                                            forSectionController:self
                                                         atIndex:index];
    FSDiscoveryExceptionCell *errorCell = (FSDiscoveryExceptionCell *)cell;
    if (_viewModel.exceptionCellHeight == kTagFinanceServerBannerErrorViewHeight) {
        [errorCell hiddenPlaceHolderView:YES];
    }
    return errorCell;
}

- (void)didUpdateToObject:(id)object {
    
    _viewModel = object;
    
}

@end
