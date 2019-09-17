//
//  ButtonCell.h
//  HttpdnsDemoExample
//
//  Created by 破山 on 2018/11/19.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *button;

- (void)fillContent:(NSString *)content;

@end
