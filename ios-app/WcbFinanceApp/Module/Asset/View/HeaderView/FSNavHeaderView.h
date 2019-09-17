//
//  FSNavHeaderView.h
//  FinanceApp
//
//  Created by xingyong on 5/31/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, FSHeaderButtonType) {
    FSHeaderButtonTypeHelp,
    FSHeaderButtonTypeHideMoney,
    FSHeaderButtonTypeUserInfo,
};
typedef void(^headerButtonActionBlock)(FSHeaderButtonType type);

@class FSUserLevelInfo;

@class FSProductData;
static CGFloat const kHeaderHeight = 218.0f;
static CGFloat const kHeaderHeight_X = 232.0f;


@interface FSNavHeaderView : UIView

@property(nonatomic,strong) FSProductData *productData;
@property(nonatomic,copy) headerButtonActionBlock buttonActionBlock;

- (void)updateUserLevelView:(FSUserLevelInfo *)levelInfo;

- (CGFloat)userInfoViewBottom;
- (CGRect)userInfoViewFrame;

@end
