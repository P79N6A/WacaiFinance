//
//  DNSConfigViewController.m
//  HttpdnsDemoExample
//
//  Created by 破山 on 2018/11/16.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "DNSConfigViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "FSLoginInputCell.h"
#import "UITableViewCell+FSBase.h"
#import "FSTextInfoCell.h"
#import "ButtonCell.h"
#import "HostListManager.h"
#import "TheReporter.h"

//Source
#import "FSCompetitionModel.h"
#import "FSHTTPDNS.h"
#import "FSDNSCache.h"
#import "FSGSLBCache.h"
#import "FSHTTPDNSWhiteListManager.h"
#import "FSHTTPDNSWhiteListConfig.h"
#import "FSDNSManager.h"
#import "FSCompetitionTime.h"

typedef NS_ENUM(NSUInteger, ConfigCellStyle) {
    ConfigCellStyleTimeInfo,
    ConfigCellStyleInputGSLBTime,
    ConfigCellStyleInputPodTime,
    ConfigCellStyleTimeBtn,
    ConfigCellStyleHostList,
    ConfigCellStyleInputHost,
    ConfigCellStyleHostBtn,
    ConfigCellStyleInputRequestHost,
    ConfigCellStyleResloveLogInfo,
    ConfigCellStyleRequestBtn,
    ConfigCellStyleCurrentInfo,
    ConfigCellStyleRefreshCacheBtn,
    ConfigCellStyleClearCacheBtn,
};

@interface DNSConfigViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, strong) NSString *responseString;
@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) NSString *currentTimeInfo;

@property (nonatomic, strong) NSString *gslbTime;
@property (nonatomic, strong) NSString *podTime;

@property (nonatomic, strong) NSString *addHost;
@property (nonatomic, strong) NSString *hostResolve;

@property (nonatomic, strong) NSString *requestLog;
@property (nonatomic, strong) NSString *currentEnvironmentInfo;

@end

@implementation DNSConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //data init
    self.currentEnvironmentInfo = [self setupCurrentInfo];
    
    
    
    [self setupTableView];
    self.datas = @[@(ConfigCellStyleTimeInfo),
                   @(ConfigCellStyleInputGSLBTime),
                   @(ConfigCellStyleInputPodTime),
                   @(ConfigCellStyleTimeBtn),
                   @(ConfigCellStyleHostList),
                   @(ConfigCellStyleInputHost),
                   @(ConfigCellStyleHostBtn),
                   @(ConfigCellStyleInputRequestHost),
                   @(ConfigCellStyleResloveLogInfo),
                   @(ConfigCellStyleRequestBtn),
                   @(ConfigCellStyleCurrentInfo),
                   @(ConfigCellStyleRefreshCacheBtn),
                   @(ConfigCellStyleClearCacheBtn)];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTableView
{
    [self.tableView registerClass:[FSLoginInputCell class] forCellReuseIdentifier:[FSLoginInputCell FSCellIdentifier]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FSTextInfoCell" bundle:nil] forCellReuseIdentifier:[FSTextInfoCell FSCellIdentifier]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ButtonCell" bundle:nil] forCellReuseIdentifier:[ButtonCell FSCellIdentifier]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *num = self.datas[indexPath.row];
    NSInteger type = num.integerValue;
    if(type == ConfigCellStyleTimeInfo)
    {
        FSTextInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[FSTextInfoCell FSCellIdentifier]];
        self.currentTimeInfo = [self currentCompeteTime];
        [cell fillContent:self.currentTimeInfo];
        
        return cell;
    }
    else if(type == ConfigCellStyleInputGSLBTime)
    {
        FSLoginInputCell *cell = [tableView dequeueReusableCellWithIdentifier:[FSLoginInputCell FSCellIdentifier]];
        cell.inputTextField.placeholder = @"GSLB竞争时间";
        cell.inputTextField.keyboardType = UIKeyboardTypeNamePhonePad;
        
        __weak FSLoginInputCell *weakCell = cell;
        __weak __typeof(self)weakSelf = self;
        
        cell.textFieldBlock = ^{
            weakSelf.gslbTime = weakCell.inputTextField.text;
        };
        
        return cell;
    }
    else if(type == ConfigCellStyleInputPodTime)
    {
        FSLoginInputCell *cell = [tableView dequeueReusableCellWithIdentifier:[FSLoginInputCell FSCellIdentifier]];
        cell.inputTextField.placeholder = @"Pod竞争时间";
        cell.inputTextField.keyboardType = UIKeyboardTypeNamePhonePad;
        
        __weak FSLoginInputCell *weakCell = cell;
        __weak __typeof(self)weakSelf = self;
        
        cell.textFieldBlock = ^{
            weakSelf.podTime = weakCell.inputTextField.text;
        };
        
        return cell;
    }
    else if(type == ConfigCellStyleTimeBtn)
    {
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:[ButtonCell FSCellIdentifier]];
        [cell fillContent:@"配置竞争时间"];
        
        return cell;
    }
    else if(type == ConfigCellStyleHostList)
    {
        FSTextInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[FSTextInfoCell FSCellIdentifier]];
        NSString *hostList = [self currentHostList];
        [cell fillContent:hostList];
        
        return cell;
    }
    else if(type == ConfigCellStyleInputHost)
    {
        FSLoginInputCell *cell = [tableView dequeueReusableCellWithIdentifier:[FSLoginInputCell FSCellIdentifier]];
        cell.inputTextField.placeholder = @"域名";
        
        __weak FSLoginInputCell *weakCell = cell;
        __weak __typeof(self)weakSelf = self;
        
        cell.textFieldBlock = ^{
            weakSelf.addHost = weakCell.inputTextField.text;
        };
        
        return cell;
    }
    else if(type == ConfigCellStyleHostBtn)
    {
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:[ButtonCell FSCellIdentifier]];
        [cell fillContent:@"添加使用HTTPDNS的域名"];
        
        
        return cell;
    }
    else if(type == ConfigCellStyleResloveLogInfo)
    {
        FSTextInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[FSTextInfoCell FSCellIdentifier]];
        [cell fillContent:self.requestLog];
        
        return cell;
    }
    
    else if(type == ConfigCellStyleInputRequestHost)
    {
        FSLoginInputCell *cell = [tableView dequeueReusableCellWithIdentifier:[FSLoginInputCell FSCellIdentifier]];
        cell.inputTextField.placeholder = @"发起请求的域名：www.wacai.com";
        
        __weak FSLoginInputCell *weakCell = cell;
        __weak __typeof(self)weakSelf = self;
        
        cell.textFieldBlock = ^{
            weakSelf.hostResolve = weakCell.inputTextField.text;
        };
        
        return cell;
    }
    else if(type == ConfigCellStyleRequestBtn)
    {
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:[ButtonCell FSCellIdentifier]];
        [cell fillContent:@"发起DNS请求"];
        
        return cell;
    }
    else if(type == ConfigCellStyleCurrentInfo)
    {
        FSTextInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[FSTextInfoCell FSCellIdentifier]];
        NSString *info = self.currentEnvironmentInfo;
        [cell fillContent:info];
        
        return cell;
    }
    else if(type == ConfigCellStyleRefreshCacheBtn)
    {
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:[ButtonCell FSCellIdentifier]];
        [cell fillContent:@"刷新缓存"];
        
        return cell;
    }
    else if(type == ConfigCellStyleClearCacheBtn)
    {
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:[ButtonCell FSCellIdentifier]];
        [cell fillContent:@"清除全部缓存"];
        
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *num = self.datas[indexPath.row];
    NSInteger type = num.integerValue;
    
    if(type == ConfigCellStyleTimeBtn)
    {
        [self resetCompeteTime];
    }
    else if(type == ConfigCellStyleHostBtn)
    {
        //[self addHostAction];
    }
    else if(type == ConfigCellStyleRequestBtn)
    {
        [self requestDNS:self.hostResolve];
    }
    else if(type == ConfigCellStyleRefreshCacheBtn)
    {
        [self refreshCache];
    }
    else if(type == ConfigCellStyleClearCacheBtn)
    {
        [self clearAllCache];
    }
    else
    {
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *num = self.datas[indexPath.row];
    NSInteger type = num.integerValue;
    if(type == ConfigCellStyleTimeInfo)
    {
        return 60;
    }
    else if(type == ConfigCellStyleHostList)
    {
        NSString *tmp = [self currentHostList];
        CGFloat height = [FSTextInfoCell heightForString:tmp];
        return height;
    }
    else if(type == ConfigCellStyleResloveLogInfo)
    {
        CGFloat height = [FSTextInfoCell heightForString:self.requestLog];
        return height;
    }
    else if(type == ConfigCellStyleCurrentInfo)
    {
        CGFloat height = [FSTextInfoCell heightForString:self.currentEnvironmentInfo];
        return height;
    }
    
    return 50;
}

#pragma mark - CompeteTime
- (NSString *)currentCompeteTime
{
    FSCompetitionTime *time = [FSDNSManager sharedInstance].competTime;
    
    NSInteger gslbTime = time.gslbLostTime;
    NSInteger podTime  = time.aliLostTime;
    NSString *str = [NSString stringWithFormat:@"当前竞争时间 GSLB:%@, ali:%@",@(gslbTime),@(podTime)];
    NSString *tip = @"pod时间要大于gslb时间";
    str = [NSString stringWithFormat:@"%@ \n %@",str, tip];
    
    return str;
}

- (void)resetCompeteTime
{
    int gslbTime = [self.gslbTime intValue];
    int podTime  = [self.podTime intValue];
    
    [[FSDNSManager sharedInstance] setCompetitionTime:gslbTime aliLostTime:podTime];
    
    [self.tableView reloadData];
}

#pragma mark - addHostAction
- (void)addHostAction
{
    [[HostListManager sharedInstance] addHost:self.addHost];
    [self.tableView reloadData];
}

- (NSString *)currentHostList
{
//    NSArray *hostList = [[HostListManager sharedInstance] currentHostList];
//
//    NSMutableString *tmp = [[NSMutableString alloc] init];
//    for(NSInteger i = 0;i < hostList.count; i++)
//    {
//        [tmp appendFormat:@"%@; ", hostList[i]];
//    }    
    NSString *des = [[FSHTTPDNSWhiteListManager sharedManager].whiteListConfig description];

    return des;
}



#pragma mark - request Action
- (void)requestDNS:(NSString *)host
{
    TheReporter *reporter = [[TheReporter alloc] init];
    [reporter setup:YES];
    
    [[FSDNSManager sharedInstance] setReporter:reporter];
    NSArray *array = [[FSDNSManager sharedInstance] query:host];
    
    NSLog(@"reporter string is %@", reporter.log);
    self.requestLog = [reporter.log copy];
    
    self.currentEnvironmentInfo = [self setupCurrentInfo];
    
    [self.tableView reloadData];
}

#pragma mark - cache Action
- (void)refreshCache
{
    self.currentEnvironmentInfo = [self setupCurrentInfo];
    
    [self.tableView reloadData];
}

- (NSString *)setupCurrentInfo
{
    NSMutableString *tmp = [[NSMutableString alloc] init];
    NSInteger timeInterval = [[NSDate date] timeIntervalSince1970];
    
    FSNetworkInfo *networkInfo = [[FSDNSManager sharedInstance] valueForKey:@"lastNetWork"];
    
    [tmp appendFormat:@"上次网络的网络类型: %@\n", [networkInfo description]];
    [tmp appendFormat:@"当前时间戳：%@\n",@(timeInterval)];
    [tmp appendFormat:@"当前缓存-----------\n"];
    FSDNSCache *dnsCache = [FSDNSManager sharedInstance].cache;
    NSArray *allKeys = [dnsCache allkeys];
    for(NSInteger i = 0; i < allKeys.count; i ++)
    {
        NSString *key = allKeys[i];
        NSArray *records = [dnsCache get:key];
        if(records)
        {
            NSString *reString = [self stringFromRecords:records];
            [tmp appendFormat:@"%@ -> %@", key, reString];
        }
    }
    
//    [tmp appendFormat:@"\n系统缓存---------\n"];
//
//    FSGSLBCache *gslb = [FSDNSManager sharedInstance].gslbCache;
//    allKeys = [gslb allkeys];
//    for(NSInteger i = 0; i < allKeys.count; i ++)
//    {
//        NSString *key = allKeys[i];
//        NSArray *records = [gslb get:key];
//        if(records)
//        {
//            NSString *reString = [self stringFromRecords:records];
//            [tmp appendFormat:@"%@ -> %@", key, reString];
//        }
//    }
    
    return  [tmp copy];
}

- (NSString *)stringFromRecords:(NSArray *)records
{
    NSMutableString *t = [[NSMutableString alloc] init];
    [t appendFormat:@"\n"];
    for(NSInteger i = 0; i < records.count; i ++)
    {
        FSRecord *record = records[i];
        NSString *expire = [record isExpired] ? @"过期":@"未过期";
        [t appendFormat:@"%@ (%@); \n",[record description], expire];
    }
    
    [t appendFormat:@"\n"];
    
    return [t copy];
}


- (void)clearAllCache
{
    [[FSDNSManager sharedInstance] clearCache];
    
    [self refreshCache];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
