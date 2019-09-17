//
//  FSDcvrSpaceSectionController.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/5/29.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDcvrSpaceSectionController.h"
#import "FSHomeSpaceCell.h"
#import "FSDcvrSpaceEntity.h"
#import "FSDcvrSpaceCell.h"

@interface FSDcvrSpaceSectionController()
@property(nonatomic, strong) FSDcvrSpaceEntity *entity;
@end


@implementation FSDcvrSpaceSectionController

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    const CGFloat width = self.collectionContext.containerSize.width;
    
    return CGSizeMake(width, 12.);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    Class cellClass  = [FSDcvrSpaceCell class];
    
    id cell = [self.collectionContext dequeueReusableCellOfClass:cellClass forSectionController:self atIndex:index];
    if ([cell isKindOfClass:[FSDcvrSpaceCell class]]) {
        
    }
    
    return cell;
}

- (void)didUpdateToObject:(id)object {
    _entity  = object;
}

- (void)didSelectItemAtIndex:(NSInteger)index{
    
}

@end
