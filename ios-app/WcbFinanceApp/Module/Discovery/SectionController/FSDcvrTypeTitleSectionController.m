//
//  FSDcvrTypeTitleSectionController.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/19.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDcvrTypeTitleSectionController.h"
#import "FSDiscoveryTypeTitleData.h"
#import "FSDcvrTypeTitleCell.h"
#import "TPKWebViewController.h"
#import "FSShortLineCell.h"
#import <i-Finance-Library/FSSDKGotoUtility.h>

@interface FSDcvrTypeTitleSectionController()

@property(nonatomic, strong) FSDiscoveryTypeTitleData *typeData;

@end

@implementation FSDcvrTypeTitleSectionController

- (NSInteger)numberOfItems {
    
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    const CGFloat width = self.collectionContext.containerSize.width;
    
    return CGSizeMake(width, 41.0);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index
{
    Class cellClass;

    cellClass  = [FSDcvrTypeTitleCell class];

    id cell = [self.collectionContext dequeueReusableCellOfClass:cellClass forSectionController:self atIndex:index];
    if ([cell isKindOfClass:[FSDcvrTypeTitleCell class]]) {
        
        [cell setTitleData:_typeData];
        [cell adjustForDiscovery];
    }
    return cell;
}

- (void)didUpdateToObject:(id)object {
    _typeData  = object;
    
}
- (void)didSelectItemAtIndex:(NSInteger)index{
    
    if([_typeData.titleURL CM_isValidString]) {
        [FSSDKGotoUtility openURL:_typeData.titleURL from:self.viewController];
    }
}



@end
