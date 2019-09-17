//
//  FSDcvrTypeTitleCell.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/5/29.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDcvrTypeTitleCell.h"

@interface FSDcvrTypeTitleCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *verticalView;
@property (nonatomic, strong) UIImageView *rightArrow;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) NSMutableArray<UILabel *> *tagLabelsArray;

@end

@implementation FSDcvrTypeTitleCell

-(void)setTitleData:(FSDiscoveryTypeTitleData *)titleData {
    _titleData = titleData;
    self.titleLabel.text = _titleData.name;
    [self addRightViewsIfNecessary];
    [self addTagsView];
}

- (void)addRightViewsIfNecessary {
    [self.detailLabel removeFromSuperview];
    [self.rightArrow removeFromSuperview];
    BOOL hasDesc = _titleData.desc && _titleData.desc.length > 0;
    BOOL canClick = _titleData.titleURL && _titleData.titleURL.length > 0;
    
    //是否有右侧描述信息
    if (hasDesc) {
        [self.contentView addSubview:self.detailLabel];
        self.detailLabel.text = _titleData.desc;
        //是否可点击跳转
        if (canClick) {
            [self.contentView addSubview:self.rightArrow];
            [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-16);
                make.centerY.equalTo(self.mas_centerY);
            }];
            
            [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.rightArrow.mas_left).offset(-2);
                make.centerY.equalTo(self.mas_centerY);
            }];
            
        }else {
            [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-16);
                make.centerY.equalTo(self.mas_centerY);
            }];
        }
        
    } else {
        if (canClick) {
            [self.contentView addSubview:self.rightArrow];
            [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-16);
                make.centerY.equalTo(self.mas_centerY);
            }];
        }
    }
}

- (void)addTagsView {
    [self.tagLabelsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabelsArray removeAllObjects];
    if (self.titleData.tags.count == 0) {
        return;
    }
    
    [self.titleData.tags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *tagLabel = [self tagLabelFactory];
        [self.tagLabelsArray addObject:tagLabel];
        NSString *tagName = (NSString *)obj;
        tagLabel.text = tagName;
        
        CGRect textFrame = [tagName boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{@"NSFontAttributeName": [UIFont systemFontOfSize:10]} context:nil];
        
        if (idx == 0) {
            [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_titleLabel.mas_right).offset(4);
                make.height.mas_equalTo(textFrame.size.height + 5);
                make.width.mas_equalTo(textFrame.size.width + 4);
                make.centerY.mas_equalTo(self.mas_centerY);
            }];
        } else {
            [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.tagLabelsArray[idx - 1].mas_right).offset(4);
                make.height.mas_equalTo(textFrame.size.height + 5);
                
                make.width.mas_equalTo(textFrame.size.width + 4);
                make.centerY.mas_equalTo(self.mas_centerY);
            }];
        }
    }];
}

- (UILabel *)tagLabelFactory{
    UILabel *tagLabel = [[UILabel alloc] init];
    tagLabel.font = [UIFont systemFontOfSize:10];
    tagLabel.textColor = [UIColor colorWithHexString:@"#D94B40"];
    tagLabel.layer.borderColor = [UIColor colorWithHexString:@"#D94B40"].CGColor;
    tagLabel.layer.borderWidth = .5f;
    tagLabel.layer.cornerRadius = 1;
    tagLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:tagLabel];
    return tagLabel;
}

- (void)setupSubviews{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.verticalView = [[UIView alloc] init];
    self.verticalView.backgroundColor = [UIColor colorWithRed:220/255. green:220/255. blue:220/255. alpha:1];
    self.verticalView.layer.cornerRadius = 1;
    
    [self.contentView addSubview:self.verticalView];
    
    [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(2);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verticalView.mas_right).offset(8);
        make.centerY.equalTo(_verticalView.mas_centerY);
    }];
}

- (void)adjustForDiscovery
{
    [self.verticalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(2);
    }];
    
    self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.0];
    if(font)
    {
        _titleLabel.font = font;
    }
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        
        _detailLabel                 = [[UILabel alloc] init];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.textColor       = [UIColor colorWithHexString:@"#999999"];
        _detailLabel.font            = [UIFont systemFontOfSize:12];
        _detailLabel.textAlignment   = NSTextAlignmentLeft;
    }
    return _detailLabel;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        
        _titleLabel                 = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor       = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font            = [UIFont boldSystemFontOfSize:12];
        _titleLabel.textAlignment   = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

-(UIImageView *)rightArrow {
    if (!_rightArrow) {
        _rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(0., 0., 8., 14.)];
        _rightArrow.image = [UIImage imageNamed:@"arrow_gray"];
    }
    
    return _rightArrow;
}

- (NSMutableArray<UILabel *> *)tagLabelsArray {
    if (!_tagLabelsArray) {
        _tagLabelsArray = [[NSMutableArray alloc] init];
    }
    return _tagLabelsArray;
}

@end
