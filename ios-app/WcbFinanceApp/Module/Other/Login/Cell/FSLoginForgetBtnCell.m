//
//  FSLoginForgetBtnCell.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/11/13.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSLoginForgetBtnCell.h"

@interface FSLoginForgetBtnCell()

@property (nonatomic, weak) IBOutlet UIButton *forgetBtn;
@end

@implementation FSLoginForgetBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.forgetBtn setTitleColor:[UIColor colorWithHexString:@"449bff"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onForgetBtnTapped:(id)sender
{
    NSLog(@"forgetBtn");
    //to do block
    if(self.actionBlock)
    {
        self.actionBlock();
    }
}

@end
