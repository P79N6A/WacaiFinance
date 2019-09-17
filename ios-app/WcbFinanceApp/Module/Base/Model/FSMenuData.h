//
//  FSMenuData.h
//  FinanceApp
//
//  Created by xingyong on 7/26/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSMenuData : NSObject<IGListDiffable>
@property(nonatomic, copy) NSString *eventId;//BI埋点ID
@property(nonatomic, copy) NSString *eventCode;//莲子埋点Code
@property(nonatomic, copy) NSString *funcId;// = "<null>";
@property(nonatomic, copy) NSString *iconSrc;// = "https://s1.wacdn.com/wis/264/25006ae8ead24036_84x84.png";
@property(nonatomic, copy) NSString *name;// = "\U9080\U8bf7\U62ff\U5956\U52b1";
@property(nonatomic, copy) NSString *tipIconSrc;// = "<null>";
@property(nonatomic, copy) NSString *url;// = "https://site.wacai.com/page/1635?a_f=674_YQHY0513_001&device=mob&ignore=1&wacaiClientNav=1&need_zinfo=1";
@property(nonatomic, assign) BOOL status;

@end
