//
//  MGFaceIDLiveDetectConfig.h
//  MGFaceIDLiveDetect
//
//  Created by MegviiDev on 2018/6/21.
//  Copyright © 2018年 Megvii. All rights reserved.
//

#ifndef MGFaceIDLiveDetectConfig_h
#define MGFaceIDLiveDetectConfig_h

@class MGFaceIDLiveDetectError;

//  活体检测错误类型
typedef enum : NSUInteger {
    MGFaceIDLiveDetectErrorNone                         = 1000,   //  没有错误 SDK 活体检测完成
    MGFaceIDLiveDetectErrorIllegalParameter             = 4200,   //  传入的参数不合法
    MGFaceIDLiveDetectErrorBizTokenDenied               = 4200,   //  传入的biz_token不符合要求
    MGFaceIDLiveDetectErrorAuthenticationFail           = 4200,   //  鉴权失败
    MGFaceIDLiveDetectErrorMobilePhoneNotSupport        = 4200,   //  手机不在支持列表里
    MGFaceIDLiveDetectErrorSDKTooOld                    = 4200,   //  SDK版本过旧，已经不被支持
    
    MGFaceIDLiveDetectErrorUserCancel                   = 6000,   //  用户取消活体检测
    MGFaceIDLiveDetectErrorNotResource                  = 6000,   //  未添加资源包
    MGFaceIDLiveDetectErrorNotCameraPermission          = 6000,   //  APP没有获取相机权限
    MGFaceIDLiveDetectErrorNotCameraSupport             = 6000,   //  APP未找到可用的相机设备
    MGFaceIDLiveDetectErrorFaceInitFail                 = 6000,   //  SDK活体检测启动失败
    MGFaceIDLiveDetectErrorNetWorkNotConnected          = 6000,   //  连不上互联网，请检查网络连接状态
    MGFaceIDLiveDetectErrorOnvalidBundleID              = 6000,   //  APP信息验证失败，请检测bundleID设置
    MGFaceIDLiveDetectErrorBackGround                   = 6000,   //  活体检测阶段因APP进入后台导致检测失败
    MGFaceIDLiveDetectErrorLiveFail                     = 6000,   //  SDK 活体检测失败
    MGFaceIDLiveDetectErrorUnknown                      = 6200,   //  未知错误
    MGFaceIDLiveDetectErrorTimeOut                      = 9000,   //  操作超时，由于用户在长时间没有进行操作
} MGFaceIDLiveDetectErrorType;


//  活体检测手机垂直检测类型，默认值为`MGFaceIDLiveDetectPhoneVerticalFront`
typedef enum : NSUInteger {
    MGFaceIDLiveDetectPhoneVerticalFront            = 0,            //  仅在开始的2s内启用，2s后关闭该功能
    MGFaceIDLiveDetectPhoneVerticalContinue         = 1,            //  持续启用
    MGFaceIDLiveDetectPhoneVerticalDisable          = 2,            //  禁用
} MGFaceIDLiveDetectPhoneVerticalType;

/**
 FaceID活体检测结果Block

 @param error 错误信息
 @param deltaData 活体检测结果
 @param bizTokenStr 用户进行活体检测业务串号
 @param extraOutDataDict 预留信息
 */
typedef void(^MGFaceIDLiveDetectResultBlock)(MGFaceIDLiveDetectError* error, NSData* deltaData, NSString* bizTokenStr, NSDictionary* extraOutDataDict);

#endif /* MGFaceIDLiveDetectConfig_h */
