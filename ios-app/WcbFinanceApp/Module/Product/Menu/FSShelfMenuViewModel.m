//
//  FSShelfMenuViewModel.m
//  WcbFinanceApp
//
//  Created by 破山 on 2019/3/4.
//  Copyright © 2019年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSShelfMenuViewModel.h"
#import "FSShelfMenuData.h"
#import <YYModel/YYModel.h>
#import <i-Finance-Library/NSDictionary+FSUtils.h>

#import <CMNSDictionary/CMNSDictionary.h>
#import <CMNSString/CMNSString.h>
#import <i-Finance-Library/NSMutableArray+FSUtils.h>

#import "FSGroupHiveConfigRequest.h"
#import <CMAppProfile/CMAppProfile.h>
#import "EnvironmentInfo.h"

static NSString *const FSShelfModelName = @"ShelfMenuConfigRequest";

static NSString *const FSShelfMenuGroupKey = @"shelf_func";

NSInteger FSSchelfMenuCellTopInsets = 17;
NSInteger FSSchelfMenuCellBottomInsets = 25;

static NSInteger maxTotalCount = 8;

@interface FSShelfMenuViewModel()

@end


@implementation FSShelfMenuViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        @weakify(self);
        _menuCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            
            return [[self localMenuSignal] merge:[self updateMenuSignal]];
        }];
        
        [_menuCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *menuModels) {            
            NSArray *tmpMenuModels = [menuModels sortedArrayUsingComparator:^NSComparisonResult(FSShelfMenuData * obj1, FSShelfMenuData * obj2) {
                
                NSInteger index1 = [obj1.server[@"index"] integerValue];
                NSInteger index2 = [obj2.server[@"index"] integerValue];
                if(index1 == index2)
                {
                    return NSOrderedSame;
                }
                else if(index1 > index2)
                {
                    return NSOrderedDescending;
                }
                else
                {
                    return NSOrderedAscending;
                }
            }];
            
            if(tmpMenuModels.count > maxTotalCount)
            {
                self.menuModels = [tmpMenuModels subarrayWithRange:NSMakeRange(0, maxTotalCount)];
            }
            else
            {
                self.menuModels = tmpMenuModels;
            }
            
        }];
        
    }
    return self;
}

- (RACSignal *)updateMenuSignal
{
    RACSignal *singal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        BOOL isDebug = [EnvironmentInfo sharedInstance].isDebugEnvironment;
        
        NSString *groupKey = FSShelfMenuGroupKey;
        
        FSGroupHiveConfigRequest *request = [[FSGroupHiveConfigRequest alloc] initWithGroup:groupKey debugMode:isDebug];
        
        [request startWithCompletionBlockWithSuccess:^(__kindof CMBaseRequest * _Nonnull request) {
            
            NSUInteger code = [request.responseJSONObject CM_intForKey:@"code"];
            if (code != 0) {
                NSError *error = [NSError errorWithDomain:@"com.hangzhoucaimi.finance"
                                                     code:code
                                                 userInfo:@{
                                                            @"Reason": @"RequestCodeError",
                                                            @"Module": FSShelfModelName
                                                            }];
                [subscriber sendError:error];
                return;
            }
            
            NSDictionary *dataDic = [request.responseJSONObject CM_dictionaryForKey:@"data"];
            NSArray *configs = [dataDic CM_arrayForKey:@"config"];
            
            __block NSDictionary *configDataDic;
            __block NSString *dataStringInData;
            
            NSMutableArray *configGroup = [[NSMutableArray alloc] init];
            
            [configs enumerateObjectsUsingBlock:^(id  _Nonnull configData, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![configData isKindOfClass:[NSDictionary class]]) {
                    NSError *error = [NSError errorWithDomain:@"com.hangzhoucaimi.finance"
                                                         code:code
                                                     userInfo:@{
                                                                @"Reason": @"ConfigDataError",
                                                                @"Module": FSShelfModelName
                                                                }];
                    [subscriber sendError:error];
                    return;
                }
                
                NSString *configKeyInData = [configData CM_stringForKey:@"key"];
                dataStringInData = [configData CM_stringForKey:@"data"];
                configDataDic = [dataStringInData CM_JsonStringToDictionary];
                if([configDataDic CM_isValidDictionary])
                {
                    //生成数据模型
                    FSShelfMenuData *menuData = [FSShelfMenuData yy_modelWithJSON:configDataDic];
                    menuData.configKey = configKeyInData;
                    
                    [configGroup addObject:menuData];
                }
                
            }];
            
            NSError *tmpError;
            NSString *groupConfigString = [dataDic CM_toJSONStringWithError:&tmpError];
            //数据缓存
            [self updateLocalGroupConfig:groupConfigString groupKey:groupKey];
            
            [subscriber sendNext:[configGroup copy]];
            [subscriber sendCompleted];
            
            
        } failure:^(__kindof CMBaseRequest * _Nonnull request) {
            
            [subscriber sendError:request.error];
            
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    return singal;
}

- (RACSignal *)localMenuSignal {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSArray *groupConfig = [self localGroupConfig:FSShelfMenuGroupKey];
        if(groupConfig)
        {
            [subscriber sendNext:groupConfig];
        }
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{}];
    }];
    return signal;
}

//standardUserDefaults data
- (void)updateLocalGroupConfig:(NSString*)groupConfigString groupKey:(NSString *)groupKey
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",[CMAppProfile sharedInstance].mUIDBlock(), groupKey];
    [[NSUserDefaults standardUserDefaults] setObject:groupConfigString forKey:key];
}

- (NSString *)groupConfigFromStandardUserDefaults:(NSString *)groupKey
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",[CMAppProfile sharedInstance].mUIDBlock(), groupKey];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return str;
}

- (NSArray *)localGroupConfig:(NSString *)groupKey
{
    NSString * dataString = [self groupConfigFromStandardUserDefaults:groupKey];
    if(dataString.length <= 0)
    {
        //暂时不启用打底配置
        //NSString *bundleName = @"SdkFinanceShelf";
        //dataString = [self loadGroupConfigStringFromBundle:bundleName groupKey:groupKey];
    }
    
    NSDictionary *dataDic = [dataString CM_JsonStringToDictionary];
    if(dataDic)
    {
        __block NSDictionary *configDataDic;
        __block NSString *dataStringInData;
        NSMutableArray *configGroup = [[NSMutableArray alloc] init];
        NSArray *configArray = [dataDic CM_arrayForKey:@"config"];
        
        [configArray enumerateObjectsUsingBlock:^(id  _Nonnull configData, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *configKeyInData = [configData CM_stringForKey:@"key"];
            dataStringInData = [configData CM_stringForKey:@"data"];
            configDataDic = [dataStringInData CM_JsonStringToDictionary];
            if([configDataDic CM_isValidDictionary])
            {
                //生成数据模型
                FSShelfMenuData *menuData = [FSShelfMenuData yy_modelWithJSON:configDataDic];
                menuData.configKey = configKeyInData;
                [configGroup addObject:menuData];
            }
            
        }];
        
        return [configGroup copy];
    }
    return nil;
}


- (NSString *)loadGroupConfigStringFromBundle:(NSString *)bundleName groupKey:(NSString *)groupKey
{
    NSString *path = [[NSBundle mainBundle] pathForResource:groupKey ofType:@"json"];
    NSError *error = nil;
    NSString *configString = [NSString stringWithContentsOfFile:path
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    if (!error) {
        [self updateLocalGroupConfig:configString groupKey:groupKey];
        return configString;
    } else {
        return @"";
    }
}


- (NSArray *)parseResponseDic:(NSDictionary *)responseDic {
    
    NSArray *funArray     = [responseDic fs_objectMaybeNilForKey:@"funcs" ofClass:[NSArray class]];
    NSArray *resultArray  = [funArray.rac_sequence map:^id(id value) {
        return [FSShelfMenuData yy_modelWithJSON:value];
    }].array;
    
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    [tmp addObjectsFromArray:resultArray];
    resultArray = [tmp copy];
    
    return resultArray;
}


//一行的数量
- (NSInteger)rowCountForNum:(NSInteger)num
{
    if(num <= 4)
    {
        return num;
    }
    
    if(num == 5 || num == 6)
    {
        return 3;
    }
    
    return 4;
}

//整体高度
- (NSInteger)cellHeightForNum:(NSInteger)num
{
    NSInteger rowCount = [self rowCountForNum:num];
    NSInteger lineCount = 0;
    if(num % rowCount == 0)
    {
        lineCount = num/rowCount;
    }
    else
    {
        lineCount = num/rowCount + 1;
    }
    
    //行高 + 中间间距 + 上留白 + 下留白
    NSInteger cellHeight = lineCount * 56 + (lineCount - 1) * 10 + FSSchelfMenuCellTopInsets + FSSchelfMenuCellBottomInsets;
    return cellHeight;
}

@end
