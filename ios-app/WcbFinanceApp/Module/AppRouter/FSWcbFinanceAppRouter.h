//
//  FSWcbFinanceAppRouter.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/6/20.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Neutron.h>

@interface FSWcbFinanceAppRouter : NSObject


#pragma mark - 货架
/**
 基金原 H5 货架页面 统跳接口 | nt://WcbFinanceApp/fund-shelf 对应的 H5 target
 @return 基金原 H5 货架页面 ViewController 由调用方自行/使用统跳进行界面跳转
 */
TNT_TARGET("WcbFinanceApp_fund-shelf_1529477880171_2")
+ (UIViewController *_Nullable)financeAppH5FundShelfWithQS:(NSString *_Nullable)qs context:(TNTRoutingContext *_Nullable)context;

TNT_TARGET("WcbFinanceApp_go-to-fund_1554108109191_1")
+ (UIViewController *_Nullable)switchToFundShelfWithQS:(NSString *_Nullable)qs context:(TNTRoutingContext *_Nullable)context;


#pragma mark - 设置
TNT_TARGET("WcbFinanceApp_account-info_1540199735364_1")
+ (UIViewController *_Nullable)gotoFSAccountInfoWithQS:(NSString *_Nullable)qs context:(TNTRoutingContext *_Nullable)context;

TNT_TARGET("WcbFinanceApp_customer-center_1539331582165_1")
+ (UIViewController *_Nullable)gotoFSCustomerServiceWithQS:(NSString *_Nullable)qs context:(TNTRoutingContext *_Nullable)context;

TNT_TARGET("WcbFinanceApp_binding-info_1539592043570_1")
+ (UIViewController *_Nullable)gotoFSBindingInfoWithQS:(NSString *_Nullable)qs context:(TNTRoutingContext *_Nullable)context;

TNT_TARGET("WcbFinanceApp_password-management_1539593920916_1")
+ (UIViewController *_Nullable)gotoFSPwdManagementWithQS:(NSString *_Nullable)qs context:(TNTRoutingContext *_Nullable)context;

TNT_TARGET("WcbFinanceApp_feedback_1539595005307_1")
+ (UIViewController *_Nullable)gotoHelpFeedbackWithQS:(NSString *_Nullable)qs context:(TNTRoutingContext *_Nullable)context;

TNT_TARGET("WcbFinanceApp_about-us_1539597981604_1")
+ (UIViewController *_Nullable)gotoAboutUsWithQS:(NSString *_Nullable)qs context:(TNTRoutingContext *_Nullable)context;

TNT_TARGET("WcbFinanceApp_more-settings_1539598521064_1")
+ (UIViewController *_Nullable)gotoMoreSettingsWithQS:(NSString *_Nullable)qs context:(TNTRoutingContext *_Nullable)context;

#pragma mark - Thana
TNT_TARGET("WcbFinanceApp_open-thana_1544668801307_1")
+ (UIViewController *_Nullable)openThanaWithQS:(NSString *_Nullable)qs context:(TNTRoutingContext *_Nullable)context;

#pragma mark - GotoUtility
TNT_TARGET("WcbFinanceApp_switch-tab_1568011624481_1")
+ (UIViewController *_Nullable)switchTabToHomeWithQS:(NSString *_Nullable)qs context:(TNTRoutingContext *_Nullable)context;


@end
