//
//  FinSettingTableViewCell.h
//  FinanceSDK
//
//  Created by Alex on 7/20/15.
//  Copyright (c) 2015 com.wac.finance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinSettingTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel     *settingTitleLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel     *settingDetailLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImageView *redBadge;

- (void)titleToIcon;
- (void)titleToSuper;
- (void)detaialTitleToArrow;
- (void)detaialTitleToSuper;
@end
