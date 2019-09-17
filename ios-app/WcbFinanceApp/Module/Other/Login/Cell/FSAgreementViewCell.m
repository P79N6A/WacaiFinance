//
//  FSAgreementViewCell.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/11/13.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSAgreementViewCell.h"
#import "FSAgreementView.h"

@implementation FSAgreementViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
