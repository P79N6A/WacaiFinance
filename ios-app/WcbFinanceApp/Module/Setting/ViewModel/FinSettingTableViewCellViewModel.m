//
//  FinSettingTableViewCellViewModel.m
//  FinanceApp
//
//  Created by kuyeluofan on 19/03/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FinSettingTableViewCellViewModel.h"
#import "FSAccountSettingsItemModel.h"

@implementation FinSettingTableViewCellViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _detailColor = [UIColor colorWithHexString:@"#999999"];
    }
    return self;
}

- (instancetype)initWithConfig:(FSAccountSettingsItemModel *)detailModel {
    self = [super init];
    if (self) {
        _itemId             = detailModel.id;
        _title              = detailModel.text;
        _detail             = detailModel.desc;
        _skylineEventName   = detailModel.eventCode;
        _linkURL            = detailModel.iOSURL;
        NSString *configColorString = detailModel.descColor;
        NSString *colorString = [configColorString CM_isValidString] ? configColorString : @"#aaa";
        _detailColor        = [UIColor colorWithHexString:colorString];
    }
    return self;
}

@end
