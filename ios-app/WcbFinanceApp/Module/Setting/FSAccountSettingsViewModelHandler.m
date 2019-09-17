//
//  FSAccountSettingsViewModelHandler.m
//  WcbFinanceApp
//
//  Created by 叶帆 on 2018/10/18.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSAccountSettingsViewModelHandler.h"
#import "FSEmptyCellViewModel.h"
#import "FinSettingTableViewCellViewModel.h"
#import "FSAssetLineCellViewModel.h"
#import "FSAccountInfoEntranceCellViewModel.h"
#import "FSButtonCellViewModel.h"
#import "FSAccountSettingsUserStatus.h"
#import <CMNSArray/CMNSArray.h>
#import "FSAccountSettingsModelList.h"

@implementation FSAccountSettingsViewModelHandler

- (NSArray *)buildPageViewModelWithConfig:(FSAccountSettingsModelList *)configModel
                                 userInfo:(FSAccountSettingsUserInfo *)userInfo
                               userStatus:(FSAccountSettingsUserStatus *)userStatus {
    NSMutableArray *tempArray = [NSMutableArray array];
    
    if (!configModel || !userInfo || ![configModel.groups CM_isValidArray]) {
        // 如果配置为空，直接返回空数组阻止渲染
        return tempArray;
    };
    
    // 用户信息
    [self addUserInfo:userInfo to:tempArray];
    
    
    NSArray *listViewModes = [self buildListViewModelWithModelList:configModel userStatus:userStatus];
    [tempArray addObjectsFromArray:listViewModes];
    
    // 退出登录
    if (USER_INFO.isLogged) {
        [self addDoubleEmptyCellTo:tempArray];
        [self addLogoutButtonTo:tempArray];
    }
    
    
    return [tempArray copy];
}

- (NSArray *)buildListViewModelWithModelList:(FSAccountSettingsModelList *)list userStatus:(FSAccountSettingsUserStatus *)userStatus {
    //处理动态配置的列表区域
    NSMutableArray *tempArray = [NSMutableArray array];

    for (FSAccountSettingsModel * model in list.groups) {
        //遍历模型
        NSArray *items = model.items;
        if (![items CM_isValidArray]) continue;
        // Single Group Processing
        [self addEmptyCellTo:tempArray]; // Group 之间的间隙
        [self addLongLineTo:tempArray]; // Group 的顶部分割线
        __block BOOL isFirstItem = YES;
        
        for (FSAccountSettingsItemModel * detailModel in items) {
            if (![self shouldShowItem:detailModel userStatus:userStatus]) { continue; }
            if (!isFirstItem) {
                [self addShortLineTo:tempArray]; //非首个 Item 需要额外添加分割线
            }
            [self addSettingsItem:detailModel to:tempArray]; // Group 中的 Item
            isFirstItem = NO;
        }
        [self addLongLineTo:tempArray]; // Group 的底部分割线
    }
    
    return [tempArray copy];
}


- (void)addEmptyCellTo:(NSMutableArray *)array {
    FSEmptyCellViewModel *emptyCellVM = [[FSEmptyCellViewModel alloc] initWithHeight:10];
    [array fs_addObject:emptyCellVM];
}

- (void)addDoubleEmptyCellTo:(NSMutableArray *)array {
    FSEmptyCellViewModel *emptyCellVM = [[FSEmptyCellViewModel alloc] initWithHeight:20];
    [array fs_addObject:emptyCellVM];
}

- (void)addLongLineTo:(NSMutableArray *)array {
    FSAssetLineCellViewModel *longLineCellVM = [[FSAssetLineCellViewModel alloc] init];
    longLineCellVM.leftPadding = 0;
    [array fs_addObject:longLineCellVM];
}

- (void)addShortLineTo:(NSMutableArray *)array {
    FSAssetLineCellViewModel *shortLineCellVM = [[FSAssetLineCellViewModel alloc] init];
    shortLineCellVM.leftPadding = 10;
    [array fs_addObject:shortLineCellVM];
}

- (void)addSettingsItem:(FSAccountSettingsItemModel *)itemDic to:(NSMutableArray *)array {
    FinSettingTableViewCellViewModel *itemVM = [[FinSettingTableViewCellViewModel alloc] initWithConfig:itemDic];
    [array fs_addObject:itemVM];
}

- (void)addUserInfo:(FSAccountSettingsUserInfo *)userInfo to:(NSMutableArray *)array {
    FSAccountInfoEntranceCellViewModel *accountInfoCellVM = [[FSAccountInfoEntranceCellViewModel alloc] initWithUserInfo:userInfo];
    [array fs_addObject:accountInfoCellVM];
}

- (void)addLogoutButtonTo:(NSMutableArray *)array {
    FSButtonCellViewModel *signOutVM = [[FSButtonCellViewModel alloc] init];
    signOutVM.title = @"退出登录";
    [array fs_addObject:signOutVM];
}

- (BOOL)shouldShowItem:(FSAccountSettingsItemModel *)item userStatus:(FSAccountSettingsUserStatus *)userStatus {
    
    // 容错约定：若配置无标题，不展示处理
    if (![item.text CM_isValidString]) { return NO; }
    
    // 由于配置下发服务能力有限，目前只能采用该方式兼容。
    // 后续若配置可按用户进行状态下发，将 shouldShowItemID 相关逻辑移除即可。
    if (![self shouldShowItemID:item.id userStatus:userStatus]) { return NO; }
    return YES;
}

- (BOOL)shouldShowItemID:(NSString *)itemID userStatus:(FSAccountSettingsUserStatus *)userStatus {
    if ([self isBindingInfoItem:itemID]) {
        return [self shouldShowBindingInfoItem:itemID userStatus:userStatus];
    };
    
    if ([self isBankAccountItem:itemID]) {
        return [self shouldShowBankAccountItem:itemID userStatus:userStatus];
    };
    
    return YES;
}

- (BOOL)isBindingInfoItem:(NSString *)itemID {
    return [itemID containsString:@"bindinfo"];
}

- (BOOL)isBankAccountItem:(NSString *)itemID {
    return [itemID containsString:@"bankaccount"];
}

- (BOOL)shouldShowBindingInfoItem:(NSString *)itemID userStatus:(FSAccountSettingsUserStatus *)userStatus {
    NSString *showItemID = [self showBindingInfoItemID:userStatus];
    return [itemID CM_isEquals:showItemID];
}

- (BOOL)shouldShowBankAccountItem:(NSString *)itemID userStatus:(FSAccountSettingsUserStatus *)userStatus {
    NSString *showItemID = [self showBankAccountItemID:userStatus];
    return [itemID CM_isEquals:showItemID];
}

- (NSString *)showBindingInfoItemID:(FSAccountSettingsUserStatus *)userStatus {
    if (!userStatus || userStatus.realNameStatus.integerValue == FSUserFinanceStateUnknown || userStatus.realNameStatus.integerValue == FSUserFinanceStateUnknown) {
        return @"bindinfo-3";
    } else {
        BOOL hasRealName = userStatus.realNameStatus.integerValue == FSUserFinanceStatePositive;
        BOOL hasBindCard = userStatus.bindCardStatus.integerValue == FSUserFinanceStatePositive;
        if (hasRealName) {
            if (hasBindCard) {
                return @"bindinfo-2";
            } else {
                return @"bindinfo-1";
            }
        } else {
            return @"bindinfo-0";
        }
    }
}

- (NSString *)showBankAccountItemID:(FSAccountSettingsUserStatus *)userStatus {
    if (!userStatus || userStatus.bankDepositoryStatus.integerValue == FSUserFinanceStateUnknown) {
        return @"bankaccount-2";
    } else {
        BOOL hasBankAccount = userStatus.bankDepositoryStatus.integerValue == FSUserFinanceStatePositive;;
        if (hasBankAccount) {
            return @"bankaccount-1";
        } else {
            return @"bankaccount-0";
        }
    }
    
}

@end
