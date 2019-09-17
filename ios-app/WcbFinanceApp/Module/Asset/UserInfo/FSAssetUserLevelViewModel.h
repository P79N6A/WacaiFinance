//
//  FSAssetUserInfoViewModel.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/17.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FSUserLevelInfo;

@interface FSAssetUserLevelViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *userLevelCommand;

@property (nonatomic, strong) FSUserLevelInfo *levelInfo;


@end
