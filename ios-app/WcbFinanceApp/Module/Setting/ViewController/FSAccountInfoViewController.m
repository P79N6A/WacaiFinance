//
//  FSAccountInfoViewController.m
//  FinanceApp
//
//  Created by 叶帆 on 16/03/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSAccountInfoViewController.h"
#import "FSAccountInfoViewModel.h"
#import "FinSettingTableViewCell.h"
#import <LoginRegisterSDK+PersonalCenter.h>
#import "FSUserNicknameEditViewController.h"
#import <NeutronBridge/NeutronBridge.h>

static NSString *const kSettingCell = @"SettingCell";

@interface FSAccountInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) FSAccountInfoViewModel *viewModel;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation FSAccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self setupUI];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.viewModel.requestCmd execute:nil];

}

- (void)bindViewModel {
    self.viewModel = ({
        FSAccountInfoViewModel *viewModel = [[FSAccountInfoViewModel alloc] init];
        viewModel;
    });
    
    @weakify(self);
    

    [self.viewModel.requestCmd.executionSignals.switchToLatest subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        self.viewModel.userAvatar = [tuple first];
        self.viewModel.userNickname = [tuple second];
        [self.tableView reloadData];
    }];
    
    [self.viewModel.requestCmd.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        NSInteger errorCode = error.code;
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        if(errorCode == 5004 || errorCode == 5005 || response.statusCode == 403  || response.statusCode == 401) {
            [CMUIDisappearView showMessage:@"登录已失效,请重新登录"];
            [USER_INFO logout];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (void)setupUI {
    self.title = @"账户信息";
    self.view.backgroundColor = COLOR_DEFAULT_BACKGROUND;
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.tableHeaderView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
        tableView.tableFooterView = nil;
        tableView.backgroundView = nil;
        tableView.backgroundColor = COLOR_DEFAULT_BACKGROUND;
        tableView.rowHeight = 56;
        tableView.sectionHeaderHeight = 10;
        tableView.separatorColor = HEXCOLOR(0xe7e7e7);
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[FinSettingTableViewCell class] forCellReuseIdentifier:kSettingCell];
        [self.view addSubview:tableView];
        tableView;
    });
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_NavigationBarHeight);
        make.right.bottom.left.equalTo(self.view);
    }];
}

#pragma mark - TableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FinSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCell];
    cell.rightImageView.hidden = YES;
    cell.arrowImageView.hidden = NO;
    cell.detailTextLabel.hidden = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell titleToSuper];
    cell.settingDetailLabel.textColor = [UIColor blackColor];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.settingTitleLabel.text = @"头像";
                cell.rightImageView.image = self.viewModel.userAvatar;
                cell.rightImageView.layer.cornerRadius = 16;
                cell.rightImageView.clipsToBounds = YES;
                cell.rightImageView.hidden = NO;
                cell.detailTextLabel.hidden = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                cell.arrowImageView.hidden = NO;
                [cell detaialTitleToArrow];
                break;
            case 1:
                cell.arrowImageView.hidden = NO;
                [cell detaialTitleToArrow];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                cell.settingTitleLabel.text = @"昵称";
                cell.settingDetailLabel.text = SafeString(self.viewModel.userNickname);
                break;
            case 2:
                cell.arrowImageView.hidden = YES;
                [cell detaialTitleToSuper];
                cell.settingTitleLabel.text = @"挖财帐号";
                cell.settingDetailLabel.text = SafeString(self.viewModel.userAccount);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                
                @weakify(self)
                NSString *source = [NSString stringWithFormat:@"%@", @"nt://sdk-user/chooseAvatar"];
                NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:self];
                [ns ntWithSource:source
              fromViewController:self
                      transiaion:NTBViewControllerTransitionPush
                          onDone:^(NSString * _Nullable result) {
                              @strongify(self)
                              NSLog(@"info is %@", result);
                              [self.viewModel.requestCmd execute:nil];
                          } onError:^(NSError * _Nullable error) {
                              NSLog(@"error is %@", error);
                          }];
                
            }

                break;
            case 1:
                //昵称
                 [self.navigationController pushViewController:[[FSUserNicknameEditViewController alloc] initWithNickname:SafeString(self.viewModel.userNickname)] animated:YES];
                break;
            case 2:
                //挖财账号
                break;
            default:
                break;
        }
    }
}

@end
