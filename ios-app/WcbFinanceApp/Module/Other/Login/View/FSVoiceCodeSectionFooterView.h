//
//  FSVoiceCodeSectionFooterView.h
//  FinanceApp
//
//  Created by Alex on 12/2/15.
//  Copyright © 2015 com.wacai.licai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonActionBlock)();

@interface FSVoiceCodeSectionFooterView : UIView

@property (nonatomic, copy) ButtonActionBlock buttonActonBlock;

- (void)setVoiceButtonEnable:(BOOL)enable;
@end
