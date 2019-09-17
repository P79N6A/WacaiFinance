//
//  FSUserNicknameEditViewController.m
//  FinanceApp
//
//  Created by 叶帆 on 21/02/2017.
//  Copyright © 2017 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSUserNicknameEditViewController.h"
#import <LoginRegisterSDK+PersonalCenter.h>
#import "FSEditCell.h"
#import "CMUIDisappearView.h"
#import <NeutronBridge/NeutronBridge.h>
#import <NativeQS/NQSParser.h>
#import <CMNSString/NSString+CMUtil.h>

@interface FSUserNicknameEditViewController ()

@property (nonatomic, copy) NSString *originalNickname;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, strong) UIView *tableFooterView;

@end

@implementation FSUserNicknameEditViewController

- (instancetype)initWithNickname:(NSString *)originalNickname {
    self = [super init];
    if (self) {
        if (!originalNickname) {
            originalNickname = @"";
        }
        _originalNickname = originalNickname;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}

- (void)setupUI {
    self.title = @"编辑昵称";
    self.view.backgroundColor = COLOR_DEFAULT_BACKGROUND;
    
    [self.tableView registerClass:[FSEditCell class] forCellReuseIdentifier:@"FSEditCell"];
    self.tableView.tableHeaderView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    self.tableView.tableFooterView = self.tableFooterView;
    self.tableView.backgroundColor = COLOR_DEFAULT_BACKGROUND;
    
    
    [self setupRightButtonTitle:@"保存"];
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#FF0097FF"] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.rightButton setEnabled:NO];
    
    [self setupTopPadding:FS_NavigationBarHeight];
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSEditCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak FSUserNicknameEditViewController *weakSelf = self;
    
    if (indexPath.row == 0) {
   
        cell.editTextField.secureTextEntry = NO;
        cell.editTextField.text = self.originalNickname;
        [cell.editTextField becomeFirstResponder];
        
        cell.editActionBlock = ^(NSString *text) {
            weakSelf.nickname = text;
            weakSelf.rightButton.enabled = ![weakSelf.originalNickname isEqualToString:weakSelf.nickname];
            if ([weakSelf.nickname isEqualToString:@""]) {
                weakSelf.rightButton.enabled = NO;
            }

        };
 
        
    }
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.;
}
#pragma mark - Event Handler
- (void)onRightAction:(id)sender {
 
    if ([self isNicknameLengthValid:self.nickname]) {

        
        NSDictionary *params = @{@"nickName": self.nickname};
        NSString *source = [NSString stringWithFormat:@"%@?%@", @"nt://sdk-user/updateNickName", [NQSParser queryStringifyObject:params]];
        
        NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:self];
        @weakify(self)
        [ns ntWithSource:source
      fromViewController:self
              transiaion:NTBViewControllerTransitionPush
                  onDone:^(NSString * _Nullable result) {
                      @strongify(self)
                      NSDictionary * info = [result CM_JsonStringToDictionary];
                      if([info[@"status"] isEqualToString:@"success"])
                      {
                          [self.navigationController popViewControllerAnimated:YES];
                      } else {
                          NSLog(@"call updateNickName failed");
                      }
                  } onError:^(NSError * _Nullable error) {
                      NSLog(@"error is %@", error);
                  }];
        
    } else {
        [CMUIDisappearView showMessage:@"昵称需4-20个字符，汉字占两个字符"];
    }
    
    
    
}

- (BOOL)isNicknameLengthValid:(NSString *)nickname {
    NSUInteger nicknameLength = [self lengthOfNickname:nickname];
    if (nicknameLength >= 4 && nicknameLength <= 20) {
        return YES;
    } else {
        return NO;
    }
}

//返回昵称字符串长度，中文字符占两个
- (NSUInteger)lengthOfNickname:(NSString *)nickname {
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [nickname dataUsingEncoding:encoding];
    return [data length];
}
 

- (UIView *)tableFooterView {
    if (!_tableFooterView) {
        
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 50)];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.text = @"60天仅支持修改一次昵称";
        label1.font = [UIFont systemFontOfSize:12];
        [_tableFooterView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tableFooterView).offset(15);
            make.right.equalTo(_tableFooterView);
            make.top.mas_equalTo(10);
        }];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.text = @"(仅支持中英文、数字、下划线，4-20个字符)";
        label2.font = [UIFont systemFontOfSize:12];
        label2.textColor = [UIColor grayColor];
        [_tableFooterView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label1);
            make.right.equalTo(label1);
            make.top.equalTo(label1.mas_bottom).offset(4);
        }];
        
    }
    return _tableFooterView;
}

@end
