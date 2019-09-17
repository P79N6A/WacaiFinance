//
//  TPKSuperMiddleware+FSDefaultDomain.m
//  WcbFinanceApp
//
//  Created by tesila on 2019/6/14.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "TPKSuperMiddleware+FSDefaultDomain.h"
#import <JRSwizzle/JRSwizzle.h>

@implementation TPKSuperMiddleware (FSDefaultDomain)

/**
由于 Default Domain 为空的情况会导致 Planck 在 debug 模式下频繁触发断言影响正常开发
考虑到其他业务线不能同步升级 Planck 仍需要兼容（暂不能直接重写 Middleware）
因此 Hock 测试版本的对应方法对 domain 为空时返回默认值进行容错
**/
#ifdef kTestAppURL
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(defaultDomain);
        SEL swizzledSelector = @selector(fs_defaultDomain);
        NSError *error = nil;
        [TPKSuperMiddleware jr_swizzleMethod:originalSelector withMethod:swizzledSelector error:&error];
        CMAssertCondDesc(error.code == 0, error.description);
    });
}
#endif

- (TPKWebviewDomain *)fs_defaultDomain {
    TPKWebviewDomain *middlewareDomain = [self fs_defaultDomain]; // Selector 已被交换->实际得到 Middleware Default Domain
    return middlewareDomain ?: [TPKWebviewDomain domainWithHost:@"*" path:nil];
}


@end
