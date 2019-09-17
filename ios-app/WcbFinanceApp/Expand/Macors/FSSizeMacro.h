//
//  FSSizeMacro.h
//  FinanceApp
//
//  Created by Alex on 3/16/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#ifndef FSSizeMacro_h
#define FSSizeMacro_h

//屏幕尺寸 方法
#define FinanceScreenWidth [[UIScreen mainScreen] bounds].size.width
#define FinanceScreenHeight [[UIScreen mainScreen] bounds].size.height

//View尺寸 方法
#define GetRight(view) (view.frame.size.width + view.frame.origin.x)
#define GetDown(tview) (tview.frame.size.height + tview.frame.origin.y)


//常用尺寸
#define DEFAULT_HEARDER_HEIGHT      20
#define DEFAULT_FOOTER_HEIGHT       20
#define DEFAULT_CELL_HEIGHT         50
#define DEFAULT_TITLE_HEADER_HEIGHT 40
#define DEFAULT_TITLE_FOOTER_HEIGHT 40

#define NAV_BAR_HEIGHT              (IOS7_ATLEAST ? 64 : 44)
#define STATUS_HEIGHT               (IOS7_ATLEAST ? 20 : 0)
#define TAB_BAR_HEIGHT              49

#define  FS_iPhoneX (FinanceScreenWidth == 375.f && FinanceScreenHeight == 812.f ? YES : NO)

// Status bar height.
#define  FS_StatusBarHeight      (FS_iPhoneX ? 44.f : 20.f)
#define  FS_NavigationBarHeight  (FS_iPhoneX ? 88.f : 64.f)
#define  FS_TabbarHeight         (FS_iPhoneX ? (49.f+34.f) : 49.f)







#endif /* FSSizeMacro_h */
