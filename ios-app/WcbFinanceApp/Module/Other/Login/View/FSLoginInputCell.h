//
//  FSLoginInputCell.h
//  FinanceApp
//
//  Created by xingyong on 12/2/15.
//  Copyright © 2015 com.wacai.licai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTextField.h"

typedef void(^ActionBlock)(void);

@interface FSLoginInputCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton    *rightButton;
@property (nonatomic, strong) UIView      *lineView;

@property (nonatomic, copy  ) ActionBlock buttonBlock;
@property (nonatomic, copy  ) ActionBlock textFieldBlock;

- (void)setShowRighButton;
- (void)setHideRighButton;

@end
