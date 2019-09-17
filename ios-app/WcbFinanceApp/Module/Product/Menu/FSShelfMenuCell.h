//
//  FSShelfMenuCell.h
//  WcbFinanceApp
//
//  Created by 破山 on 2019/3/4.
//  Copyright © 2019年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSShelfMenuCell : UITableViewCell

@property(nonatomic, strong) NSArray *menuArray;

@property(nonatomic, assign) BOOL isNewer;

- (void)fillContent:(NSArray *)menuArray
            isNewer:(BOOL)isNewer
           rowCount:(NSInteger)rowCount;

@end

NS_ASSUME_NONNULL_END
