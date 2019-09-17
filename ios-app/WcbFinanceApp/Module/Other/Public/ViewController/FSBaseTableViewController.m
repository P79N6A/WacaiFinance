//
//  FSBaseTableViewController.m
//  FinanceSDK
//
//  Created by xingyong on 9/28/15.
//  Copyright © 2015 com.wac.finance. All rights reserved.
//

#import "FSBaseTableViewController.h"

@interface FSBaseTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FSBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(64);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//
//    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_NavigationBarHeight);
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    
    [self registTableViewCell];
    
 
}

- (void)registTableViewCell{
    //子类重写
}
- (void)setupTopPadding:(CGFloat)height{
   
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(height);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xF6F6F6);
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorColor = HEXCOLOR(0xe7e7e7);
        _tableView.backgroundView = nil;
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

  
@end
