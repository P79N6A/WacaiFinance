//
//  FSLaunchManager.m
//  WcbFinanceApp
//
//  Created by xingyong on 2018/5/14.
//  Copyright © 2018 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSLaunchSplashManager.h"
#import "XHLaunchAd.h"
#import "FSSplashRequest.h"
#import "FSStartPageData.h"
#import "AppDelegate.h"
#import "FSWelcomeSlidesViewController.h"
#import "FSTouchIDHelper.h"
#import <CMDevice/CMDevice.h>
#import "FSLaunchSplashManager+FSUtils.h"
#import <FSHiveConfig/FSHCManager.h>
#import "FSSplashDebugConfig.h"

@implementation FSLaunchSplashManager

static NSString *const kSplashDebugConfig = @"SplashDebugConfig";

+(void)load{
    [self sharedInstance];
}

 
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static FSLaunchSplashManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}


- (instancetype)init{
    self = [super init];
    if (self) {
        //在UIApplicationDidFinishLaunching时初始化开屏广告,做到对业务层无干扰,当然你也可以直接在AppDelegate didFinishLaunchingWithOptions方法中初始化
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self updateDebugInfoIfNeeded];
            //初始化开屏广告
            [self setupXHLaunchAd];
        }];
    }
    return self;
}


-(void)setupXHLaunchAd{
    
    //如果首次有引导页，闪屏不显示
    if ([FSWelcomeSlidesViewController shouldShow]) {
        return;
    }
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    
    [XHLaunchAd setWaitDataDuration:1];
    
    //广告数据请求
    FSSplashRequest *request = [[FSSplashRequest alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof CMBaseRequest * _Nonnull request) {
        
        if(!request.responseObject){
            return ;
        }
        NSLog(@"闪屏接口返回数据  ==== %@",request.responseObject );
        NSDictionary *responseDic = [request.responseObject fs_objectMaybeNilForKey:@"data"];
        NSArray *resultArray      = [responseDic fs_objectMaybeNilForKey:@"startPage"];
        
        if([resultArray count] == 0){
            [self showTouchID];
            return ;
        }
        NSDictionary *resultDic   = [resultArray fs_objectAtIndex:0];
        FSStartPageData *pageData = [FSStartPageData modelObjectWithDictionary:resultDic];
        if ([pageData.mimgUrls count] == 0) {
            [self showTouchID];
            return;
        }
 
        //配置广告数据
        XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
        //广告停留时间
        imageAdconfiguration.duration = 2.5;
        //广告frame
        imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        if([pageData.mimgUrls isKindOfClass:[NSArray class]]){
        
            NSString *imgUrl = [self getImageUrl:pageData.mimgUrls];
            
            imageAdconfiguration.imageNameOrURLString = imgUrl;
            
            NSString *mid;
            if(pageData.mid)
            {
                mid = [NSString stringWithFormat:@"%@", pageData.mid];
            }
            else
            {
                mid = @"";
            }
            
            
            
            NSDictionary *attributes = @{@"lc_banner_id": mid,
                                         @"lc_name":pageData.mpageName ?: @"",
                                         @"lc_banner_url":imgUrl ?: @"",
                                         @"lc_jump_url":pageData.mlinkUrl ?: @""
                                         };
            
            [UserAction skylineEvent:@"finance_wcb_splash_enter_page" attributes:attributes];
            
            
        }
        
        //设置GIF动图是否只循环播放一次(仅对动图设置有效)
        imageAdconfiguration.GIFImageCycleOnce = NO;
        //缓存机制(仅对网络图片有效)
        //为告展示效果更好,可设置为XHLaunchAdImageCacheInBackground,先缓存,下次显示
        imageAdconfiguration.imageOption = XHLaunchAdImageDefault;
        //图片填充模式
        imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
        //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
        imageAdconfiguration.openModel = pageData;
        //广告显示完成动画
        imageAdconfiguration.showFinishAnimate = [self finishAnimateType];
        //广告显示完成动画时间
        imageAdconfiguration.showFinishAnimateTime = 0.8;
        //跳过按钮类型
        imageAdconfiguration.skipButtonType = SkipTypeNone;
        //后台返回时,是否显示广告
        imageAdconfiguration.showEnterForeground = NO;
        
        imageAdconfiguration.subViews = [self alreadyView];
        
        NSDictionary *attributes = @{@"shouldShow": @([self shouldShowSplash]),
                                     @"animateType": @([self finishAnimateType])
                                     };
        [UserAction skylineEvent:@"finance_wcb_splash_debug_config" attributes:attributes];

        
        if ([self shouldShowSplash]) {
            //显示开屏广告
            [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
        } else {
            [self showTouchID];
        }
        
        
    } failure:^(__kindof CMBaseRequest * _Nonnull request) {
        NSLog(@"request ------- %@",request);
        [self showTouchID];
    }];
 
}


-(void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
    
    if(!openModel){
        return;
    }
    
    FSStartPageData *pageData = (FSStartPageData *)openModel;
    
    if(![pageData.mimgUrls isKindOfClass:[NSArray class]]){
        return ;
    }
    
    NSString *imgUrl = [self getImageUrl:pageData.mimgUrls];
    
    NSString *mid;
    if(pageData.mid)
    {
        mid = [NSString stringWithFormat:@"%@", pageData.mid];
    }
    else
    {
        mid = @"";
    }
    
    
    NSDictionary *attributes = @{@"lc_banner_id": mid,
                                 @"lc_name":pageData.mpageName ?: @"",
                                 @"lc_banner_url":imgUrl ?: @"",
                                 @"lc_jump_url":pageData.mlinkUrl ?: @""
                                 };
    
    [UserAction skylineEvent:@"finance_wcb_splash_banner_click" attributes:attributes];
    

    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate launchSplashUrl:pageData.mlinkUrl];
    
    
}
-(void)xhLaunchAdShowFinish:(XHLaunchAd *)launchAd{
    
    NSLog(@"广告显示完成");
    [self showTouchID];
}
- (void)showTouchID{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [FSTouchIDHelper verifyTouchIDIfAppAvailableWithSuccessAction:^{
        
        [appdelegate dismissGestureLock];
    }];
}

-(NSArray<UIView *> *)alreadyView{
    
    NSString *imageName = [CMDevice sharedInstance].isIPhoneX ? @"launch_bottom_iphoneX" : @"launch_bottom_logo";
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat ratio = image.size.height / image.size.width;
    CGFloat screenWidth = [CMDevice sharedInstance].screenSize.width;
    CGFloat screenHeight = [CMDevice sharedInstance].screenSize.height;
    CGFloat viewHeight = screenWidth * ratio;
    
    UIImageView *imageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, screenHeight - viewHeight, screenWidth, viewHeight);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = image;
        imageView;
    });
    
    return [NSArray arrayWithObject:imageView];
    
}

#pragma mark - Debug for Crash
- (BOOL)shouldShowSplash {
    if (IOS_VERSION >= 10.0) {
        // iOS 10 及以上未见该类型 Crash 不作额外处理
        return YES;
    } else {
        // iOS 9 及其以下控制 Splash 是否展示并观察数据以定位问题
        FSSplashDebugConfig *config = [HIVE_CONFIG localCacheOfKey:kSplashDebugConfig class:[FSSplashDebugConfig class]];
        BOOL shouldShowSplash = config ? config.shouldShow : YES;
        
        return shouldShowSplash;
    }
}

- (ShowFinishAnimate)finishAnimateType {
    if (IOS_VERSION >= 10.0) {
        // iOS 10 及以上未见该类型 Crash 不作额外处理
        return ShowFinishAnimateLite;
    } else {
        // iOS 9 及其以下控制 Splash 动画类型并观察数据以定位问题
        FSSplashDebugConfig *config = [HIVE_CONFIG localCacheOfKey:kSplashDebugConfig class:[FSSplashDebugConfig class]];
        BOOL shouldShowAnimate = config ? config.shouldAnimate : YES;
        ShowFinishAnimate type = shouldShowAnimate ? ShowFinishAnimateLite: ShowFinishAnimateNone;
        return type;
    }
}

- (void)updateDebugInfoIfNeeded {
    if (IOS_VERSION >= 10.0) {
        // iOS 10 及以上未见该类型 Crash 不作额外处理
        return;
    }
    [HIVE_CONFIG fetchKey:kSplashDebugConfig class:[FSSplashDebugConfig class] completion:^(BOOL isSuccess, id  _Nullable object) {
        
    }];
}

@end
