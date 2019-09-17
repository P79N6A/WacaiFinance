//
//  TitleWithSwitchCell.h
//  FinanceApp
//
//  Created by new on 15/2/14.
//  Copyright (c) 2015年 com.wacai.licai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TitleWithSwitchCellDelegate <NSObject>

- (void)switchStateTo:(BOOL)isOn switchCell:(id)sender;

@end

@interface TitleWithSwitchCell : UITableViewCell

@property (nonatomic, strong) UISwitch *mSwitch;
@property (nonatomic, strong) UILabel *mTitleLabel;
@property (nonatomic, strong) UILabel *mSubtitleLabel;

@property (nonatomic, weak) id<TitleWithSwitchCellDelegate> mDelegate;

- (void)updateSwitchState:(BOOL)isOn switchCell:(id)sender;

- (void)setSwitchonTintColor:(UIColor *)color;

+ (TitleWithSwitchCell*)cellWithTitle:(NSString*)title switchState:(BOOL)isOn delegate:(id<TitleWithSwitchCellDelegate>)delegate;
+ (TitleWithSwitchCell*)cellWithTitle:(NSString*)title subTitle:(NSString *)subTitle switchState:(BOOL)isOn delegate:(id<TitleWithSwitchCellDelegate>)delegate;
@end
