//
//  FSDiscoveryFinancialServiceSectionController.m
//  WcbFinanceApp
//
//  Created by 破山 on 2018/4/10.
//  Copyright © 2018年 Hangzhou Wacai Internet Financial Services CO., LTD. All rights reserved.
//

#import "FSDiscoveryFinancialServiceSectionController.h"
#import "FSDiscoveryFinancialServiceCell.h"
#import "FSDiscoverFServiceMenuCell.h"
#import "FSMenuData.h"
//#import <Neutron.h>
#import <NeutronBridge/NeutronBridge.h>
#import "FSDcvrFinServerMenuViewModel.h"
#import <NativeQS/NQSParser.h>
#import <CMUIViewController/UIViewController+CMUtil.h>
#import <i-Finance-Library/FSSDKGotoUtility.h>



@interface FSDiscoveryFinancialServiceSectionController()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) FSDcvrFinServerMenuViewModel *viewModel;

@end

@implementation FSDiscoveryFinancialServiceSectionController

- (void)dealloc
{
    NSLog(@"Dealloc %@", self);
}

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    return CGSizeMake(screenWidth, [_viewModel heightForMenus]);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    Class cellClass = [FSDiscoveryFinancialServiceCell class];
    id cell = [self.collectionContext dequeueReusableCellOfClass:cellClass
                                            forSectionController:self
                                                         atIndex:index];
    FSDiscoveryFinancialServiceCell *serviceCell = (FSDiscoveryFinancialServiceCell *)cell;
    
    serviceCell.collectionView.dataSource = self;
    serviceCell.collectionView.delegate = self;
    
    return serviceCell;
}


- (void)didUpdateToObject:(id)object {
    _viewModel = object;
}

#pragma mark - 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *menuArray= self.viewModel.menuArray;
    return menuArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSDiscoverFServiceMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FSDiscoverFServiceMenuCell cellIdentifer] forIndexPath:indexPath];
    
    FSMenuData *menuData = [self.viewModel.menuArray fs_objectAtIndex:indexPath.row];
    
    NSInteger count = self.viewModel.menuArray.count;
    BOOL show = NO;
    if(count % 2 == 0)
    {
        show = indexPath.row < (count - 2) ? YES : NO;
    }
    else
    {
        show = indexPath.row < (count - 1) ? YES : NO;
    }
    [cell fillContent:menuData showBottomline:show];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = layout.sectionInset;
    NSInteger width = (collectionView.bounds.size.width - insets.left - insets.right)/2.0;
    
    return CGSizeMake(width, 60);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select indexPath %@", indexPath);
    
    FSMenuData *menuData = [self.viewModel.menuArray fs_objectAtIndex:indexPath.row];
    
    [self doMenuSelected:menuData viewController:self.viewController];
}

- (void)doMenuSelected:(FSMenuData *)menu viewController:(UIViewController *)viewController
{
    if ([menu.url CM_isValidString]) {
    
        NSString *eventCode = SafeString(menu.eventCode);
        if ([eventCode CM_isValidString]) {
            
            NSString *version = Release_App_Ver;
            NSString *name = menu.name;
            
            NSMutableDictionary *att = [[NSMutableDictionary alloc] init];
            [att setValue:SafeString(version) forKey:@"version"];
            [att setValue:SafeString(name) forKey:@"name"];
            
            [UserAction skylineEvent:eventCode attributes:@{@"lc_name":name}];
        }
        
        
        // 由于后端接口不支持按版本控制下发，此处对服务窗 URL 进行兼容性处理
        if([menu.url isEqualToString:@"wacai://treasure"]){
            
 
            NSDictionary *param = @{
                                    @"need_back_btn"         : @(YES),
                                    @"intercept_urlstr"      : @[@""],
                                    @"filter_param"          : @"",
                                    @"statusbar_style"       : @(UIStatusBarStyleLightContent),
                                    @"supported_choose_fund" : @(NO),
                                    @"has_bottombar"         : @(NO),
                                    @"has_new_version"       : @(YES),
                                    };
            NSString *source = [NSString stringWithFormat:@"%@?%@", @"nt://sdk-window/open", [NQSParser queryStringifyObject:param]];
            UIViewController * fromVC = [UIViewController CM_curViewController];
            NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:fromVC];
            [ns ntWithSource:source
          fromViewController:fromVC
                  transiaion:NTBViewControllerTransitionPush
                      onDone:^(NSString * _Nullable result) {
                          
                      } onError:^(NSError * _Nullable error) {
                          
                      }];

            
        } else if([[[NSURL URLWithString:menu.url] scheme] isEqualToString:@"nt"]) {
            
            NSString *source = [NSString stringWithFormat:@"%@", menu.url];
            UIViewController * fromVC = [UIViewController CM_curViewController];
            NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:fromVC];
            [ns ntWithSource:source
          fromViewController:fromVC
                  transiaion:NTBViewControllerTransitionPush
                      onDone:^(NSString * _Nullable result) {
                          
                      } onError:^(NSError * _Nullable error) {
                          
                      }];
            
           
            
        }else if ([menu.url containsString:@"wacai://bbs.home"]) {
            
            NSDictionary *param = @{@"showBackButton" : @(YES)};
            NSString *source = [NSString stringWithFormat:@"%@?%@", @"nt://sdk-bbs2/homepage", [NQSParser queryStringifyObject:param]];
            UIViewController * fromVC = [UIViewController CM_curViewController];
            NeutronStarter *ns = [NeutronProvider neutronStarterWithViewController:fromVC];
            [ns ntWithSource:source
          fromViewController:fromVC
                  transiaion:NTBViewControllerTransitionPush
                      onDone:^(NSString * _Nullable result) {
                          
                      } onError:^(NSError * _Nullable error) {
                          
                      }];
            
          
            
        }else{
            
            [FSSDKGotoUtility openURL:menu.url from:viewController];
            
        }
    }
}






@end
