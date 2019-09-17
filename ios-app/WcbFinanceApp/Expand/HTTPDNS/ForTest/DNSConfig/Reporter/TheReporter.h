//
//  TheReporter.h
//  HTTPDNSExample
//
//  Created by 破山 on 2018/11/20.
//  Copyright © 2018年 Wacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSReporter.h"
#import "FSLogReporter.h"

@interface TheReporter : FSLogReporter

@property (nonatomic, strong) NSMutableString *log;

@end
