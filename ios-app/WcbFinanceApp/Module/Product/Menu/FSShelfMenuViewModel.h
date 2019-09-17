//
//  FSShelfMenuViewModel.h
//  WcbFinanceApp
//
//  Created by 破山 on 2019/3/4.
//  Copyright © 2019年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

extern NSInteger FSSchelfMenuCellTopInsets;
extern NSInteger FSSchelfMenuCellBottomInsets;

@interface FSShelfMenuViewModel : NSObject
@property (nonatomic, strong, readonly) RACCommand *menuCommand;
@property (nonatomic, copy) NSArray *menuModels;

//一行的数量
- (NSInteger)rowCountForNum:(NSInteger)num;

//整体高度
- (NSInteger)cellHeightForNum:(NSInteger)num;

@end


