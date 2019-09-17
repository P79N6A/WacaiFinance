//
//  FSAccountInfoEntranceCellViewModel.h
//  FinanceApp
//
//  Created by kuyeluofan on 19/03/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FSAccountSettingsUserInfo;

@interface FSAccountInfoEntranceCellViewModel : NSObject

- (instancetype)initWithUserInfo:(FSAccountSettingsUserInfo *)userInfo;

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) UIImage *avatar;

@property (copy, nonatomic, readonly) NSString *linkURL;
@property (copy, nonatomic, readonly) NSString *skylineEventName;

@end
