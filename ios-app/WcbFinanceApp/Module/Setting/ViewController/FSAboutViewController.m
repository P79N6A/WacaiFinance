//
//  FinAboutUsViewController.m
//  FinanceSDK
//
//  Created by Alex on 7/22/15.
//  Copyright (c) 2015 com.wac.finance. All rights reserved.
//

#import "FSAboutViewController.h"
#import "FinSettingTableViewCell.h"
#import <i-Finance-Library/FSSDKGotoUtility.h>
#import "FSDebugSettingsViewController.h"
#import <Neutron/Neutron.h>
static NSString *const kSettingCell = @"SettingCell";

static NSString *const kSinaWeiboURL = @"https://weibo.com/wacai";
static NSString *const kTelephone = @"400-711-8718";
static NSString *const kServiceHotline = @"400-001-8078";

@interface FSAboutViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FSAboutViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于挖财宝";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FS_NavigationBarHeight);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FinSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCell];
    cell.arrowImageView.hidden = YES;
    cell.iconImageView.hidden = YES;
    [cell titleToSuper];
    [cell detaialTitleToSuper];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.settingTitleLabel.text = @"网址";
            cell.settingDetailLabel.text = @"https://www.wacai.com";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (indexPath.row == 1) {
            cell.settingTitleLabel.text = @"WAP";
            cell.settingDetailLabel.text = @"https://wacai.cn";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        } else if (indexPath.row == 2) {
            cell.settingTitleLabel.text = @"邮箱";
            cell.settingDetailLabel.text = @"kf@wacai.com";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        } else if (indexPath.row == 3) {
            cell.settingTitleLabel.text = @"挖财客服电话";
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"400-711-8718\n(工作日9:00-18:00)"];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 12)];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(12, [attributedString length] - 12)];
            cell.settingDetailLabel.attributedText = attributedString;
            cell.settingDetailLabel.textAlignment = NSTextAlignmentRight;
            cell.settingDetailLabel.numberOfLines = 2;
            
        } else if(indexPath.row == 4){
            
            cell.settingTitleLabel.text = @"杭州市互联网金融服务热线";
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"400-001-8078\n(工作日9:00-17:00)"];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 12)];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(12, [attributedString length] - 12)];
            cell.settingDetailLabel.attributedText = attributedString;
            cell.settingDetailLabel.textAlignment = NSTextAlignmentRight;
            cell.settingDetailLabel.numberOfLines = 2;
        
        }else if (indexPath.row == 5) {
            cell.settingTitleLabel.text = @"微信公众号";
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"挖财宝\n(微信搜索：wacaibao)"];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 3)];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(3, [attributedString length] - 3)];
            cell.settingDetailLabel.attributedText = attributedString;
            cell.settingDetailLabel.textAlignment = NSTextAlignmentRight;
            cell.settingDetailLabel.numberOfLines = 2;

        } else if (indexPath.row == 6) {
            cell.settingTitleLabel.text = @"新浪官方微博";
            cell.arrowImageView.hidden = NO;
            [cell detaialTitleToArrow];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.settingTitleLabel.text = @"给我们鼓励";
            cell.arrowImageView.hidden = NO;
            [cell detaialTitleToArrow];
        }
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",kTelephone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
        
        if(indexPath.row == 4)
        {
            NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",kServiceHotline];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
        
        if (indexPath.row == 6) {
            [FSSDKGotoUtility openURL:kSinaWeiboURL from:self];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
 
            NSString *appStoreLink = [NSString stringWithFormat:@"https://itunes.apple.com/gb/app/appName/id%@?mt=8", @(APP_ID_STORE)];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreLink]];
        }
    }
}


#pragma mark - Getter and Setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerClass:[FinSettingTableViewCell class] forCellReuseIdentifier:kSettingCell];
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 50;
        _tableView.sectionHeaderHeight = 0.01;
        _tableView.sectionFooterHeight = 16;
        _tableView.tableHeaderView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = HEXCOLOR(0xe7e7e7);

        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 163)];
        headerView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = headerView;
        
        
        // fisrt for smallest, last seems to be largest
        NSString *appIconName = [[[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"] lastObject];
        UIImage* appIcon = [UIImage imageNamed:appIconName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:appIcon];
        imageView.layer.cornerRadius = 8;
        imageView.clipsToBounds = YES;
        [headerView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.height.equalTo(@57);
            make.centerY.equalTo(@-10);
            
        }];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoDebugSettingsViewController)];
        tapGestureRecognizer.numberOfTapsRequired = 3;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tapGestureRecognizer];
        
 
        UILabel *versionLabel = [UILabel new];
        versionLabel.textColor = [UIColor lightGrayColor];
        versionLabel.font = [UIFont systemFontOfSize:14];
        versionLabel.text = [NSString stringWithFormat:@"%@", Release_App_Ver];
        
        
        [headerView addSubview:versionLabel];
        [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(10);
            make.centerX.equalTo(@0);
        }];
    }
    
    return _tableView;
}

#pragma mark - Event Responses
- (void)gotoDebugSettingsViewController{
#ifdef kTestAppURL
    FSDebugSettingsViewController *debugSettingsVC = [FSDebugSettingsViewController new];
    [self.navigationController pushViewController:debugSettingsVC animated:YES];
#endif
}


@end
