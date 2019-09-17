//
//  FSThirdButtonCell.h
//  FinanceApp
//
//  Created by xingyong on 12/1/15.
//  Copyright © 2015 com.wacai.licai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FSThirdButtonType) {
    FSThirdButtonTypeQQ,
    FSThirdButtonTypeTencent,
    FSThirdButtonTypeSina,
    FSThirdButtonTypeWeChat,
};

typedef void(^FSThirdButtonBlock)(FSThirdButtonType type);

@interface FSThirdButtonCell : UITableViewCell

@property(nonatomic,copy)FSThirdButtonBlock buttonBlock;

+ (NSInteger)cellHeight;

@end
