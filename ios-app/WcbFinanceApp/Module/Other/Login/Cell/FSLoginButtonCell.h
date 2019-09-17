//
//  FSLoginButtonCell.h
//  WcbFinanceApp
//
//  Created by 破山 on 2018/11/9.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSLoginButtonCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *button;

- (void)setEnable:(BOOL)enable;
- (BOOL)enable;

- (void)fillContent:(NSString *)content;

@end
