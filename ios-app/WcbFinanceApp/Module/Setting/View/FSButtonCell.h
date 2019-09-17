//
//  FSButtonCell.h
//  WcbFinanceApp
//
//  Created by howie on 2019/9/4.
//  Copyright © 2019 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSButtonCell : UITableViewCell

@property(nonatomic,strong) UIButton *subscribeButton;
- (void)configButtonTitle:(NSString *)title;
- (void)configButtonTitle:(NSString *)title backgroundColor:(UIColor *)color;

@end

