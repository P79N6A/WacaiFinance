//
//  FSBaseTableViewController.h
//  FinanceSDK
//
//  Created by xingyong on 9/28/15.
//  Copyright © 2015 com.wac.finance. All rights reserved.
//

#import "FSBaseViewController.h"

@interface FSBaseTableViewController : FSBaseViewController

@property(nonatomic,strong) UITableView *tableView;

- (void)setupTopPadding:(CGFloat)height;

- (void)registTableViewCell;

@end
