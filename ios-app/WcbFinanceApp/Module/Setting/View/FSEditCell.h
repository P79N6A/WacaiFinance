//
//  FSEditCell.h
//  Financeapp
//
//  Created by xingyong on 14/10/2017.
//  Copyright © 2017 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^FSEditActionBlock)(NSString *text);

@interface FSEditCell : UITableViewCell

@property(nonatomic, strong) UITextField *editTextField;

@property(nonatomic, copy)  FSEditActionBlock editActionBlock;

@end
