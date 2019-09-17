//
//  FSDiscoveryTypeTitleData.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/5/29.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSDiscoveryTypeTitleData : NSObject<IGListDiffable>

@property(nonatomic, copy) NSString *name; //标题名称
@property(nonatomic, copy) NSString *classifyId;  //产品分类ID
@property(nonatomic, strong) NSArray *tags;   //产品tag，如高端理财，无tag可不进行赋值
@property(nonatomic, copy) NSString *desc;  //标题栏右侧描述信息，无描述信息可不进行赋值
@property (nonatomic, copy) NSString *titleURL;   //标题栏跳转链接,不支持点击可不进行赋值

@end
