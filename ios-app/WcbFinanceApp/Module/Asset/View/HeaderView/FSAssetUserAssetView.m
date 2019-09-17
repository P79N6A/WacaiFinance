//
//  FSAssetUserAssetView.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/25.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSAssetUserAssetView.h"
#import "UIView+FSUtils.h"
#import "UIColor+FSUtils.h"

@interface FSAssetUserAssetView ()
@property (nonatomic, strong) UILabel     *navAssetLabel;//上滑之后，显示的总金额

@end

@implementation FSAssetUserAssetView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHex:0xd84a3f];
        [self setupBaseView];
        
    }
    return self;
}
- (void)setupBaseView{
    [self addSubview:self.navAssetLabel];
    [self.navAssetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(26);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-8);
    }];
    
    
    
}
- (void)setProductData:(FSProductData *)productData{
    _productData = productData;
    
    [self hiddenMoney];
    
}

- (void)hiddenMoney{
    BOOL isFlag = [[NSUserDefaults standardUserDefaults] boolForKey:@"kMoneyFalg"];
    if (isFlag) {
        self.navAssetLabel.text   = @"总资产  * * * * *";
    }
    else{
        self.navAssetLabel.text   = [NSString stringWithFormat:@"总资产  %@元",StringValue(self.productData.mtext1)];
    }
    
}

- (UILabel *)navAssetLabel{
    if (!_navAssetLabel) {
        _navAssetLabel                 = [[UILabel alloc] init];
        _navAssetLabel.textColor       = [UIColor whiteColor];
        _navAssetLabel.font            = [UIFont systemFontOfSize:15];
        _navAssetLabel.backgroundColor = [UIColor clearColor];
        _navAssetLabel.textAlignment   = NSTextAlignmentRight;
        
    }
    return _navAssetLabel;
}


inline static NSString *StringValue(id obj)
{
    if([obj isKindOfClass:[NSString class]]){
        return (NSString *)obj;
    }else if ([obj isKindOfClass:[NSNull class]]|| obj == nil) {
        return  @"";
    }else if ([obj isKindOfClass:[NSNumber class]]) {
        return  [NSString stringWithFormat:@"%@",[obj description]];
    } else{
        return @"";
    }
    return @"";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
