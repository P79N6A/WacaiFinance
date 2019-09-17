//
//  InputTableViewCell.h
//  FinanceApp
//
//  Created by Alex on 6/26/15.
//  Copyright (c) 2015 com.wacai.licai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CKCountdownButton;

typedef void(^ActionBlock)();

@interface InputTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton    *rightButton;
@property (nonatomic, copy  ) ActionBlock buttonBlock;
@property (nonatomic, copy  ) ActionBlock textFieldBlock;


- (void)startTimer;
- (void)stopTimer;

@end
