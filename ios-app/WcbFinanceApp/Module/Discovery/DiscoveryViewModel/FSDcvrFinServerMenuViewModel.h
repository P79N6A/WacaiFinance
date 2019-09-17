//
//  FSDcvrFinServerMenuViewModel.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/11.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDcvrBaseViewModel.h"

@interface FSDcvrFinServerMenuViewModel : FSDcvrBaseViewModel

@property (nonatomic, strong) NSArray *menuArray;

- (NSInteger)heightForMenus;

@end
