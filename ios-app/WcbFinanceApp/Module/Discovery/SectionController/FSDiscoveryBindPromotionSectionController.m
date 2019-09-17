//
//  FSDiscoveryBindPromotionSectionController.m
//  Financeapp
//
//  Created by 叶帆 on 23/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryBindPromotionSectionController.h"
#import "FSDiscoveryBindPromotionCell.h"
#import "FSDiscoveryEntity.h"
#import "FSDcvrBindPromotionViewModel.h"
#import <i-Finance-Library/FSSDKGotoUtility.h>


@interface FSDiscoveryBindPromotionSectionController ()

@property (nonatomic, strong) FSDcvrBindPromotionViewModel *viewModel;

@end

@implementation FSDiscoveryBindPromotionSectionController

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenWidth, 45);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    Class cellClass = [FSDiscoveryBindPromotionCell class];
    id cell = [self.collectionContext dequeueReusableCellOfClass:cellClass
                                            forSectionController:self
                                                         atIndex:index];
    FSDiscoveryBindPromotionCell *promotionCell = (FSDiscoveryBindPromotionCell *)cell;
    
    promotionCell.contentLabel.text = self.viewModel.bindPromotionText;
    return promotionCell;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    NSString *neutronSource = @"nt://WcbFinanceApp/binding-info";
    [FSSDKGotoUtility openURL:neutronSource from:self.viewController];
}

- (void)didUpdateToObject:(id)object {
    _viewModel = object;
}

@end
