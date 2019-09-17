//
//  FSHelpAndFeedbackViewController.m
//  FinanceApp
//
//  Created by Alex on 8/10/16.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSHelpAndFeedbackViewController.h"
#import "FinSettingTableViewCell.h"
#import "FSFeedbackViewController.h"
#import "EnvironmentInfo.h"
#import <i-Finance-Library/FSSDKGotoUtility.h>


@interface FSHelpAndFeedbackViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FSHelpAndFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}


- (void)setupUI
{
    self.title = @"帮助与反馈";
    self.view.backgroundColor = COLOR_DEFAULT_BACKGROUND;
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.tableHeaderView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
        tableView.tableFooterView = nil;
        tableView.backgroundView = nil;
        tableView.backgroundColor = COLOR_DEFAULT_BACKGROUND;
        tableView.rowHeight = 56;
        tableView.sectionHeaderHeight = 10;
        tableView.sectionFooterHeight = CGFLOAT_MIN;
        
        tableView.separatorColor = HEXCOLOR(0xe7e7e7);
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[FinSettingTableViewCell class] forCellReuseIdentifier:NSStringFromClass([FinSettingTableViewCell class])];

        [self.view addSubview:tableView];
        tableView;
    });
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(FS_NavigationBarHeight);
    }];
}

#pragma mark - UITableView DateSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FinSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FinSettingTableViewCell class])];
    [cell titleToSuper];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.settingTitleLabel.text = @"常见问题";
        } else if (indexPath.row == 1) {
            cell.settingTitleLabel.text = @"我要反馈";
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger rowNumber = 0;
    if (section == 0) {
        rowNumber = 2;
    }
    return rowNumber;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *baseURLString = [[EnvironmentInfo sharedInstance] URLStringOfCurrentEnvironmentURLType:FSURLTypeFinance];
            NSString *urlString = [NSString stringWithFormat:@"%@/finance/h5/help.action", baseURLString];

            [FSSDKGotoUtility openURL:urlString from:self];
            
        } else if (indexPath.row == 1) {
            FSFeedbackViewController *feedbvackVC = [FSFeedbackViewController new];
            feedbvackVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feedbvackVC animated:YES];
        }
    }
}

@end
