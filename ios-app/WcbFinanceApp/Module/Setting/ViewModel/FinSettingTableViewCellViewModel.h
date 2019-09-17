//
//  FinSettingTableViewCellViewModel.h
//  FinanceApp
//
//  Created by kuyeluofan on 19/03/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FSAccountSettingsItemModel;

@interface FinSettingTableViewCellViewModel : NSObject

@property (copy, nonatomic) NSString *itemId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *detail;
@property (copy, nonatomic) NSString *linkURL;
@property (strong, nonatomic) UIColor *detailColor;

@property (assign, nonatomic) NSUInteger BILogNumber;
@property (copy, nonatomic) NSString *lotuseedEventName;
@property (copy, nonatomic) NSString *skylineEventName;

- (instancetype)initWithConfig:(FSAccountSettingsItemModel *)detailModel;

@end
