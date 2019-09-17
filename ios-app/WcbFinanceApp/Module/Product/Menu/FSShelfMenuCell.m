//
//  FSShelfMenuCell.m
//  WcbFinanceApp
//
//  Created by 破山 on 2019/3/4.
//  Copyright © 2019年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSShelfMenuCell.h"
#import "FSShelfMenuData.h"
#import "UIView+FSUtils.h"
#import <Masonry/Masonry.h>
#import <CMNSString/CMNSString.h>
#import "FSSDKMenuItemCell.h"
#import <i-Finance-Library/FSEventStatisticsAction.h>
#import <i-Finance-Library/FSSDKGotoUtility.h>


@interface FSShelfMenuCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger rowCount;

@end


@implementation FSShelfMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupSubViews];
        self.rowCount = 3;
    }
    return self;
}

- (void)setupSubViews
{
    if(!self.collectionView)
    {
        //初始化
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(20, 20);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;
        
        extern NSInteger FSSchelfMenuCellTopInsets;
        extern NSInteger FSSchelfMenuCellBottomInsets;
        
        layout.sectionInset = UIEdgeInsetsMake(FSSchelfMenuCellTopInsets, 0, FSSchelfMenuCellBottomInsets, 0);
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
        self.collectionView.scrollEnabled = NO;
        
        [self.collectionView registerClass:[FSSDKMenuItemCell class] forCellWithReuseIdentifier:@"FSSDKMenuItemCell"];
        
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.contentView addSubview:self.collectionView];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.left.right.equalTo(self.contentView);
            
        }];
    }
}

- (void)fillContent:(NSArray *)menuArray
            isNewer:(BOOL)isNewer
           rowCount:(NSInteger)rowCount
{
    self.menuArray = menuArray;
    self.isNewer = isNewer;
    self.rowCount = rowCount;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.menuArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSSDKMenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FSSDKMenuItemCell" forIndexPath:indexPath];
    
    FSShelfMenuData *menuData = [self.menuArray fs_objectAtIndex:indexPath.row];
    [cell fillContent:menuData];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.contentView.width / self.rowCount;
    CGSize size = CGSizeMake(width, 65);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select indexPath is %@", indexPath);
    //跳转动作
    
    FSShelfMenuData *menu = [_menuArray fs_objectAtIndex:indexPath.row];
    
    if ([menu.url  CM_isValidString]) {
        if ([menu.eventCode CM_isValidString]) {
            [FSEventAction skylineEvent:menu.eventCode ?:@"" attributes:@{@"lc_newer":self.isNewer ? @"1":@"0",@"lc_name":menu.name ?:@""}];
        }
        
        [FSSDKGotoUtility openURL:menu.url from:self.fs_parentViewController];
    }
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
