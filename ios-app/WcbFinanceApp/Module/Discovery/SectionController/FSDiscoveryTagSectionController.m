//
//  FSDiscoveryTagSectionViewController.m
//  Financeapp
//
//  Created by 叶帆 on 16/08/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryTagSectionController.h"
#import "FSDiscoveryTagCell.h"

@implementation FSDiscoveryTagSectionController

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenWidth, 52);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    Class cellClass = [FSDiscoveryTagCell class];
    id cell = [self.collectionContext dequeueReusableCellOfClass:cellClass
                                            forSectionController:self
                                                         atIndex:index];
    FSDiscoveryTagCell *discoveryCell = (FSDiscoveryTagCell *)cell;
    return discoveryCell;
}

@end
