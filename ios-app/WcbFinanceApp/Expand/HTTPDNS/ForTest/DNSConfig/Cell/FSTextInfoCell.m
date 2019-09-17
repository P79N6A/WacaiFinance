//
//  FSTextInfoCell.m
//  HttpdnsDemoExample
//
//  Created by 破山 on 2018/11/19.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSTextInfoCell.h"
#import "NSURLRequest+FSUtils.h"
#import "NSAttributedString+FSUtil.h"

@interface FSTextInfoCell()

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;

@end

@implementation FSTextInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentLabel.font = [UIFont systemFontOfSize:13.0];
    self.contentLabel.numberOfLines = 0; //多行
    self.contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)fillContent:(NSString *)content
{
    self.contentLabel.text = content;
}

+ (NSInteger)heightForString:(NSString *)string
{
    if(!string)
    {
        return 0;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, string.length)];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat height = [str heightForFixWdith:width - 46];
    if(height < 50)
    {
        height = 50;
    }
    return height;
}

@end
