//
//  MGFaceIDLiveDetectManager.h
//  MGFaceIDLiveDetect
//
//  Created by MegviiDev on 2018/6/21.
//  Copyright © 2018年 Megvii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGFaceIDLiveDetectConfig.h"
#import "MGFaceIDLiveDetectError.h"
#import "MGFaceIDLiveDetectLanguageConfig.h"
#import "MGFaceIDLiveDetectCustomConfigItem.h"

@interface MGFaceIDLiveDetectManager : NSObject

/**
 初始化 FaceID 活体检测 Manager
 由于 bizTokenStr 的唯一性，每一次调用 startMGFaceIDLiveDetectWithCurrentController:callback: 检测方法都需要重新初始化该 Manager.

 @param bizTokenStr 业务串号
 @param languageType 选择语言种类
 @param hostUrl 网络请求host地址
 @param extraDict 预留信息。非必选参数，可以为nil
 @param error 初始化错误信息
 @return 初始化对象
 */
- (instancetype _Nullable)initMGFaceIDLiveDetectManagerWithBizToken:(NSString *__nonnull)bizTokenStr
                                                           language:(MGFaceIDLiveDetectLanguageType)languageType
                                                        networkHost:(NSString *__nullable)hostUrl
                                                          extraData:(NSDictionary *__nullable)extraDict
                                                              error:(MGFaceIDLiveDetectError *_Nullable*__nonnull)error;

/**
 开启 FaceID 活体检测

 @param detectVC 启动检测的当前页面
 @param block 检测结果
 */
- (void)startMGFaceIDLiveDetectWithCurrentController:(UIViewController *__nonnull)detectVC
                                            callback:(MGFaceIDLiveDetectResultBlock __nonnull)block;



/**
 设置 FaceID 活体检测的垂直检测类型

 @param verticalType 垂直检测类型
 */
- (void)setMGFaceIDLiveDetectPhoneVertical:(MGFaceIDLiveDetectPhoneVerticalType)verticalType;

/**
 设置 FaceID 活体检测的自定义UI效果

 @param configItem 自定义UI配置
 */
- (void)setMGFaceIDLiveDetectCustomUIConfig:(MGFaceIDLiveDetectCustomConfigItem *__nullable)configItem;


/**
 获取 SDK 版本号信息
 
 @return SDK 版本号
 */
+ (NSString *_Nonnull)getSDKVersion;

/**
 获取 SDK 构建信息
 
 @return SDK 构建号
 */
+ (NSString *_Nonnull)getSDKBuild;

@end
